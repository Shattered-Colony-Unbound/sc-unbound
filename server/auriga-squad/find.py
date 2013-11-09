#!/usr/bin/env python

import re
import urllib
import wsgiref.handlers

from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import memcache
from map import Map

def lookup(type, start, count):
    result = []
    cursorkey = "cursor-" + type + "-" + str(start)
    key = type + "-" + str(start) + "-" + str(count)
    cache = memcache.get(key)
    if cache is not None:
      result = cache
    else:
      cursor = memcache.get(cursorkey)
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
      if cursor is not None:
        query.with_cursor(cursor)
        records = query.fetch(count)
      else:
        records = query.fetch(count, start)
      current = 0;
      for record in records:
        result.append(("name" + str(current), str(record.name)))
        result.append(("key" + str(current), str(record.key())))
        current += 1
      result.append(("size", str(current)))
      memcache.set(key, result, 3600*24)
      cursorkey = "cursor-" + type + "-" + str(start + count)
      memcache.set(cursorkey, query.cursor(), 3600)
    return result

class MainHandler(webapp.RequestHandler):

  def get(self):
    self.post()

  def post(self):
    try:
      type = self.request.get("type")
      start = int(self.request.get("start"))
      count = int(self.request.get("count"))
      mapList = lookup(type, start, count)
      message = urllib.urlencode(mapList)
      result = urllib.urlencode([('result', message)])
    except Exception, error:
      message = 'Could not construct map list: ' + str(error)
      result = urllib.urlencode([('error', message)])
    self.response.out.write(result)

def main():
  application = webapp.WSGIApplication([('.*', MainHandler)], debug=True)
  wsgiref.handlers.CGIHandler().run(application)

if __name__ == '__main__':
  main()
