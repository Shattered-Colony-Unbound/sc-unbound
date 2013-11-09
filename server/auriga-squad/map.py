import math
from google.appengine.ext import db

class Map(db.Model):
    name = db.StringProperty(default="")
    text = db.TextProperty(default="")
    created = db.DateTimeProperty(auto_now_add=True)

    good = db.IntegerProperty(default=0)
    ok = db.IntegerProperty(default=0)
    bad = db.IntegerProperty(default=0)
    funScore = db.IntegerProperty(default=0)
    
    hard = db.IntegerProperty(default=0)
    medium = db.IntegerProperty(default=0)
    easy = db.IntegerProperty(default=0)
    hardScore = db.IntegerProperty(default=0)
    mediumScore = db.IntegerProperty(default=0)
    easyScore = db.IntegerProperty(default=0)

    def update(self):
        self.funScore = self.good - self.bad
        self.hardScore = self.hard - self.easy
        self.mediumScore = int(self.medium - self.hard/2 - self.easy/2);
        self.easyScore = self.easy - self.hard
#        totalVotes = self.good + self.ok + self.bad + 1
#        self.funScore = int(100 * (2*self.good + self.ok - self.bad)/(2*totalVotes)
#                            * math.log(totalVotes))
#        self.hardScore = int(100 * self.hard/totalVotes
#                             * math.log(totalVotes)
#                             + self.funScore/3)
#        self.mediumScore = int(100 * self.medium/totalVotes
#                               * math.log(totalVotes)
#                               + self.funScore/3)
#        self.easyScore = int(100 * self.easy/totalVotes
#                             * math.log(totalVotes)
#                             + self.funScore/3)
