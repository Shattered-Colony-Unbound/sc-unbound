class Building
{
  public function new(newType : Int) : Void
  {
    type = newType;
    entrance = null;
    entranceDir = Direction.EAST;
    zombies = 0;
    salvage = new Salvage();
    lots = new List<mapgen.Section>();
  }

  public function getType() : Int
  {
    return type;
  }

  public function getSalvage() : Salvage
  {
    return salvage;
  }

  public function hasResources() : Bool
  {
    return salvage.getTotalCount() > 0;
  }

  public function addZombies(newZombies : Int) : Void
  {
    zombies += newZombies;
    Game.progress.addZombies(newZombies);
    if (Game.settings.isEditor())
    {
      Game.view.window.refresh();
      Game.view.mini.update();
    }
  }

  public function clearZombies() : Void
  {
    Game.progress.addZombies(-zombies);
    zombies = 0;
  }

  public function hasZombies() : Bool
  {
    return zombies > 0;
  }

  public function getZombieCount() : Int
  {
    return zombies;
  }

  public function makeNoise(source : Point, loudness : Int,
                            guide : PathFinder) : Void
  {
    if (zombies > 0 && Lib.rand(100) < loudness * Option.disturbChance)
    {
      var zombiesProduced = Lib.rand(cast(Math.min(zombies + 1, 2), Int));
      for (i in 0...zombiesProduced)
      {
        var newZombie : Zombie = new Zombie(entrance.x, entrance.y,
                                            Lib.directionToAngle(entranceDir),
                                            source.x, source.y,
                                            Zombie.BUILDING_SPAWN);
        newZombie.makeNoise(source, loudness, guide);
        Game.spawner.addZombie();
      }
      zombieSideEffect(zombiesProduced);
    }
  }

  public function spawn(dest : Point, guide : PathFinder) : Void
  {
    if (zombies > 0)
    {
      var newZombie = new Zombie(entrance.x, entrance.y,
                                 Lib.directionToAngle(entranceDir),
                                 dest.x, dest.y, Zombie.BUILDING_SPAWN);
      newZombie.makeNoise(dest, 0, guide);
      zombieSideEffect(1);
      newZombie.addToWave();
    }
  }

  function zombieSideEffect(produced : Int) : Void
  {
    zombies -= produced;
    if (produced > 0)
    {
      refreshMinimap();
      Game.view.window.refresh();
      Main.replay.addBox(entrance, new Point(entrance.x + 1, entrance.y + 1),
                         Option.spawnReplayColor);
      drawReplay();
    }
  }

  public function drawReplay() : Void
  {
    for (lot in lots)
    {
      Main.replay.addBox(lot.offset, lot.limit, Lib.zombieColor(zombies));
    }
  }

  public function getEntrance() : Point
  {
    var result = null;
    if (entrance != null)
    {
      result = entrance.clone();
    }
    return result;
  }

  public function refreshMinimap() : Void
  {
    for (lot in lots)
    {
      for (y in (lot.offset.y)...(lot.limit.y))
      {
        for (x in (lot.offset.x)...(lot.limit.x))
        {
          Game.update.cellState(new Point(x, y));
        }
      }
    }
  }

  public function getLots() : List<mapgen.Section>
  {
    return lots;
  }

  public function addLot(newLot : mapgen.Section) : Void
  {
    lots.add(newLot.clone());
  }

  // Attach the building to the map by setting every cell in the lots
  // to point back to the building.
  public function attach() : Void
  {
    for (lot in lots)
    {
      for (y in (lot.offset.y)...(lot.limit.y))
      {
        for (x in (lot.offset.x)...(lot.limit.x))
        {
          Game.map.getCell(x, y).setBuilding(this);
        }
      }
    }
  }

  public function detach() : Void
  {
    for (lot in lots)
    {
      for (y in (lot.offset.y)...(lot.limit.y))
      {
        for (x in (lot.offset.x)...(lot.limit.x))
        {
          Game.map.getCell(x, y).setBuilding(null);
        }
      }
    }
  }

  public function setEntrance(newEntrance : Point,
                              newEntranceDir : Direction) : Void
  {
    entrance = newEntrance.clone();
    entranceDir = newEntranceDir;
  }

  public function getEntranceDir() : Direction
  {
    return entranceDir;
  }

  public function getToolTip() : String
  {
    return ui.Text.buildingText(buildingText[type],
                                getZombieThreat(),
                                getSalvageProspect(),
                                getSurvivors());
  }

  static var buildingText = [ui.Text.buildingStandardText,
                             ui.Text.buildingApartmentText,
                             ui.Text.buildingSupermarketText,
                             ui.Text.buildingPoliceStationText,
                             ui.Text.buildingHardwareStoreText,
                             ui.Text.buildingChurchText,
                             ui.Text.buildingHospitalText,
                             ui.Text.buildingMallText,
                             ui.Text.buildingHouseText,
                             ui.Text.buildingParkingLotText];

  static var zombieText = [ui.Text.zombieThreatNone,
                           ui.Text.zombieThreatLow,
                           ui.Text.zombieThreatModerate,
                           ui.Text.zombieThreatHigh];

  function getZombieThreat() : String
  {
    var index = 0;
    if (zombies > 0)
    {
      index = Lib.weightedIndex(zombies, Option.zombieBuildingWeights) + 1;
    }
    return zombieText[index];
  }

  function getSalvageProspect() : String
  {
    var ammo = Resource.AMMO;
    var food = Resource.FOOD;
    var boards = Resource.BOARDS;
    var count = salvage.getResourceCount(ammo);
    count += salvage.getResourceCount(food);
    count += salvage.getResourceCount(boards);
    if (count == 0)
    {
      return ui.Text.salvageProspectsNone;
    }
    else if (count < 100)
    {
      return ui.Text.salvageProspectsLow;
    }
    else
    {
      return ui.Text.salvageProspectsHigh;
    }
  }

  function getSurvivors() : String
  {
    var survivors = Resource.SURVIVORS;
    var count = salvage.getResourceCount(survivors);
    if (count > 0)
    {
      return ui.Text.survivorsInside;
    }
    else
    {
      return ui.Text.survivorsNotInside;
    }
  }

  public static function saveS(building : Building) : Dynamic
  {
    return building.save();
  }

  public function save() : Dynamic
  {
    return { type : type,
             entrance : entrance.save(),
             entranceDir : Lib.directionToIndex(entranceDir),
             zombies : zombies,
             salvage : salvage.save(),
             lots : Save.saveList(lots, mapgen.Section.save) };
  }

  static public function load(input : Dynamic) : Building
  {
    var result = new Building(input.type);
    result.entrance = Point.load(input.entrance);
    result.entranceDir = Lib.indexToDirection(input.entranceDir);
    result.zombies = input.zombies;
    result.salvage = Salvage.load(input.salvage);
    result.lots = Load.loadList(input.lots, mapgen.Section.load);
    result.attach();
    return result;
  }

  var type : Int;
  var entrance : Point;
  var entranceDir : Direction;
  var zombies : Int;
  var salvage : Salvage;
  var lots : List<mapgen.Section>;
}
