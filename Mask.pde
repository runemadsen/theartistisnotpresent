class Mask
{
  RShape m;

  Mask()
  {
    m = RShape.createRectangle(0, 0, width, height);
    m.setStroke(false);
    m.setFill(color(0));
  }

  void addWindow(int x, int y, int w, int h)
  {
    m = m.xor(RShape.createRectangle(x, y, w, h));
  }

  void display()
  {
    m.draw();
  }
}