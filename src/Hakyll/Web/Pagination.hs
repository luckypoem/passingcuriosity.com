{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE OverloadedStrings #-}
module Hakyll.Web.Pagination where

import Prelude hiding (id)
import Control.Applicative ((<$>))
import Control.Arrow ((>>>), (***), (&&&), arr)
import Control.Category (id)
import Data.Monoid (mempty, mconcat)
import Data.Typeable (Typeable)
import Data.Binary (Binary, get, put)

import Hakyll

groupInto :: Int -> [a] -> [[a]]
groupInto n l = worker n l []
  where worker n [] r = r
        worker n l r = let (r', l') = splitAt n l
                       in worker n l' (r ++ [r'])


data Archives a = Archives {
  archivePages :: [(Int, Int, [Page a])]
  } deriving (Show, Typeable)



instance Binary a => Binary (Archives a) where
    get = Archives <$> get
    put (Archives m) = put m

instance Writable (Archives a) where
    write _ _ = return ()

data PagerConfig = PagerConfig
                   { pagerItems    :: Int
                   , pagerFirst    :: String
                   , pagerPrevious :: String
                   , pagerNext     :: String
                   , pagerLast     :: String
                   }

defaultPager = PagerConfig {
    pagerItems    = 20
  , pagerFirst    = "&lArr; First"
  , pagerPrevious = "&larr; Older"
  , pagerNext     = "Newer &rarr;"
  , pagerLast     = "Last &rArr;"
  }

readArchives :: PagerConfig
             -> [Page a]
             -> Archives a
readArchives cfg ps = let
  l = groupInto (pagerItems cfg) . reverse . chronological $ ps
  t = length l
  a = zipWith (\p n->(n,t,p)) l [1..]
  in Archives a



addPostList' :: Compiler (Page String, [Page String]) (Page String)
addPostList' = setFieldA "posts" $
    arr (reverse . chronological)
        >>> require "templates/postitem.html" (\p t -> map (applyTemplate t) p)
        >>> arr mconcat
        >>> arr pageBody

-- | Generate an identifier for an archive page.
archiveIdentifier :: Int -> Identifier (Page a)
archiveIdentifier p = fromCapture "archives/*" (show p)

-- | Add an archive page link to a field.
archiveLink :: String -- ^ Name of field to set.
            -> Int -- ^ Page number to link to.
            -> Compiler (Page a) (Page a)
archiveLink name page = id &&& constA (archiveIdentifier page) >>> 
  setFieldA name (getRouteFor >>> arr link)
  where link Nothing = ""
        link (Just p) = "<a href='" ++ p ++ "'>Link</a>"

makeArchivePage :: Int
                -> Int
                -> [Page String]
                -> Compiler () (Page String)
makeArchivePage page total posts = 
  constA (mempty, posts)
    >>> addPostList'
    >>> arr (setField "title" ("Page " ++ show page ++ " of " ++ show total))
    >>> arr (setField "page" $ show page)
    >>> arr (setField "total" $ show total)
    >>> archiveLink "next" (page - 1)
    >>> archiveLink "previous" (page + 1)
    >>> applyTemplateCompiler "templates/posts.html"
    >>> applyTemplateCompiler "templates/default.html"
    >>> relativizeUrlsCompiler
      where archLink = toFilePath . archiveIdentifier


-- | Paginate a set of pages according the configuration.
--
-- Add fields to the page containing pagination links and the appropriate 
-- selection of pages.
pagination :: PagerConfig -- ^ Pagination settings
           -> [Page a] -- ^ Content to paginate
           -> Int -- ^ Current page
           -> Compiler (Page a) (Page a)
pagination cfg ps p = undefined
