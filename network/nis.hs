{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import Shelly
import qualified Data.Text as T
default (T.Text)


main = shelly $ verbosely $ do
       run_ "apt-get" ["update"]
       run_ "apt-get" ["install", "nis"]
       run_ "apt-get" ["install", "sysv-rc-conf"]


--add the lines 'NIS' to the specified four lines in nsswitch.conf

addNIS = do contents <- readfile "/etc/nsswitch.conf"
            let output = T.unlines (fmap process (T.lines contents))
            writefile "/etc/nsswitch.conf" output

--determine if the line is one of the four lines to be added to

process :: T.Text -> T.Text
process line
      |isAddingLine line = line T.append " nis" --if this doesn't work on shot one take out the space
      |otherwise = line

--filter for picking out the four lines to add to
isAddingLine :: T.Text -> Bool
isAddingLine line = valid . head . T.words $ line 
             where valid "passwd" = True
                   valid "group" = True 
                   valid "shadow" = True 
                   valid "hosts" = True
                   valid _ = False

--modify /etc/yp.conf to identify the gateway server

ypGateway = do gateway <- readfile "gateway.config"
               appendfile "/etc/yp.conf" $ "ypserver " ++ gateway

--check to make sure you have the correct default domain

defaultChecker :: ShIO Bool
defaultChecker = do defaultchecker <- readfile "/etc/defaultdomain" 
                    defaultdomain <- readfile "defaultdomain.config"
	            if defaultchecker /= defaultdomain
		    then do echo "Incorrect default domain. Exiting program. Please check your configuration files, specifically defaultdomain.config.."
                            return False
                    else return True        

--process the password file to be parsed into the mkdir command for home
--directories as well as the chown/chgrp commands

--is the line a comment?
isComment :: T.Text -> Bool
isComment line = T.head line == "#"

--is the line the username/password header?
isHeader :: T.Text -> Bool
isHeader line = head (T.words line) == "username"


usersconfig = readfile "users.config"  --read in users.config into a variable

toUsername :: T.Text -> [T.Text]  --put the usernames in a list      
toUsername usersconfig = map words stripped  --dump usernames into a list minus filtered items
         where predicate line = isComment line || isHeader line  --sets filter to be header and comment lines
	       stripped = filter predicate $ lines usersconfig  --subtracts the filter from the entire list


--make a home directory for each user using format /home/username

makeHome :: [T.Text] -> ShIO ()
makeHome users = mapM_ mkhome users  -- takes T.Text objects and makes them ShIO () objects
  where mkhome user = do run_ "mkdir" ["/home/" T.append user] --for each instance of mkhome, run mkdir to create a home directory for that user
                         run_ "chown" ["/home/" T.append user, user] --change owner of directory to user
                         run_ "chgrp" ["/home/" T.append user, user] --change group of directory to user

--restart NIS

restartNIS = do run_ "sudo service ypbind" ["restart"]
                run_ "sudo sysv-rc-conf ypbind" ["on"]










 
