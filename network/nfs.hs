{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import Shelly
import qualified Data.Text as T
default (T.Text)

sudo_ com args = run_ "sudo" (com:args)

--update the system and install nfs and autofs




--move directories from home to home.computername




--create a directory to use as a mount point named /home




--edit /etc/passwd to change sysadmin account's home to home.computername



--append /etc/exports to tell it where and how to export our homes



--edit /etc/auto.master to tell it that the homes are located in auto.home



--restart the virtual machine

