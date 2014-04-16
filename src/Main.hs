
module Main where

import Happstack.Server
import qualified Data.ByteString.Lazy.Char8 as B


import Data.Aeson (decode, encode)

import qualified Data.List as List
import Data.Maybe (catMaybes)

import Control.Monad.IO.Class
import Control.Monad

setMime :: String -> B.ByteString -> Response
setMime mt txt =
  (toResponse "")
    { rsBody=txt,
      rsHeaders=(mkHeaders [("Content-Type", mt)])} 


pageNotFound :: String -> ServerPart Response
pageNotFound s = do
  liftIO $ putStrLn $ "page not found: " ++ s
  ok $ toResponse "page not found"


main :: IO ()
main = do
  d3 <-  B.readFile "d3/d3.v3.min.js"
  jq <-  B.readFile "jquery/jquery-1.11.0.min.js"

  simpleHTTP nullConf $ do
    liftIO (putStrLn "Hi there!")

    msum [ dir "d3.v3.min.js" $ ok (setMime "text/javascript" d3),
           dir "jquery-1.11.0.min.js" $ ok (setMime "text/javascript" jq),
           dir "html" $ serveDirectory DisableBrowsing [] "html",
           dir "js" $ serveDirectory DisableBrowsing [] "js",
           dir "css" $ serveDirectory DisableBrowsing [] "css",
           uriRest pageNotFound ]
