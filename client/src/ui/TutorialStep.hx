package ui;

// offset and size can be null. If they are null, then there is no
// valid click area and the next step in the tutorial must be
// triggered by something else.
class TutorialStep
{
  public function new(newType : Int,
                      ? newPos : Point,
                      ? newDir : Direction,
                      ? newSelect : Point,
                      ? optPlaceType : Null<Int>,
                      ? newPlace : Point) : Void
  {
    type = newType;
    pos = newPos;
    dir = Direction.NORTH;
    if (newDir != null)
    {
      dir = newDir;
    }
    select = newSelect;
    placeType = ui.Tutorial.MOVE_WINDOW;
    if (optPlaceType != null)
    {
      placeType = optPlaceType;
    }
    place = newPlace;
    linkage = "";
  }

  // If select is set, the arrow first points to the map position at
  // select before pointing at the position at pos once that position
  // is selected.
  public var select : Point;
  // The type of trigger which will move to the next step. This
  // determines whether pos is a map position or a button. If pos is a
  // map position, that trigger must happen at that position.
  public var type : Int;
  // If the player is supposed to click on a map position, this is the
  // map position in absolute cells they are supposed to click
  // on. Otherwise, it is the position of a button/widget that must be
  // clicked.
  public var pos : Point;
  // The event type to be placed.
  public var placeType : Int;
  // If place is set, the arrow points to a location on the map after
  // pos and waits for an event.
  public var place : Point;
  // Direction the arrow will be pointing.
  public var dir : Direction;
  // Linkage of tutorial screen if any
  public var linkage : String;
}
