{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Applicative
import           Control.Monad
import qualified Data.ByteString.Lazy            as LBS
import           Data.Hashable
import           Data.List
import qualified Data.Map                        as M
import           Data.Maybe
import           Data.Monoid
import           Data.String
import           Hakyll                          hiding (defaultContext)
import           Network.URL
import           System.FilePath
import           Text.Blaze.Html                 (toHtml, toValue, (!))
import           Text.Blaze.Html.Renderer.String (renderHtml)
import qualified Text.Blaze.Html5                as BH
import qualified Text.Blaze.Html5.Attributes     as BA
import qualified Text.HTML.TagSoup               as TS
import           Text.Pandoc

{-# ANN module ("HLint: ignore Use liftM" :: String) #-}

--------------------------------------------------------------------------------
-- * Configuration
--------------------------------------------------------------------------------

twitterUser :: String
twitterUser = "@thsutton"

amazonUSTag :: String
amazonUSTag = "passingcuriosity-20"

-- | Site configuration
hakyllCfg :: Configuration
hakyllCfg = defaultConfiguration
  { deployCommand = "rsync -rlpve 'ssh' _site/ thomas@passingcuriosity.com:/srv/passingcuriosity.com/htdocs"
  }

feedCfg :: FeedConfiguration
feedCfg = FeedConfiguration
    { feedTitle = "Passing Curiosity: Latest posts"
    , feedDescription = "Latest posts from Passing Curiosity."
    , feedAuthorName = "Thomas Sutton"
    , feedAuthorEmail = "me@thomas-sutton.id.au"
    , feedRoot = "http://passingcuriosity.com/"
    }

specialFeed :: String -> FeedConfiguration
specialFeed cat = feedCfg
    { feedTitle = "Passing Curiosity: Posts tagged " <> cat
    , feedDescription = "Latest posts tagged with " <> cat <> " from Passing Curiosity."
    }

-- | Number of posts to list on a page.
pageSize :: Int
pageSize = 10

-- | Pandoc reader options.
readerOptions :: ReaderOptions
readerOptions = defaultHakyllReaderOptions

-- | Pandoc write options.
writerOptions :: WriterOptions
writerOptions = defaultHakyllWriterOptions
    { writerHTMLMathMethod = MathJax ""
    }

main :: IO ()
main = hakyllWith hakyllCfg $ do
    match "templates/*" $
        compile templateCompiler

    match ("files/**" .||. "favicon.*") $ do
        route   idRoute
        compile copyFileCompiler

    match "assets/css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "assets/js/*" $ do
        route   idRoute
        compile compressJsCompiler

    match "assets/fonts/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "assets/img/*" $ do
        version "large" $ do
            route   $ routeImage "large"
            compile   largeImageCompiler

        version "small" $ do
            route   $ routeImage "small"
            compile   smallImageCompiler

    --
    -- Tags
    --

    tags <- buildTags "posts/*" (fromCapture "tags/*.html")
    let postCtx = postContext tags
    let feedCtx = feedContext tags
    let tagCtx = tagContext tags
    let defaultCtx = defaultContext tags

    --
    -- Content
    --

    match "errors/*" $ do
        route $ setExtension "html"
        compile $ do
            let ctx = sectionField "error" <>
                      defaultCtx

            contentCompiler
                >>= loadAndApplyTemplate "templates/error.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx

    match "posts/*" $ do
        route routePosts
        compile $ do
            let ctx = postCtx

            contentCompiler
                >>= saveSnapshot "content"
                >>= loadAndApplyTemplate "templates/post.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    --
    -- Index
    --

    match "index.md" $ do

        -- HTML page
        route routePage
        compile $ do
            posts <- fmap (take 3) . recentFirst =<<
                loadAll ("posts/*" .&&. hasNoVersion)

            let ctx =
                    sectionField "about" <>
                    numberedListField "posts" postCtx (return posts) <>
                    tagCloudField' "tagcloud" 75.0 300.0 tags <>
                    defaultCtx

            getResourceBody
                >>= applyAsTemplate ctx
                >>= return . renderPandoc -- contentCompiler
                >>= loadAndApplyTemplate "templates/page.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    match ("about.md" .||. "contact.md" .||. "tags.md") $ do
        route routePage
        compile $ do
            let ctx =
                    sectionField "about" <>
                    tagCloudField' "tagcloud" 75.0 300.0 tags <>
                    defaultCtx

            getResourceBody
                >>= applyAsTemplate ctx
                >>= return . renderPandoc -- contentCompiler
                >>= loadAndApplyTemplate "templates/page.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    --
    -- Archives
    --

    paginated_archives <- buildPaginateWith
        (sortRecentFirst >=> return . paginateEvery pageSize)
        "posts/*"
        (\n -> fromFilePath $ if n == 1 then "archives.md" else "archives" </> show n <> ".md")

    paginateRules paginated_archives $ \page_number pattern -> do
        -- Build feeds of the archives.
        when (1 == page_number) $ do
            -- Atom feed
            version "atom" $ do
                route $ customRoute (const "atom.xml")
                compile $
                    loadAllSnapshots pattern "content"
                        >>= renderAtom feedCfg feedCtx

            -- RSS feed
            version "rss" $ do
                route $ customRoute (const "feed.rss")
                compile $
                    loadAllSnapshots pattern "content"
                        >>= renderRss feedCfg feedCtx

        -- Build the archive pages.
        route routeFileToDirectory
        compile $ do
            posts <- recentFirst =<< loadAll pattern

            let title = if page_number == 1
                    then "Archives"
                    else "Archives: Page " <> show page_number
            let ctx =
                    sectionField "archive" <>
                    constField "layout" "page" <>
                    constField "title" title <>
                    numberedListField "posts" postCtx (return posts) <>
                    paginateContext paginated_archives page_number <>
                    defaultCtx

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    --
    -- Tags
    --

    tagsRules tags $ \tag tag_pattern -> do

        let title = "Posts tagged " <> tag

        paginated_tags <- buildPaginateWith
            (sortRecentFirst >=> return . paginateEvery pageSize)
            tag_pattern
            (\n -> fromFilePath $ if n == 1
                then "tags" </> tag </> "index.html"
                else "tags" </> tag </> show n </> "index.html")

        let feed = specialFeed tag

        paginateRules paginated_tags $ \page_number pattern -> do
            -- If this is the FIRST page, create feeds.
            when (1 == page_number) $ do
                -- Atom feed
                version "atom" $ do
                    route $ setExtension "xml"
                    compile $ loadAllSnapshots tag_pattern "content"
                        >>= renderAtom feed feedCtx

                -- RSS feed
                version "rss" $ do
                    route $ setExtension "rss"
                    compile $ loadAllSnapshots tag_pattern "content"
                        >>= renderRss feed feedCtx

            -- Make the current page.
            version ("page" <> show page_number) $ do
                route idRoute
                compile $ do
                    all_posts <- recentFirst =<< loadAll (tag_pattern .&&. hasNoVersion)
                    let number = length (all_posts :: [Item String])

                    posts <- recentFirst =<< loadAll (pattern .&&. hasNoVersion)

                    let excerpt = "There are " <> show number <> " posts tagged with "
                                <> tag <> "."
                    let ctx = constField "title" title <>
                            constField "tag" tag <>
                            constField "number" (show number) <>
                            constField "excerpt" excerpt <>
                            numberedListField "posts" postCtx (return posts) <>
                            paginateContext paginated_tags page_number <>
                            feedsField (Just . fromString $ "tags" </> tag </> "index.html") <>
                            tagCtx tag

                    makeItem ""
                        >>= loadAndApplyTemplate "templates/tag.html" ctx
                        >>= loadAndApplyTemplate "templates/default.html" ctx
                        >>= relativizeUrls

--------------------------------------------------------------------------------
-- * Routing
--------------------------------------------------------------------------------

routeImage :: String -> Routes
routeImage size = customRoute fn
  where
    fn :: Identifier -> FilePath
    fn i = let (p,f) = splitFileName $ toFilePath i
           in p </> size </> f

-- | Route top-level pages to the appropriate URL.
--
-- The @index.md@ page is routed to the top-level @/index.html@ URL, all other
-- pages are routed to @/$name/index.html@.
routePage :: Routes
routePage = customRoute pageR
  where
    pageR :: Identifier -> FilePath
    pageR ident =
        case toFilePath ident of
            "index.md" -> "index.html"
            p -> let (dir,fn) = splitFileName p
                     bn = dropFileName fn
                 in joinPath [dir, bn, "index.html"]

-- | Route files to directory indexes.
routeFileToDirectory :: Routes
routeFileToDirectory = customRoute fileToDirectory
  where fileToDirectory :: Identifier -> FilePath
        fileToDirectory ident = let p = toFilePath ident
                                    (dir,fn) = splitFileName p
                                    bn = dropExtension fn
                                in joinPath [dir, bn, "index.html"]

-- | Route posts to @$year$/$title$/index.html@.
routePosts :: Routes
routePosts = customRoute fileToDirectory
  where
    fileToDirectory :: Identifier -> FilePath
    fileToDirectory ident =
        let p = toFilePath ident
            fn = takeFileName p
            bn = drop 11 $ dropExtension fn
            y = take 4 fn
        in joinPath [y, bn, "index.html"]

--------------------------------------------------------------------------------
-- * Contexts
--------------------------------------------------------------------------------

postContext :: Tags -> Context String
postContext tags = mconcat
    [ modificationTimeField "mdate" "%B %e, %Y"
    , modificationTimeField "mdatetime" "%Y-%m-%d"
    , dateField "date" "%B %e, %Y"
    , dateField "datetime" "%Y-%m-%d"
    , tagsField' "tags" tags
    , sectionField "archive"
    , constField    "author" (feedAuthorName feedCfg)
    , constField    "author-meta" (feedAuthorName feedCfg)
    , defaultContext tags
    ]

feedContext :: Tags -> Context String
feedContext tags =
    postContext tags <>
    bodyField "description"


tagContext :: Tags -> b -> Context String
tagContext tags _ =
    tagCloudField' "tagcloud" 75.0 300.0 tags <>
    sectionField "tags" <>
    constField "layout" "page" <>
    defaultContext tags

defaultContext :: Tags -> Context String
defaultContext _ =
    tocField      "contents" <>
    bodyField     "body"     <>
    metadataField            <>
    strippedUrlField "url"   <>
    pathField     "path"     <>
    titleField    "title"    <>

    imageField "image" <>

    constField "twitter_card" "summary" <>
    constField "twitter_site" twitterUser <>
    constField "twitter_creator" twitterUser <>
    titleField "twitter_title" <>

    feedsField (Just "archives.md") <>

    sectionField  "page" <>
    missingField
  where
    dropFN :: [String] -> Item a -> Compiler String
    dropFN [fn] _ = return . dropFileName $ fn
    dropFN _ _ = error "Called dropFileName with no arguments"

    firstFN :: [String] -> Item a -> Compiler String
    firstFN ss _ = case ss of
        [] -> error "Called first with no arguments"
        _  -> return . worker $ ss
      where
        worker [] = mempty
        worker (h:r) | null h    = worker r
                     | otherwise = h

--------------------------------------------------------------------------------
-- ** Fields
--------------------------------------------------------------------------------

-- | A 'listField' which adds an @item-number@ field to the context.
numberedListField :: String -> Context a -> Compiler [Item a] -> Context b
numberedListField key ctx items =
    let ctx' = ctx <> listNumberField "item-number" items
    in listField key ctx' items

-- | Extend a 'Context' with an item's position in a list.
listNumberField :: String -> Compiler [Item a] -> Context b
listNumberField key items = field key $
    fmap (maybe empty show) . getNumber . itemIdentifier
  where
    getNumber :: Identifier -> Compiler (Maybe Int)
    getNumber ident = do
        idents <- items
        return . fmap (+1) . elemIndex ident $ fmap itemIdentifier idents

-- | Feeds URL field.
feedsField :: Maybe Identifier -> Context a
feedsField ident = case ident of
    Nothing  -> mempty
    Just pid -> feedField "atom" pid <>
                feedField "rss"  pid
  where
    feedField name an_id = field
        (name <> "_feed")
        (\_ -> fmap (maybe empty toUrl) . getRoute . setVersion (Just name) $ an_id)


tagsField' :: String -> Tags -> Context a
tagsField' =
    tagsFieldWith
        getTags
        simpleRenderLink
        (mconcat . intersperse ", ")
  where
    simpleRenderLink :: String -> Maybe FilePath -> Maybe BH.Html
    simpleRenderLink tag Nothing         =
      Just . (BH.a ! BA.href (toValue . dropFileName $ "/" </> "tags" </> tag </> "index.html")) $ toHtml tag
    simpleRenderLink tag (Just filePath) =
      Just . (BH.a ! BA.href (toValue . dropFileName $ "/" </> filePath)) $ toHtml tag

-- | Context to de-/activate menu entries.
sectionField :: String -> Context a
sectionField s = constField "section" s <>
                 constField ("section_" <> s) s

-- | Make a tag cloud.
tagCloudField' :: String -> Double -> Double -> Tags -> Context a
tagCloudField' key =
    tagCloudFieldWith key makeLink (unwords . filter (not . null))
  where
    makeLink minSize maxSize tag _url count min' max'
        | count <= 2 = mempty
        | otherwise  =
            -- Show the relative size of one 'count' in percent
            let diff     = 1 + fromIntegral max' - fromIntegral min'
                relative = (fromIntegral count - fromIntegral min') / diff
                size     = floor $ minSize + relative * (maxSize - minSize) :: Int
            in renderHtml
                 . (BH.a ! BA.style (toValue $ "font-size: " <> show size <> "%")
                         ! BA.href (toValue . dropFileName $ "/" </> "tags" </> tag </> "index.html"))
                 $ toHtml tag

-- | Absolute url to the resulting item
strippedUrlField :: String -> Context a
strippedUrlField key = field key $
    fmap (maybe empty strippedUrl) . getRoute . itemIdentifier
  where
    strippedUrl = dropFileName . toUrl

-- | If the "toc" field is defined in the context, replace it with the table
-- of contents markup generated by Pandoc.
tocField :: String -> Context String
tocField name = field name $ \item -> do
  value <- getMetadataField (itemIdentifier item) name
  case value of
    Nothing -> empty
    Just v -> if null v
              then empty
              else itemBody <$> tocCompiler

-- | Select an image and include the URL.
imageField :: String -> Context a
imageField name =
    (f  name              ("assets/img/site-*" .&&. hasVersion "large")) <>
    (f (name <> "_small") ("assets/img/site-*" .&&. hasVersion "small"))
  where
    f n p = field n $ \item -> do
        files <- getImages p
        case files of
            [] -> empty
            _  -> do
                let m = length files
                let f = toFilePath . itemIdentifier $ item
                let c = hash f `mod` m
                let img = files !! c
                return img
    -- | Load images for use with 'imageField'.
    getImages :: Pattern -> Compiler [FilePath]
    getImages p = do
        items <- loadAll p :: Compiler [Item LBS.ByteString]
        urls  <- mapM (getRoute . itemIdentifier) $ items
        return $ catMaybes urls

--------------------------------------------------------------------------------
-- * Compilers
--------------------------------------------------------------------------------

-- | Compiler for blog content.
contentCompiler :: Compiler (Item String)
contentCompiler =
    pandocCompilerWith read_opts write_opts
        >>= return . fmap demoteHeaders
        >>= return . fmap embedKMLImages
        >>= shill
  where
    read_opts = defaultHakyllReaderOptions
    write_opts = defaultHakyllWriterOptions
        { writerHTMLMathMethod = MathJax mathjax
        }
    mathjax = "http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"

-- | Compress JavaScript files.
compressJsCompiler :: Compiler (Item LBS.ByteString)
compressJsCompiler =
    getResourceLBS >>= withItemBody (unixFilterLBS "./bin/js-opt" [])

-- | Optimise large JPEG image files.
largeImageCompiler :: Compiler (Item LBS.ByteString)
largeImageCompiler =
    getResourceLBS >>= withItemBody (unixFilterLBS "./bin/jpeg-opt" [])

-- | Scale and optimise small JPEG image files.
smallImageCompiler :: Compiler (Item LBS.ByteString)
smallImageCompiler =
    getResourceLBS >>= withItemBody (unixFilterLBS "./bin/jpeg-scale" [])

-- | Compile a post to its table of contents.
tocCompiler :: Compiler (Item String)
tocCompiler = pandocCompilerWith
  readerOptions
  writerOptions
    { writerTableOfContents = True
    , writerTemplate = "$toc$"
    , writerStandalone = True
    }

-- | Sprinkle affiliate links, etc. over a blog.
shill :: Item String -> Compiler (Item String)
shill item = return $ fmap (withUrls amazon) item
  where
    amazon :: String -> String
    amazon url = if "amazon.com/" `isInfixOf` url
        then fromMaybe url $ urlAddQuery ("tag", amazonUSTag) url
        else url

--------------------------------------------------------------------------------
-- * Utility
--------------------------------------------------------------------------------

-- Calculate the page 'Identifier' of a paginated resource.
paginatePage :: Paginate -> PageNumber -> Maybe Identifier
paginatePage pag pageNumber
    | pageNumber < 1 = Nothing
    | pageNumber > (M.size . paginateMap $ pag) = Nothing
    | otherwise = Just $ paginateMakeId pag pageNumber

-- | Add a query parameter to a URL.
urlAddQuery :: (String, String) -> String -> Maybe String
urlAddQuery param url = exportURL . flip add_param param <$> importURL url

-- | Rewrite HTML, classify @<embed>@ tags for @.kml@ files so JavaScript can
-- display them on embedded maps.
--
-- TODO: Use a 'Compiler' to convert KML files into GeoJSON. Then use GeoJSON
-- directly in the JS.
embedKMLImages :: String -> String
embedKMLImages = withTags $ \tag -> case tag of
    TS.TagOpen _ _ -> embed tag
    _ -> tag
  where
    embed :: TS.Tag String -> TS.Tag String
    embed t@(TS.TagOpen "embed" a) = case lookup "src" a of
        Nothing -> t
        Just src -> if ".kml" `isSuffixOf` src
            then TS.TagOpen "embed" (a <> [("class", "embed-kml-map")])
            else t
    embed tag = tag
