#!/usr/bin/env python

import re
import hashlib
import urllib
import wsgiref.handlers

from google.appengine.ext import webapp
from google.appengine.ext import db
from map import Map

class MainHandler(webapp.RequestHandler):

  def get(self):
    self.post()

  def post(self):
    try:
      secret = 'men judge generally more by the eye than by the hand, because it belongs to everybody to see you, to few to come in touch with you.'
      mapText = self.request.get("map")
      nameText = self.request.get("name")
      verifyGiven = self.request.get("verify")
      m = hashlib.md5()
      m.update(secret)
      m.update(mapText)
      verifyFound = m.hexdigest()
      if verifyGiven != verifyFound:
        result = urllib.urlencode([('error', 'Map was corrupted in transit')])
      else:
        map = Map(name = nameText, text = db.Text(mapText))
        map.update()
        key = map.put()
        getUrl = re.sub("upload/?$", "get/", self.request.url) + str(key)
        result = urllib.urlencode([('result', getUrl),
                                   ('key', str(key))])
    except Exception, error:
      message = 'Could not find map: ' + str(error)
      result = urllib.urlencode([('error', message)])
    self.response.out.write(result)

def main():
  application = webapp.WSGIApplication([('.*', MainHandler)], debug=True)
  wsgiref.handlers.CGIHandler().run(application)

if __name__ == '__main__':
  main()
