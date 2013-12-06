#!/usr/bin/env python
#imports
import tweepy, time
import settings

#globals
REPLY_LIST = []
SWEARS_LIST = []

 
def IDsetter(statefile,id):

    last_id=IDgetter(statefile)
    f=open(statefile,'w')
    f.write(str(id))
    f.close()

def IDgetter(statefile):

    f=open(statefile,'r')
    id = f.readlines()
    for line in f:      
        f = int(line)
        return id
    f.close()
    #return id

def listLoader():

    global REPLY_LIST
    REPLY_LIST = [line.lower().strip() for line in open('results.txt')]

    global SWEARS_LIST
    SWEARS_LIST = [line.lower().strip() for line in open('swears.txt')]

def replyToTweet(api,reply):
   
    if reply.retweeted:
       log(at='filter', reason='already_retweeted', tweet=reply.id)
       return
    
    return api.update_status("@{0} put a quarter in the swear jar: http://theswearjar.weebly.com".format(reply.user.screen_name.lower()))
    time.sleep(350);

def main():


    CONSUMER_KEY = 'cxCjlSLtIR2Lp5SwcEaXQ'
    CONSUMER_SECRET = 'BziDhlF6qeaWb505MjbuPbIdsoAYzzAzybnSeXFVb18'
    ACCESS_KEY = '2227279891-UbAFtiT5NpGu5OKFgjqQe9UANGAibaowRNkBsnY'
    ACCESS_SECRET = 'NRADw3kJM6JDX3Nw72r5WUUQdW8lvKuXVEg8sFblAyOSF'
    auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
    auth.set_access_token(ACCESS_KEY, ACCESS_SECRET)
    api = tweepy.API(auth)

    listLoader()


    last_id=IDgetter(settings.last_id_file)
    
    friends = api.friends_ids()

    for x in SWEARS_LIST:

        replies = api.search(q=x)
        replies.reverse()

        for reply in replies:
           
            replyToTweet(api,reply)

main()
