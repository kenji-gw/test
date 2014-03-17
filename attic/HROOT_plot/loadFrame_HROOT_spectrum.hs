{-# LANGUAGE ScopedTypeVariables #-}

import HasKAL.FrameUtils.FrameUtils

{- For fft -}
import Numeric.GSL.Fourier
import Numeric.LinearAlgebra

import HROOT hiding (eval)

import qualified Control.Monad as M


main = do
       fdata <- readFrame "Channel_Name" "test-1066392016-300.gwf"
--       print $ show $ take 20 (eval fdata)

       let sampleRate = 1000::Double
       let dat = subVector 1 15000 (fromList $ map realToFrac (eval fdata))
           fft_val = fft $ dat
           power =  map abs $ toList $ fst . fromComplex $ fft_val * conj fft_val
           len_power = length power
           scale_psd = 1/((fromIntegral len_power) * sampleRate)
           len_power2 = floor $ fromIntegral(len_power)/2
           powerspectrum = take len_power2  $ map (*scale_psd) power

--       print $ show  powerspectrum

       let sampleRate2 = sampleRate/2
           lstx = map (sampleRate2 *) $ toList (linspace len_power2 (0, 1::Double))
--           lstx = [0.0,0.1..2.0*pi]
	   lsty = powerspectrum
	   n = length lsty
       --g1 <- newTGraph n lstx lsty

       tapp <- newTApplication "test" [0] ["test"]
       tcanvas <- newTCanvas "Graph1" "Graph2" 640 480
       g1 <- newTGraph n lstx lsty
       draw g1 "AC"
       run tapp 1
       delete g1
       delete tapp
