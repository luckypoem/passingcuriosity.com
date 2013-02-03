{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Applicative           (Alternative (..), (<$>))
import           Control.Arrow ((>>>), (>>^), (***), arr)
import           Control.Monad                 (msum)
import           Data.Monoid         (Monoid (..), mappend, mconcat, mempty)
import           Prelude             hiding (id)
import           System.FilePath
import qualified Text.Pandoc         as Pandoc
import           Hakyll



--------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration

feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle       = "Passing Curiosity"
    , feedDescription = ""
    , feedAuthorName  = "Thomas Sutton"
    , feedRoot        = "http://passingcuriosity.com/"
    , feedAuthorEmail = "me@thomas-sutton.id.au"
    }


--------------------------------------------------------------------------------

main :: IO ()
main = hakyllWith config $ do

    -- Compile templates
    match "templates/*" $ compile templateCompiler

    -- Compress CSS
    match "css/**.css" $ do
        route   $ idRoute
        compile compressCssCompiler

    -- Compress JS
    match "js/*" $ do
        route   idRoute
        compile copyFileCompiler

    -- Copy static resources
    match ("img/*" .||. "favicon.ico" .||. "files/**") $ do
        route   idRoute
        compile copyFileCompiler

    -- Build tags
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")

    tagsRules tags $ \tag pattern -> do
        let title = "Posts tagged " ++ tag

        route routeTags
        compile $ do
            list <- postList tags pattern recentFirst
            makeItem ""
                >>= loadAndApplyTemplate "templates/posts.html"
                        (constField "title" title `mappend`
                            constField "posts" list `mappend`
                            defaultContext)
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls

        -- Create an Atom feed as well
        version "rss" $ do
            route   $ routeTags `composeRoutes` setExtension "xml"
            compile $ loadAllSnapshots pattern "content"
                >>= return . take 10 . recentFirst
                >>= renderAtom (feedConfiguration) (feedCtx tags)

    -- Posts
    match "posts/*" $ do
        route   $ routePosts
        compile $ do
            pandocCompiler
                >>= saveSnapshot "content"
                >>= return . fmap demoteHeaders
                >>= loadAndApplyTemplate "templates/post.html" (postCtx tags)
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls

    create ["posts.html"] $ do
        route idRoute
        compile $ do
            list <- postList tags "posts/*" recentFirst
            let indexCtx = field "posts" $ \_ -> postList tags "posts/*" recentFirst
            makeItem ""
                >>= loadAndApplyTemplate "templates/posts.html"
                        (constField "title" "All Posts" `mappend`
                            constField "posts" list `mappend`
                            defaultContext)
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls

    match "index.md" $ do
      route $ setExtension "html"
      compile $ do
        let indexCtx = field "posts" $ \_ -> postList tags "posts/*" (take 10 . recentFirst)

        -- Work around Pandoc processing maths by applying the $posts$ context,
        -- then manually processing with Pandoc.
        getResourceBody
            >>= applyAsTemplate indexCtx
            >>= return . renderPandoc
            >>= loadAndApplyTemplate "templates/index.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

--------------------------------------------------------------------------------

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
                          in joinPath ["tags", t, "index.html"]

-- | Absolute url to the resulting item
strippedUrlField :: String -> Context a
strippedUrlField key = field key $
    fmap (maybe empty strippedUrl) . getRoute . itemIdentifier
    where strippedUrl = dropFileName . toUrl

--------------------------------------------------------------------------------

postList :: Tags -- ^ Collection of tags in the site.
         -> Pattern -- ^ Pattern to identify appropriate posts.
         -> ([Item String] -> [Item String]) -- ^ Filter for posts.
         -> Compiler String
postList tags pattern sortFilter = do
    posts   <- sortFilter <$> loadAll pattern
    itemTpl <- loadBody "templates/postitem.html"
    list    <- applyTemplateList itemTpl (postCtx tags) posts
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
    , constField "excerpt" ""
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
