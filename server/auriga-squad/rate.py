#!/usr/bin/env python

import re
import urllib
import wsgiref.handlers

from google.appengine.ext import webapp
from google.appengine.ext import db
from map import Map

def update_ratings(key, deltas):
    obj = db.get(key)
    obj.good += deltas[0]
    obj.ok += deltas[1]
    obj.bad += deltas[2]
    obj.hard += deltas[3]
    obj.medium += deltas[4]
    obj.easy += deltas[5]
    obj.update()
    obj.put()

class MainHandler(webapp.RequestHandler):

  def get(self):
      self.post()

  def post(self):
    try:
      name = re.sub("/rate/", "", self.request.path)
      key = db.Key(name)
      deltas = [0, 0, 0, 0, 0, 0]
      fun = self.request.get("fun")
      if fun == "good":
          deltas[0] = 1
      elif fun == "ok":
          deltas[1] = 1
      elif fun == "bad":
          deltas[2] = 1
      diff = self.request.get("difficulty")
      if fun != "bad":
        if diff == "hard":
          deltas[3] = 1
        elif diff == "medium":
          deltas[4] = 1
        elif diff == "easy":
          deltas[5] = 1
      db.run_in_transaction(update_ratings, key, deltas)
      result = urllib.urlencode([('result', 'confirm')])
    except Exception, error:
      message = 'Could not find map: ' + str(error)
      result = urllib.urlencode([('error', message)])
    self.response.out.write(result)

def main():
  application = webapp.WSGIApplication([('.*', MainHandler)], debug=True)
  wsgiref.handlers.CGIHandler().run(application)

if __name__ == '__main__':
  main()
