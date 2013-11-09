#!/usr/bin/env python

import re
import urllib
import wsgiref.handlers

from google.appengine.ext import webapp
from google.appengine.ext import db
from map import Map

class MainHandler(webapp.RequestHandler):

  def get(self):
    try:
      name = re.sub("/get/", "", self.request.path)
      key = db.Key(name)
      map = Map()
      map = map.get(key)
      result = urllib.urlencode([('result', str(map.text)),
                                 ('key', str(map.key()))])
    except Exception, error:
      message = 'Could not find map: ' + str(error)
      result = urllib.urlencode([('error', message)])
    self.response.out.write(result)

def main():
  application = webapp.WSGIApplication([('.*', MainHandler)], debug=True)
  wsgiref.handlers.CGIHandler().run(application)

if __name__ == '__main__':
  main()
