package mapgen;

enum CrossStreet
{
  // Used for two-wide parking entrances
  BEGIN_PARKING_ENTRANCE;
  END_PARKING_ENTRANCE;
  // Used for one-wide parking entrances
  PARKING_ENTRANCE;
  ALLEY;
  ROAD;
  NONE;
}
