class Salvage
{
  public function new() : Void
  {
    resource = [];
    for (i in 0...(Option.resourceCount))
    {
      resource.push(0);
    }
  }

  public function addResource(payload : Resource, amount : Int)
  {
    var index = Lib.resourceToIndex(payload);
    resource[index] += amount;
    if (resource[index] < 0)
    {
      resource[index] = 0;
    }
    if (Game.settings.isEditor())
    {
      Game.view.window.refresh();
    }
  }

  private function pruneNeeds(needs : List<ResourceCount>) : Array<Resource>
  {
    var result : Array<Resource> = [];
    for (i in 0...resource.length)
    {
      if (resource[i] > 0)
      {
        result.push(Lib.indexToResource(i));
      }
    }
/*
    if (needs != null)
    {
      for (pos in needs)
      {
        var index = Lib.resourceToIndex(pos.payload);
        if (resource[index] > 0)
        {
          result.push(pos.payload);
        }
      }
    }
*/
    return result;
  }

  private function randIndex(needs : Array<Resource>) : Int
  {
    var result : Int = 0;
    var weights : Array<Int> = [];
    for (pos in needs)
    {
      if (pos == Resource.SURVIVORS)
      {
        weights.push(resource[Lib.resourceToIndex(pos)] * Option.truckLoad);
      }
      else
      {
        weights.push(resource[Lib.resourceToIndex(pos)]);
      }
    }
    var index = Lib.randWeightedIndex(weights);
    return Lib.resourceToIndex(needs[index]);
  }

  public function getResource(needs : List<ResourceCount>) : Resource
  {
    var result : Resource = null;
    var availableNeeds = pruneNeeds(needs);
    if (getTotalCount() > 0 && availableNeeds.length > 0)
    {
      var index = randIndex(availableNeeds);
      result = Lib.indexToResource(index);
      -- resource[index];
    }
    return result;
  }

  public function getTotalCount() : Int
  {
    var count = 0;
    for (pos in resource)
    {
      count += pos;
    }
    return count;
  }

  public function getResourceCount(payload : Resource) : Int
  {
    var index = Lib.resourceToIndex(payload);
    return resource[index];
  }

  public function save() : Dynamic
  {
    return resource.copy();
  }

  public static function load(input : Dynamic) : Salvage
  {
    var result = new Salvage();
    for (i in 0...input.length)
    {
      result.resource[i] = input[i];
    }
    return result;
  }

  var resource : Array<Int>;
}
