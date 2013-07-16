{-# LANGUAGE OverloadedStrings #-}

import           Control.Applicative (empty, (<$>))
import           Control.Monad (liftM)
import qualified Data.Map as M
import           Data.Monoid (mappend, mconcat)
import           System.FilePath

import           Hakyll hiding (defaultContext)
import           Text.Pandoc.Options


--------------------------------------------------------------------------------
hakyllConf :: Configuration
hakyllConf = defaultConfiguration
  { deployCommand = "rsync -ave 'ssh' _site/ passingcuriosity.com:/var/www/passingcuriosity.com/htdocs"
  }

feedConf :: FeedConfiguration
feedConf = FeedConfiguration
    { feedTitle       = "Passing Curiosity"
    , feedDescription = ""
    , feedAuthorName  = "Thomas Sutton"
    , feedAuthorEmail = "me@thomas-sutton.id.au"
    , feedRoot        = "http://passingcuriosity.com/"
    }


--------------------------------------------------------------------------------

main :: IO ()
main = hakyllWith hakyllConf $ do
    -- Copy static resources
    match ("img/*" .||. "favicon.ico" .||. "files/**") $ do
        route   idRoute
        compile copyFileCompiler

    -- Compress CSS
    match "css/**.css" $ do
        route   idRoute
        compile compressCssCompiler

    -- Compress JS
    match "js/*" $ do
        route   idRoute
        compile copyFileCompiler

    -- Compile standard pages
    match (fromList ["contact.md", "about.md"]) $ do
      route   $ routeFileToDirectory
      compile $ do
        pandocCompiler
            >>= saveSnapshot "content"
            >>= return . fmap demoteHeaders
            >>= loadAndApplyTemplate "templates/page.html" defaultContext
            >>= saveSnapshot "post"
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    -- Build tags
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")

    -- Posts
    match "posts/*" $ do
        route   $ routePosts
        compile $ pandocCompiler
          >>= saveSnapshot "content"
          >>= return . fmap demoteHeaders
          >>= loadAndApplyTemplate "templates/post.html" (postCtx tags)
          >>= saveSnapshot "post"
          >>= loadAndApplyTemplate "templates/default.html" defaultContext
          >>= relativizeUrls

    -- Generate archives.
    match "archives.md" $ do
      route $ routeFileToDirectory
      compile $ do
        posts <- recentFirst =<< loadAll "posts/*"
        let indexCtx =
              listField "posts" (postCtx tags) (return posts) `mappend`
              defaultContext

        getResourceBody
          >>= applyAsTemplate indexCtx
          >>= return . renderPandoc
          >>= loadAndApplyTemplate "templates/index.html" defaultContext
          >>= loadAndApplyTemplate "templates/default.html" indexCtx
          >>= relativizeUrls

    tagsRules tags $ \tag pattern -> do
        let title = "Posts tagged " ++ tag

        route routeTags
        compile $ do
            posts <- recentFirst =<< loadAll pattern
            let number = length posts
            let ctx = constField "title" title `mappend`
                      constField "tag" tag `mappend`
                      constField "number" (show number) `mappend`
                      listField "posts" (postCtx tags) (return posts) `mappend`
                      defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/tag.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

        -- Create an RSS feed as well
        version "rss" $ do
            route   $ routeTags `composeRoutes` setExtension "rss"
            compile $ loadAllSnapshots pattern "content"
                >>= fmap (take 10) . recentFirst
                >>= renderRss (feedConf) (feedCtx tags)

        -- Create an Atom feed as well
        version "atom" $ do
            route   $ routeTags `composeRoutes` setExtension "xml"
            compile $ loadAllSnapshots pattern "content"
                >>= fmap (take 10) . recentFirst
                >>= renderAtom (feedConf) (feedCtx tags)


    match "index.md" $ do
      route $ setExtension "html"
      compile $ do
        posts <- fmap (take 10) . recentFirst =<< loadAll "posts/*"
        let indexCtx =
              listField "posts" (postCtx tags) (return posts) `mappend`
              defaultContext

        getResourceBody
          >>= applyAsTemplate indexCtx
          >>= return . renderPandoc
          >>= loadAndApplyTemplate "templates/index.html" defaultContext
          >>= loadAndApplyTemplate "templates/default.html" indexCtx
          >>= relativizeUrls

    -- Compile templates
    match "templates/*" $ compile templateCompiler

--------------------------------------------------------------------------------

-- | Route files to directory indexes.
routeFileToDirectory :: Routes
routeFileToDirectory = customRoute fileToDirectory
  where fileToDirectory :: Identifier -> FilePath
        fileToDirectory ident = let p = toFilePath ident
                                    fn = takeFileName p
                                    bn = dropExtension fn
                                in joinPath [bn, "index.html"]

-- | Route dated posts.
routePosts :: Routes
routePosts = customRoute fileToDirectory
  where fileToDirectory :: Identifier -> FilePath
        fileToDirectory ident = let p = toFilePath ident
                                    fn = takeFileName p
                                    bn = drop 11 $ dropExtension fn
                                    y = take 4 fn
                                in joinPath [y, bn, "index.html"]

-- | Route tag pages.
routeTags :: Routes
routeTags = customRoute tagPath
    where tagPath ident = let p = toFilePath ident
                              fn = takeFileName p
                              t = dropExtension fn
                          in joinPath ["tag", t, "index.html"]

-- | Absolute url to the resulting item
strippedUrlField :: String -> Context a
strippedUrlField key = field key $
    fmap (maybe empty strippedUrl) . getRoute . itemIdentifier
    where strippedUrl = dropFileName . toUrl

--------------------------------------------------------------------------------

{-
postList :: Tags -- ^ Collection of tags in the site.
         -> Pattern -- ^ Pattern to identify appropriate posts.
         -> ([Item String] -> [Item String]) -- ^ Filter for posts.
         -> Compiler String
-}
postList tags pattern sortFilter = do
    posts   <- loadAll pattern
    sorted <- sortFilter posts
    itemTpl <- loadBody "templates/postitem.html"
    list    <- applyTemplateList itemTpl (postCtx tags) sorted
    return list

--------------------------------------------------------------------------------

-- | Build a post template context.
postCtx :: Tags -> Context String
postCtx tags = mconcat
    [ modificationTimeField "mtime" "%U"
    , strippedUrlField "url"
    , urlField "urllol"
    , dateField "date" "%B %e, %Y"
    , tagsField "tags" tags
    , constField "author" "Thomas Sutton"
    , defaultContext
    , maybeMetadataField
    ]

defaultContext :: Context String
defaultContext =
    bodyField     "body"     `mappend`
    metadataField            `mappend`
    urlField      "url"      `mappend`
    pathField     "path"     `mappend`
    titleField    "title"


--------------------------------------------------------------------------------
-- | Map any field to its metadata value, if present
maybeMetadataField :: Context String
maybeMetadataField = Context $ \key item -> do
    metadata <- getMetadata $ itemIdentifier item
    case M.lookup key metadata of
      Nothing -> fmap StringField . return $ ""
      Just v  -> fmap StringField . return $ v

-- | Build a tag template context.
pageCtx :: Context String
pageCtx = mconcat
    [ strippedUrlField "url"
    , defaultContext
    ]

-- | Build a tag template context.
tagCtx :: Context String
tagCtx = mconcat
    [ strippedUrlField "url"
    , defaultContext
    ]

-- | Build a feed template context.
--
-- XXXTODO: Add categories, etc.
feedCtx :: Tags -> Context String
feedCtx _ = mconcat
    [ bodyField "description"
    , defaultContext
    ]

--------------------------------------------------------------------------------
-- Compilers
--------------------------------------------------------------------------------

-- | Compile images
resizeImageCompiler = copyFileCompiler
