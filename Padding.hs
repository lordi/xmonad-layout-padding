{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}

-----------------------------------------------------------------------------
-- |
-- Module      :  xmonad-padding
-- Copyright   :  (c) Brian Shourd
-- License     :  BSD-style (see LICENSE)
--
-- Maintainer  :  <brian.shourd@gmail.com>
-- Stability   :  unstable
-- Portability :  portable
--
-- Add padding to tops and/or sides of windows
-----------------------------------------------------------------------------

-- | This module based heavily (barely changed at all) on
-- Xmonad.Layout.Spacing, (c) Brent Yorgey, originally licensed under a
-- BSD-style license.

module Padding (padding, paddingSingle) where

import Graphics.X11 (Rectangle(..))
import Control.Arrow (second)
import XMonad.Util.Font (fi)

import XMonad.Layout.LayoutModifier

-- | Surround all windows by a certain number of pixels of blank space.
-- First argument is top/bottom, second is side/side
padding :: Int -> Int -> l a -> ModifiedLayout Padding l a
padding p q = ModifiedLayout (Padding p q)

data Padding a = Padding Int Int deriving (Show, Read)

instance LayoutModifier Padding a where

    pureModifier (Padding p q) _ _ wrs = (map (second $ shrinkRect p q) wrs, Nothing)

    modifierDescription (Padding p q) = "Padding " ++ show p ++ " " ++ show q

-- | If only a single window is present in a layout, surround it by a certain
-- number of pixels of blank space. First argument is top/bottom, second is
-- side/side
paddingSingle :: Int -> Int -> l a -> ModifiedLayout PaddingSingle l a
paddingSingle p q = ModifiedLayout (PaddingSingle p q)

data PaddingSingle a = PaddingSingle Int Int deriving (Show, Read)

instance LayoutModifier PaddingSingle a where

    pureModifier (PaddingSingle p q) _ _ [(window, rect)] = ([(window, shrinkRect p q rect)], Nothing)
    pureModifier (PaddingSingle p q) _ _ wrs = (wrs, Nothing)

    modifierDescription (PaddingSingle p q) = "Padding " ++ show p ++ " " ++ show q

shrinkRect :: Int -> Int -> Rectangle -> Rectangle
shrinkRect p q (Rectangle x y w h) = Rectangle (x+fi q) (y+fi p) (w-2*fi q) (h-2*fi p)


