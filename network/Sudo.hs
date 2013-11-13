{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}
module Sudo (sudo, sudo_) where

import Shelly
import qualified Data.Text as T
default (T.Text)

sudo :: Shelly.FilePath -> [T.Text] -> Sh T.Text
sudo c as = run "sudo" (toTextIgnore c : as)

sudo_ :: Shelly.FilePath -> [T.Text] -> Sh ()
sudo_ c as = run_ "sudo" (toTextIgnore c : as)
