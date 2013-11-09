class PathHeap
{
  public function new(newDest : Point)
  {
    dest = newDest;
    heap = [];
    scores = [];
    indices = new Grid<Int>(Game.map.sizeX(), Game.map.sizeY());
  }

  public function clear() : Void
  {
    heap = [];
    scores = [];
  }

  public function isEmpty() : Bool
  {
    return heap.length == 0;
  }

  public function push(newPos : Point, score : Int) : Void
  {
    var index = heap.length;
    heap.push(newPos);
    scores.push(score + getDistance(newPos));
    indices.set(newPos.x, newPos.y, index);
    heapify(index);
  }

  public function update(newPos : Point, score : Int) : Void
  {
    var index = indices.get(newPos.x, newPos.y);
    if (index != -1)
    {
      scores[index] = score + getDistance(newPos);
      heapify(index);
    }
  }

  public function pop() : Point
  {
    var result = null;
    if (heap.length > 0)
    {
      result = heap[0];
      swap(0, heap.length - 1);
      heap.pop();
      scores.pop();
      indices.set(result.x, result.y, -1);
      if (heap.length > 0)
      {
        backfill(0);
      }
    }
    return result;
  }

  function heapify(index : Int) : Void
  {
    if (index > 0)
    {
      var lower = Math.floor((index - 1) / 2);
      if (scores[index] < scores[lower])
      {
        swap(lower, index);
        heapify(lower);
      }
    }
  }

  function backfill(index : Int) : Void
  {
    var first = index*2 + 1;
    var second = index*2 + 2;
    if (first < heap.length)
    {
      var smallest = first;
      if (second < heap.length && scores[second] < scores[first])
      {
        smallest = second;
      }
      if (scores[smallest] < scores[index])
      {
        swap(index, smallest);
        backfill(smallest);
      }
    }
  }

  function swap(first : Int, second : Int) : Void
  {
    var tempPoint = heap[first];
    heap[first] = heap[second];
    heap[second] = tempPoint;
    var tempScore = scores[first];
    scores[first] = scores[second];
    scores[second] = tempScore;
    indices.set(heap[first].x, heap[first].y, first);
    indices.set(heap[second].x, heap[second].y, second);
  }

  public function getDistance(source : Point) : Int
  {
    var result = 0;
    if (dest != null)
    {
      result = Math.floor(Math.abs(source.x - dest.x)
                          + Math.abs(source.y - dest.y));
    }
    return result;
  }

  public function save() : Dynamic
  {
    return { dest : Save.maybe(dest, Point.saveS),
             heap : Save.saveArray(heap, Point.saveS),
             scores : Save.saveArray(scores, Save.saveInt),
             indices : Save.saveGridInt(indices) };
  }

  public static function saveS(queue : PathHeap) : Dynamic
  {
    return queue.save();
  }

  public static function load(input : Dynamic) : PathHeap
  {
    var result = new PathHeap(Load.maybe(input.dest, Point.load));
    result.heap = Load.loadArray(input.heap, Point.load);
    result.scores = Load.loadArray(input.scores, Load.loadInt);
    result.indices = Load.loadGridInt(input.indices);
    return result;
  }

  var dest : Point;
  var heap : Array<Point>;
  var scores : Array<Int>;
  var indices : Grid<Int>;
}
