{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import Shelly
import qualified Data.Text as T
default (T.Text)

sudo_ com args = run_ "sudo" (com:args)

main = shelly $ verbosely $ do
	hosts <- readfile "hosts.config"
	writefile "/etc/hosts" hosts
	run_ "/etc/init.d/networking" ["restart"]
