#!/usr/bin/env python
#imports
import tweepy, time
import settings
import os, time, json
from contextlib import contextmanager
from urlparse import urlparse
from random import choice
import random

#globals
REPLY_LIST = []
SWEARS_LIST = []


#declare a logfile for detecting duplicate tweets
def log(**kwargs):
    print ' '.join( "{0}={1}".format(k,v) for k,v in sorted(kwargs.items()) )
 
#Make a file to push IDs to statefile
def IDsetter(statefile,id):

    last_id=IDgetter(statefile)
    f=open(statefile,'w')
    f.write(str(id))
    f.close()

#pull IDs from statefile
def IDgetter(statefile):

    f=open(statefile,'r')
    id = f.readlines()
    for line in f:      
        f = int(line)
        return id
    f.close()

#load lists of replies and swear dictionary, reply list hasn't been implemented yet and may not be.
def listLoader():

    global REPLY_LIST
    REPLY_LIST = [line.lower().strip() for line in open('results.txt')]

    global SWEARS_LIST
    SWEARS_LIST = [line.lower().strip() for line in open('swears.txt')]


#reply to the tweet with some anti-spam parameters
def replyToTweet(api,reply):
   
    #don't reply retweets we've already retweeted
    if reply.retweeted:
       log(at='filter', reason='already_retweeted', tweet=reply.id)
       return
    
    #log IDs
    log(at='retweet', tweet=reply.id)
  
    #post the tweet
    return api.update_status("@{0} What a foul mouth! Stop cussing and put a quarter in the swear jar: http://theswearjar.weebly.com".format(reply.user.screen_name.lower()))
        

def main():

    CONSUMER_KEY = ''
    CONSUMER_SECRET = ''
    ACCESS_KEY = ''
    ACCESS_SECRET = ''

    auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
    auth.set_access_token(ACCESS_KEY, ACCESS_SECRET)
    api = tweepy.API(auth)

    #load the list
    listLoader()

    #fetch the last ID you saw
    last_id=IDgetter(settings.last_id_file)
    
 
    #shuffle the swears list
    for x in range (0, 200):    
        random.shuffle(SWEARS_LIST)

    #search for that swear using the API
    for swear in SWEARS_LIST:
        replies = api.search(q=swear)
        #API gives replies in reverse order so flip them around, this step isn't strictly necessary but makes things cleaner
        replies.reverse()

        #pull only the first result and post it
        for reply in replies[:1]:
                #call the repeat function for each reply
                replyToTweet(api,reply)
  
                #print reply to terminal
                print("Posted tweet to @{0} for comment:".format(reply.user.screen_name.lower()))
                print(reply.text)
                #sleep for 15 minutes so we're not spamming 
                #time.sleep(900)

main()
