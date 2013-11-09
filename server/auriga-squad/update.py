#!/usr/bin/env python

import re
import urllib
import wsgiref.handlers

from google.appengine.ext import webapp
from google.appengine.ext import db
from map import Map

def lookup(type, start, count):
    query = Map.all()
    if type == "fun":
        query.order("-funScore")
    elif type == "hard":
        query.order("-hardScore")
    elif type == "medium":
        query.order("-mediumScore")
    elif type == "easy":
        query.order("-easyScore")
    elif type == "recent":
        query.filter("good = ", 0)
        query.filter("bad = ", 0)
        query.filter("ok = ", 0)
        query.order("-created")
    else:
        query.order("name")
#    result = []
    records = query.fetch(count, start)
#    current = 0;
#    for record in records:
#        result.append(("name" + str(current), str(record.name)))
#        result.append(("key" + str(current), str(record.key())))
#        current += 1
#    result.append(("size", str(current)))
    return records

def update_ratings(obj):
    obj.update()
    obj.put()

class MainHandler(webapp.RequestHandler):

  def get(self):
    self.post()

  def post(self):
    try:
      type = self.request.get("type")
      start = int(self.request.get("start"))
      count = int(self.request.get("count"))
      mapList = lookup(type, start, count)
      for obj in mapList:
          db.run_in_transaction(update_ratings, obj)
          self.response.out.write(obj.name + '\n')
    except Exception, error:
      message = 'Could not construct map list: ' + str(error)
      result = urllib.urlencode([('error', message)])
    self.response.out.write('Done')

def main():
  application = webapp.WSGIApplication([('.*', MainHandler)], debug=True)
  wsgiref.handlers.CGIHandler().run(application)

if __name__ == '__main__':
  main()
