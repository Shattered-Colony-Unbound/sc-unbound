// A storage class to encapsulate the resources at a tower.
//   stock is the current amount of each resource at a tower.
//   incoming is the amount of resources on their way to the tower.
//   reserve is the amount of resources at the tower reserved for local use
class Storage
{
  public function new() : Void
  {
    stock = Lib.newResourceArray();
    incomingList = Lib.newResourceArray();
    reserveList = Lib.newResourceArray();
  }

  public function give(payload : ResourceCount) : Void
  {
    addList(payload, stock);
  }

  public function take(payload : ResourceCount) : Void
  {
    removeList(payload, stock);
  }

  public function count(payload : Resource) : Int
  {
    return countList(payload, stock);
  }

  public function addIncoming(payload : ResourceCount) : Void
  {
    addList(payload, incomingList);
  }

  public function removeIncoming(payload : ResourceCount) : Void
  {
    removeList(payload, incomingList);
  }

  public function incoming(payload : Resource) : Int
  {
    return countList(payload, incomingList);
  }

  public function addReserve(payload : ResourceCount) : Void
  {
    addList(payload, reserveList);
  }

  public function removeReserve(payload : ResourceCount) : Void
  {
    removeList(payload, reserveList);
  }

  public function reserve(payload : Resource) : Int
  {
    return countList(payload, reserveList);
  }

  static function addList(payload : ResourceCount, list : Array<Int>) : Void
  {
    var index = Lib.resourceToIndex(payload.resource);
    list[index] += payload.count;
  }

  static function removeList(payload : ResourceCount, list : Array<Int>) : Void
  {
    var index = Lib.resourceToIndex(payload.resource);
    list[index] -= payload.count;
  }

  static function countList(payload : Resource, list : Array<Int>) : Int
  {
    var index = Lib.resourceToIndex(payload);
    return list[index];
  }

  public function saveEditResources(output : flash.utils.ByteArray) : Void
  {
    mapgen.EditLoader.saveResources(stock, output);
    mapgen.EditLoader.saveResources(reserveList, output);
  }

  public function save() : Dynamic
  {
    return { stock : stock.copy(),
             incomingList : incomingList.copy(),
             reserveList : reserveList.copy() };
  }

  public function load(input : Dynamic) : Void
  {
    for (i in 0...Option.resourceCount)
    {
      stock[i] = input.stock[i];
      incomingList[i] = input.incomingList[i];
      reserveList[i] = input.reserveList[i];
    }
  }

  var stock : Array<Int>;
  var incomingList : Array<Int>;
  var reserveList : Array<Int>;
}
