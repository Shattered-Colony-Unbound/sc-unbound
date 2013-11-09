class ResourceCount
{
  public function new(newResource : Resource, newCount : Int) : Void
  {
    resource = newResource;
    count = newCount;
  }

  public var resource : Resource;
  public var count : Int;
}
