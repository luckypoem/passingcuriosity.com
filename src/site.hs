{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Arrow ((>>>), (***), arr)
import           Control.Applicative ((<$>))
import           Data.Monoid         (mappend, mconcat)
import           Prelude             hiding (id)
import           System.FilePath     (replaceExtension, takeDirectory, takeFileName, joinPath)
import qualified Text.Pandoc         as Pandoc

import Hakyll
-- import Hakyll.Web.Pagination

resizeImageCompiler = copyFileCompiler


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

    -- Post tags
    tagsRules tags $ \tag pattern -> do
        let title = "Posts tagged " ++ tag

        -- Copied from posts, need to refactor
        route idRoute
        compile $ do
            list <- postList tags pattern recentFirst
            makeItem ""
                >>= loadAndApplyTemplate "templates/posts.html"
                        (constField "title" title `mappend`
                            constField "posts" list `mappend`
                            defaultContext)
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls

        -- Create RSS feed as well
        version "rss" $ do
            route   $ setExtension "xml"
            compile $ loadAllSnapshots pattern "content"
                >>= return . take 10 . recentFirst
                >>= renderAtom (feedConfiguration) feedCtx

    -- Render each and every post
    match "posts/*" $ do
        route   $ setExtension "html"
        compile $ do
            pandocCompiler
                >>= saveSnapshot "content"
                >>= return . fmap demoteHeaders
                >>= loadAndApplyTemplate "templates/post.html" (postCtx tags)
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls

    {-
    create "posts.html" $ constA mempty
        >>> applyTemplateCompiler "templates/posts.html"
        >>> applyTemplateCompiler "templates/default.html"
    -}

    -- Post list
    create ["posts.html"] $ do
        route idRoute
        compile $ do
            list <- postList tags "posts/*" recentFirst
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
        list <- postList tags "posts/*" (take 5 . recentFirst)
        pandocCompiler
          >>= loadAndApplyTemplate "templates/index.html" 
                (constField "posts" list `mappend` defaultContext)
          >>= loadAndApplyTemplate "templates/default.html" defaultContext
          >>= relativizeUrls

{-
    -- Archive
    create "archives" $
      requireAll "posts/*" (\_ ps -> readArchives defaultPager ps :: Archives String)
      
    -- Add an archive page for every tag.
    match "archives/*" $ route $ setExtension ".html"
    metaCompile $ require_ "archives"
      >>> arr archivePages
      >>> arr (map (\(p,t,ps) -> (archiveIdentifier p, makeArchivePage p t ps)))
-}

{-
    -- Render RSS feed
    match "rss.xml" $ route idRoute
    create "rss.xml" $ requireAll_ "posts/*"
      >>> mapCompiler (arr $ copyBodyToField "description")
      >>> renderRss feedConfiguration

    -- Render Atom feed
    match "atom.xml" $ route idRoute
    create "atom.xml" $ requireAll_ "posts/*"
      >>> mapCompiler (arr $ copyBodyToField "description")
      >>> renderAtom feedConfiguration
-}

    -- Read templates
    match "templates/*" $ compile templateCompiler

-- | Route dated posts.
routePosts = matchRoute "posts/[0-9]{4}-[0-9]{2}-[0-9]{2}-" $ customRoute prettify
  where dropDate = drop 11
        getDate = take 4
        prettify pid = let fn = takeFileName . toFilePath $ pid
                           slug = dropDate fn
                           date = getDate fn
                       in joinPath ["posts", date, slug, "index.html"]


--------------------------------------------------------------------------------
postList :: Tags -> Pattern -> ([Item String] -> [Item String])
         -> Compiler String
postList tags pattern preprocess' = do
    postItemTpl <- loadBody "templates/postitem.html"
    posts       <- preprocess' <$> loadAll pattern
    applyTemplateList postItemTpl (postCtx tags) posts

--------------------------------------------------------------------------------
-- | Build a post template context.
postCtx :: Tags -> Context String
postCtx tags = mconcat
    [ modificationTimeField "mtime" "%U"
    , dateField "date" "%B %e, %Y"
    , tagsField "tags" tags
    , constField "author" "Thomas Sutton"
    , constField "excerpt" ""
    , constField "previous" ""
    , constField "next" ""    
    , defaultContext
    ]

--------------------------------------------------------------------------------
-- | Build a feed template context.
feedCtx :: Context String
feedCtx = mconcat
    [ bodyField "description"
    , defaultContext
    ]

