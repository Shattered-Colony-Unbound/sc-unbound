package mapgen;

class Parameter
{
  public static var roofOverlayChance = 5;
  public static var rubbleStreetFactor = 0.15;
  public static var zombieStreetFactor = 0.1;

  // Weighted rubble frames
  public static var rubbleWeight = [0, 0, 0, 0, 10,
                                    10, 30, 30, 30, 30,
                                    30, 30, 30, 10, 30,
                                    5, 5, 5, 5, 5];
}
