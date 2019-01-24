module Main where

import Text.XML.HXT.Arrow.XmlState.TypeDefs
import Text.XML.HXT.Core
import Text.XML.HXT.Arrow.Edit
import Text.XML.HXT.Version
import Text.XML.HXT.Arrow.ReadDocument
-- import Text.XML.HXT.Curl --To change to cURL call instead of HTTP call uncomment this line and comment the line import Text.XML.HXT.HTTP.
-- (Do not uncomment) You will also need to change the withHTTP option, which you pass to readDocument, to withCurl.  (This call is in the main::IO ())
import Text.XML.HXT.HTTP
import Data.Tree.NTree.TypeDefs
import System.Process

import Prelude hiding (catch)
import System.Directory
import Control.Exception
import System.IO.Error hiding (catch)

-- Data format for dates.  Simiply stores three ints representing the components of dates.
data Date = Date {year::Int, month::Int, day::Int}
-- Creates a string of the Date in dir format that is compatable with the URL format NOAA uses.
instance Show Date where
    -- show :: Date -> String -- not allowed to explitly define function type since it is already a type class; however, this is the actual type at compile time.
    show date = show (year date) ++ "/" ++ formatInt (month date) ++ "/" ++ formatInt (day date)


-- The main dir for the NOAA database as text URL.
buckUrl::String
buckUrl = "http://noaa-nexrad-level2.s3.amazonaws.com"

-- Default options if the call doesn't provide date or station
defaultDate::Date
defaultDate = Date 2016 1 1
defaultStation::String
defaultStation = "KGSP"


-- Takes the date and the weather station converst them to the correct url request format text
toDateUrlStr:: Date -> String -> String
toDateUrlStr date station = buckUrl ++ "/?prefix=" ++ show date ++ "/" ++ station

--Uses the XML arrows lib to get the list of zip files a assiated with the given date and station.
--In the case that the date or station does not exist or is format wrong it will return and empty list.
getKeys::Date -> String -> IO [String]
getKeys date station = runX  (deep (getText) 
	<<< deep (hasName "Key" <<< isElem) 
	<<< (readDocument [withHTTP []]  (toDateUrlStr date (formatStation station))))

keyToFileUrl::String -> String
keyToFileUrl key = 

makeShapeFile:: String -> IO String	
makeShapeFile key = 

main::IO ()
main = do
       lskeys <- getKeys defaultDate defaultStation
       lsurls <- fmap keyToFileUrl lskeys
       fmap makeShapeFile lsurls

------------- Helper Functions ------------------ 
-- Create an removes a file if it exists
removeIfExists :: FilePath -> IO ()
removeIfExists fileName = removeFile fileName `catch` handleExists
  where handleExists e
          | isDoesNotExistError e = return ()
          | otherwise = throwIO e
-- Concats a list of strings adding new lines between them
concatWNL :: [String] -> String
concatWNL = foldr addWNL ""
-- Concats two strings adding a new line between them
addWNL :: String -> String -> String
addWNL x y = x ++ "\n" ++ y
-- Makes sure that digits below ten print with a 0 infront of them to match date format of NOAA bucket URL
formatInt::Int -> String
formatInt n = if n < 10  then "0" ++ show n
              else show n
--Changes station to default option if empty string is provided
formatStation :: String -> String
formatStation station = case station of
                        "" -> defaultStation
                        str -> str