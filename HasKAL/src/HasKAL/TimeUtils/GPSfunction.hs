{-
functions for GPS time
Need tai-utc.dat in the same directory
Chack tai-utc.dat carefully,

generated by T.Yokozawa,T.Muranushi Feb.28. 2014
Modified by T.Yokozawa, Mar.4. 2014
   time2gps output as String without last s
Modified by T.Yokozawa, Mar.7. 2014
   Make TimeUtils.gpstime
-}




module HasKAL.TimeUtils.GPSfunction
( utcbase
, taibase
, timegiven
, taigiven
, time2gps
) where

import Data.Time
import Data.Time.Clock.TAI
import System.Environment
import Data.List
import System.IO
import System.IO.Unsafe
import Data.Time.Format
import System.Locale
import Data.Maybe
import System.Time

{-# NOINLINE theLeapSecondTable #-}
theLeapSecondTable :: LeapSecondTable
theLeapSecondTable = parseTAIUTCDATFile $ unsafePerformIO $
  readFile "./HasKAL/TimeUtils/tai-utc.dat"


utcbase :: UTCTime
utcbase = UTCTime (fromGregorian 1980 1 6) 0

taibase :: AbsoluteTime
taibase = utcToTAITime theLeapSecondTable utcbase

timegiven :: String -> UTCTime
timegiven s = fromJust $ parseTime defaultTimeLocale "%F %T %Z" s

taigiven :: String -> AbsoluteTime
taigiven s = utcToTAITime theLeapSecondTable (timegiven s)

time2gps :: String->String
time2gps s = init $ show (diffAbsoluteTime (taigiven s) taibase)

{-
These output is obsolute : Mar.4. 2014
*Main> :l gpsfunction.hs
*Main> time2gps "2013-01-01 00:00:00 UTC"
1041033616s
*Main> time2gps "2012-12-31 18:00:00 CST"
1041033616s

Latest output example : Mar.4. 2014
*Main> :l gpsfunction.hs
*Main> time2gps "2013-01-01 00:00:00 UTC"
"1041033616"
*Main> time2gps "2012-12-31 18:00:00 CST"
"1041033616"

-}

