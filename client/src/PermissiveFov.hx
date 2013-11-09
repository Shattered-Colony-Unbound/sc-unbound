class DNode<T>
{
  public function new() : Void
  {
    next = null;
    prev = null;
    data = null;
  }

  public var next : DNode<T>;
  public var prev : DNode<T>;
  public var data : T;
}

class DIterator<T>
{
  public function new() : Void
  {
    current = null;
  }

  public function get() : T
  {
    if (current == null)
    {
      return null;
    }
    else
    {
      return current.data;
    }
  }

  public function isValid() : Bool
  {
    return current != null;
  }

  public function increment() : Void
  {
    if (current != null)
    {
      current = current.next;
    }
  }

  public function decrement() : Void
  {
    if (current != null)
    {
      current = current.prev;
    }
  }

  public function copyFrom(right : DIterator<T>) : Void
  {
    current = right.current;
  }

  public function getNode() : DNode<T>
  {
    return current;
  }

  public function setNode(newNode : DNode<T>) : Void
  {
    current = newNode;
  }

  var current : DNode<T>;
}

class DList<T>
{
  public function new() : Void
  {
    head = null;
    tail = null;
  }

  public function isEmpty() : Bool
  {
    return head == null;
  }

  public function frontIterator() : DIterator<T>
  {
    var result : DIterator<T> = new DIterator<T>();
    result.setNode(head);
    return result;
  }

  public function backIterator() : DIterator<T>
  {
    var result : DIterator<T> = new DIterator<T>();
    result.setNode(tail);
    return result;
  }

  // Inserts newData before pos. Returns an iterator to the new data.
  public function insert(pos : DIterator<T>, newData : T) : DIterator<T>
  {
    var result : DIterator<T> = new DIterator<T>();
    if (! pos.isValid())
    {
      push_back(newData);
      result.setNode(tail);
    }
    else if (pos.getNode() == head)
    {
      push_front(newData);
      result.setNode(head);
    }
    else
    {
      var newNode = new DNode<T>();
      newNode.data = newData;
      newNode.prev = pos.getNode().prev;
      newNode.next = pos.getNode();
      pos.getNode().prev.next = newNode;
      pos.getNode().prev = newNode;
      result.setNode(newNode);
    }
    return result;
  }

  // Erases data at pos. Returns an iterator to the next position.
  public function erase(pos : DIterator<T>) : DIterator<T>
  {
    var result : DIterator<T> = new DIterator<T>();
    if (pos.isValid())
    {
      if (pos.getNode() == head)
      {
        pop_front();
        result.setNode(head);
      }
      else if (pos.getNode() == tail)
      {
        pop_back();
        result.setNode(tail);
      }
      else
      {
        pos.getNode().prev.next = pos.getNode().next;
        pos.getNode().next.prev = pos.getNode().prev;
        result.setNode(pos.getNode().next);
      }
    }
    return result;
  }

  public function front() : T
  {
    if (head != null)
    {
      return head.data;
    }
    else
    {
      return null;
    }
  }

  public function back() : T
  {
    if (tail != null)
    {
      return tail.data;
    }
    else
    {
      return null;
    }
  }

  public function push_front(newData : T) : Void
  {
    var newNode : DNode<T> = new DNode<T>();
    newNode.data = newData;
    if (head == null)
    {
      head = newNode;
      tail = newNode;
    }
    else
    {
      head.prev = newNode;
      newNode.next = head;
      head = newNode;
    }
  }

  public function push_back(newData : T) : Void
  {
    var newNode : DNode<T> = new DNode<T>();
    newNode.data = newData;
    if (tail == null)
    {
      head = newNode;
      tail = newNode;
    }
    else
    {
      tail.next = newNode;
      newNode.prev = tail;
      tail = newNode;
    }
  }

  public function pop_front() : Void
  {
    if (head == tail)
    {
      head = null;
      tail = null;
    }
    else
    {
      head.next.prev = null;
      head = head.next;
    }
  }

  public function pop_back() : Void
  {
    if (head == tail)
    {
      head = null;
      tail = null;
    }
    else
    {
      tail.prev.next = null;
      tail = tail.prev;
    }
  }

  var head : DNode<T>;
  var tail : DNode<T>;
}

class Offset
{
  public function new(newX : Int, newY : Int) : Void
  {
    x = newX;
    y = newY;
  }

  public var x : Int;
  public var y : Int;
}

class FovState
{
  public function new() : Void
  {
    source = null;
    isBlocked = null;
    visit = null;
    quadrant = null;
    extent = null;
  }

  public var source : Offset;
  public var isBlocked : Int -> Int -> Bool;
  public var visit : Int -> Int -> Void;
  public var quadrant : Offset;
  public var extent : Offset;
}

class Line
{
  public function new(newNear : Offset, newFar : Offset) : Void
  {
    near = new Offset(newNear.x, newNear.y);
    far = new Offset(newFar.x, newFar.y);
  }

  public function isBelow(point : Offset) : Bool
  {
    return relativeSlope(point) > 0;
  }

  public function isBelowOrContains(point : Offset) : Bool
  {
    return relativeSlope(point) >= 0;
  }

  public function isAbove(point : Offset) : Bool
  {
    return relativeSlope(point) < 0;
  }

  public function isAboveOrContains(point : Offset) : Bool
  {
    return relativeSlope(point) <= 0;
  }

  public function doesContain(point : Offset) : Bool
  {
    return relativeSlope(point) == 0;
  }

  // negative if the line is above the point.
  // positive if the line is below the point.
  // 0 if the line is on the point.
  public function relativeSlope(point : Offset) : Int
  {
    return (far.y - near.y)*(far.x - point.x)
      - (far.y - point.y)*(far.x - near.x);
  }

  public var near : Offset;
  public var far : Offset;
}

class Bump
{
  public function new() : Void
  {
    location = new Offset(0, 0);
    parent = null;
  }

  public var location : Offset;
  public var parent : Bump;
}

class Field
{
  public function new() : Void
  {
    steep = new Line(new Offset(0, 0), new Offset(0, 0));
    shallow = new Line(new Offset(0, 0), new Offset(0, 0));
    steepBump = null;
    shallowBump = null;
  }

  public function clone() : Field
  {
    var result : Field = new Field();
    result.steep = new Line(steep.near, steep.far);
    result.shallow = new Line(shallow.near, shallow.far);
    result.steepBump = steepBump;
    result.shallowBump = shallowBump;
    return result;
  }

  public var steep : Line;
  public var shallow : Line;
  public var steepBump : Bump;
  public var shallowBump : Bump;
}

class PermissiveFov
{
  private static function max(left : Int, right : Int) : Int
  {
    if (left > right)
    {
      return left;
    }
    else
    {
      return right;
    }
  }

  private static function min(left : Int, right : Int) : Int
  {
    if (left < right)
    {
      return left;
    }
    else
    {
      return right;
    }
  }

  private static function calculateFovQuadrant(state : FovState) : Void
  {
    var steepBumps : DList<Bump> = new DList<Bump>();
    var shallowBumps : DList<Bump>  = new DList<Bump>();
    var activeFields : DList<Field> = new DList<Field>();
    activeFields.push_back(new Field());
    activeFields.back().shallow.near = new Offset(0, 1);
    activeFields.back().shallow.far = new Offset(state.extent.x, 0);
    activeFields.back().steep.near = new Offset(1, 0);
    activeFields.back().steep.far = new Offset(0, state.extent.y);

    var dest : Offset = new Offset(0, 0);

    if (state.quadrant.x == 1 && state.quadrant.y == 1)
    {
      actIsBlocked(state, dest);
    }

    var currentField : DIterator<Field> = new DIterator<Field>();
    var i : Int = 0;
    var j : Int = 0;
    var maxI : Int = state.extent.x + state.extent.y;
    i = 1;
    while (i <= maxI && ! activeFields.isEmpty())
    {
      currentField = activeFields.frontIterator();
      var startJ : Int = max(0, i - state.extent.x);
      var maxJ : Int = min(i, state.extent.y);
      j = startJ;
      while (j <= maxJ && currentField.isValid())
      {
        dest.x = i - j;
        dest.y = j;
        currentField = visitSquare(state, dest, currentField, steepBumps,
                                   shallowBumps, activeFields);
        ++j;
      }
      ++i;
    }
  }

  private static function visitSquare(state : FovState,
                                      dest : Offset,
                                      currentField : DIterator<Field>,
                                      steepBumps : DList<Bump>,
                                      shallowBumps : DList<Bump>,
                                      activeFields : DList<Field>)
    : DIterator<Field>
  {
    var topLeft : Offset = new Offset(dest.x, dest.y + 1);
    var bottomRight : Offset = new Offset(dest.x + 1, dest.y);
    while (currentField.isValid()
           && currentField.get().steep.isBelowOrContains(bottomRight))
    {
      currentField.increment();
    }
    if (! currentField.isValid())
    {
      return currentField;
    }

    if (currentField.get().shallow.isAboveOrContains(topLeft))
    {
      return currentField;
    }

    var isBlocked : Bool = actIsBlocked(state, dest);
    if (!isBlocked)
    {
      return currentField;
    }

    if (currentField.get().shallow.isAbove(bottomRight)
        && currentField.get().steep.isBelow(topLeft))
    {
      currentField = activeFields.erase(currentField);
    }
    else if (currentField.get().shallow.isAbove(bottomRight))
    {
      addShallowBump(topLeft, currentField, steepBumps, shallowBumps);
      currentField = checkField(currentField, activeFields);
    }
    else if (currentField.get().steep.isBelow(topLeft))
    {
      addSteepBump(bottomRight, currentField, steepBumps, shallowBumps);
      currentField = checkField(currentField, activeFields);
    }
    else
    {
      var steeperField : DIterator<Field> = new DIterator<Field>();
      steeperField.copyFrom(currentField);
      var shallowerField = activeFields.insert(currentField,
                                               currentField.get().clone());
      addSteepBump(bottomRight, shallowerField, steepBumps, shallowBumps);
      checkField(shallowerField, activeFields);
      addShallowBump(topLeft, steeperField, steepBumps, shallowBumps);
      currentField = checkField(steeperField, activeFields);
    }
    return currentField;
  }

  private static function checkField(currentField : DIterator<Field>,
                                     activeFields : DList<Field>)
    : DIterator<Field>
  {
    var result = currentField;
    if (currentField.get().shallow.doesContain(currentField.get().steep.near)
        && currentField.get().shallow.doesContain(currentField.get().steep.far)
        && (currentField.get().shallow.doesContain(new Offset(0, 1))
            || currentField.get().shallow.doesContain(new Offset(1, 0))))
    {
      result = activeFields.erase(currentField);
    }
    return result;
  }

  private static function addShallowBump(point : Offset,
                                         currentField : DIterator<Field>,
                                         steepBumps : DList<Bump>,
                                         shallowBumps : DList<Bump>) : Void
  {
    currentField.get().shallow.far = new Offset(point.x, point.y);
    shallowBumps.push_back(new Bump());
    shallowBumps.back().location = new Offset(point.x, point.y);
    shallowBumps.back().parent = currentField.get().shallowBump;
    currentField.get().shallowBump = shallowBumps.back();
    var currentBump = currentField.get().steepBump;
    while (currentBump != null)
    {
      if (currentField.get().shallow.isAbove(currentBump.location))
      {
        currentField.get().shallow.near = new Offset(currentBump.location.x,
                                                     currentBump.location.y);
      }
      currentBump = currentBump.parent;
    }
  }

  private static function addSteepBump(point : Offset,
                                       currentField : DIterator<Field>,
                                       steepBumps : DList<Bump>,
                                       shallowBumps : DList<Bump>) : Void
  {
    currentField.get().steep.far = new Offset(point.x, point.y);
    steepBumps.push_back(new Bump());
    steepBumps.back().location = new Offset(point.x, point.y);
    steepBumps.back().parent = currentField.get().steepBump;
    currentField.get().steepBump = steepBumps.back();
    var currentBump = currentField.get().shallowBump;
    while (currentBump != null)
    {
      if (currentField.get().steep.isBelow(currentBump.location))
      {
        currentField.get().steep.near = new Offset(currentBump.location.x,
                                                   currentBump.location.y);
      }
      currentBump = currentBump.parent;
    }
  }

  private static function actIsBlocked(state : FovState, pos : Offset) : Bool
  {
    var adjustedPos = new Offset(pos.x*state.quadrant.x + state.source.x,
                                 pos.y*state.quadrant.y + state.source.y);
    var result = state.isBlocked(adjustedPos.x, adjustedPos.y);
    if ((state.quadrant.x * state.quadrant.y == 1
         && pos.x == 0 && pos.y != 0)
        || (state.quadrant.x * state.quadrant.y == -1
            && pos.y == 0 && pos.x != 0))
    {
      return result;
    }
    else
    {
      state.visit(adjustedPos.x, adjustedPos.y);
      return result;
    }
  }

  public static function permissiveFov(sourceX : Int,
                                       sourceY : Int,
                                       radius : Int,
                                       isBlocked : Int -> Int -> Bool,
                                       visit : Int -> Int -> Void) : Void
  {
    var state : FovState = new FovState();
    state.source = new Offset(sourceX, sourceY);
    state.isBlocked = isBlocked;
    state.visit = visit;

    var quadrants : Array<Offset> = [new Offset(1, 1),
                                     new Offset(-1, 1),
                                     new Offset(-1, -1),
                                     new Offset(1, -1)];
    var extents : Array<Offset> = [new Offset(radius, radius),
                                   new Offset(radius, radius),
                                   new Offset(radius, radius),
                                   new Offset(radius, radius)];
    var quadrantIndex = 0;
    for (i in 0...(quadrants.length))
    {
      state.quadrant = quadrants[i];
      state.extent = extents[i];
      calculateFovQuadrant(state);
    }
  }
}
