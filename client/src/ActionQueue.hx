class ActionQueue
{
  public function new() : Void
  {
    actions = new List<action.Interface>();
  }

  public function runAll() : Void
  {
    while (! actions.isEmpty())
    {
      actions.first().run();
      actions.pop();
    }
  }

  public function push(newAction : action.Interface) : Void
  {
    if (newAction != null)
    {
      actions.add(newAction);
    }
  }

  var actions : List<action.Interface>;
}
