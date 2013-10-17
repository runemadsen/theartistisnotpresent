class RandomAccessor extends AccessCriteria
{
  int compare(ReadonlyTColor a, ReadonlyTColor b)
  {
    return int(random(2));
  }

  float getComponentValueFor(ReadonlyTColor col) { return 0; }
  void  setComponentValueFor(TColor col, float val) {}
}