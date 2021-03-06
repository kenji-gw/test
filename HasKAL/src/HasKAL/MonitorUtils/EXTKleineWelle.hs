{-******************************************
  *     File Name: EXTKleineWelle.hs
  *        Author: Takahiro Yamamoto
  * Last Modified: 2014/04/18 10:18:54
  *******************************************-}

module HasKAL.MonitorUtils.EXTKleineWelle
  (execKleineWelle
   --,generateOptKW
   --,execKW
  ) where


import qualified System.IO as SIO --openFile
import qualified System.Process as SP -- system
import qualified Control.Monad as CM -- forM

import qualified HasKAL.ExternalUtils.Lwtprint as HEL


execKleineWelle :: Int -> String -> Double -> Double -> Double -> Int -> [String] -> Int -> Int -> Int -> String -> String -> Int -> [String] -> IO [String]
execKleineWelle kwStride kwBasename kwTransientDuration kwSignificance kwThreshold kwDecimateFactor glitchActiveLabels kwLowCutOff kwHighCutOff kwUnowen_2 optFilePref listFile kwGpsTime kwActiveLabels = do
  generateOptKW kwStride kwBasename kwTransientDuration kwSignificance kwThreshold kwDecimateFactor kwLowCutOff kwHighCutOff kwUnowen_2 optFilePref glitchActiveLabels
  coreKleineWelle optFilePref listFile glitchActiveLabels
  HEL.execLwtprint glitchActiveLabels kwBasename kwGpsTime kwStride kwActiveLabels


generateOptKW :: Int -> String -> Double -> Double -> Double -> Int  -> Int -> Int -> Int -> String -> [String] -> IO [()]
generateOptKW kwStride kwBasename kwTransientDuration kwSignificance kwThreshold kwDecimateFactor kwLowCutOff kwHighCutOff kwUnowen_2 optFilePref glitchActiveLabels = do
  {--  Set parameters for optM format  --}
  let s_stride = "stride " ++ (show kwStride)
  let s_transientDuration = "transientDuration " ++ (show kwTransientDuration)
  let s_significance = "significance " ++ (show kwSignificance)
  let s_threshold = "threshold " ++ (show kwThreshold)
  let s_decimateFactor = "decimateFactor " ++ (show kwDecimateFactor)

  CM.forM [0..(length glitchActiveLabels)-1] $ \lambda -> do
    let s_basename = "basename " ++ kwBasename ++ (glitchActiveLabels !! lambda)
    let s_channel = "channel " ++ (glitchActiveLabels !! lambda) ++ " " ++ (show kwLowCutOff) ++ " " ++ (show kwHighCutOff) ++ " " ++ (show kwUnowen_2)

    {--  Merge parameters  --}
    let kwInfo = [s_stride, s_basename, s_transientDuration, s_significance, s_threshold, s_decimateFactor, s_channel]

    {--  Output parameter as optM file  --}
    oFile <- SIO.openFile (optFilePref ++ (glitchActiveLabels !! lambda)) SIO.WriteMode
    SIO.hPutStrLn oFile (unlines kwInfo)
    SIO.hClose oFile


coreKleineWelle :: String -> String -> [String] -> IO [()]
coreKleineWelle  optFilePref listFile glitchActiveLabels = do
  CM.forM [0..(length glitchActiveLabels)-1] $ \lambda -> do
    let cmd_string = "kleineWelleM " ++ optFilePref ++ (glitchActiveLabels !! lambda) ++ " -inlist " ++ listFile
    putStrLn ("kleineWelleM " ++ cmd_string)
    SP.system cmd_string -- execute kleineWelleM
  return [()]

