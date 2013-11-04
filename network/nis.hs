{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import Shelly
import qualified Data.Text as T
default (T.Text)

sudo_ com args = run_ "sudo" (com:args)

main = shelly $ verbosely $ do

--the install for NIS  is going to ask for a default domain, for now give it
--it.cs.umb.edu, later on you can update it with the correct values and/or ask for input
--THIS NEEDS TO BE IMPLEMENTED

apt_get "update" []
apt_get "install" ["nis"]
apt-get "install" [" sysv-rc-conf"]

--add NIS to the four lines indicated in nsswitch.conf
contents <- readFile "/etc/nsswitch.conf"
let output = unlines (map process (lines contents))
writFile outputPath output

--determine if the line is one of the four lines to add to, if it's not 
--leave it as is
process :: String -> String
process line
   |isAddingLine = line ++" nis" --check to make sure there is actually supposed to be a space here
   |otherwise = line



--determine whether the lines you have are one of the four lines you want to
--add to
isAddingLine :: [T.Text] -> Bool
isAddingLine line = head (T.words line) == "passwd" || "group" || "shadow"" || "hosts"
 
--add 'nis' to the end of the four lines you want in the array
nsswitchAdd :: [T.Text] -> [T.Text]
nsswitchAdd toNsswitch = (whatever the command is to append to the end of an array element) 
        where desired line = isAddingLine line


--append /etc/yp.conf to identify it20 as the gateway server

gateway <- readfile "gateway.config"
appendfile "/etc/yp.conf" "ypserver " "gateway"

--check to make sure that the default domain is correct
 
  --NOT YET IMPLEMENTED--





--processing the password file to be parsed into the setup files for users

isComment :: T.Text -> Bool
isComment line = T.head line == "#"

--Is the line the username/password header? 
isHeader :: T.Text -> Bool
isHeader line = head (T.words line) == "username"

--Puts the username/password combos into a list of lists in order to be used 
--in linux's adduser command
toUsername :: T.Text -> [[T.Text]]
toUsername usersconfig = map words stripped
    where predicate line = isComment line || isHeader line	
          stripped = filter predicate $ lines  usersconfig

