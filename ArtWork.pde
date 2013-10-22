class ArtWork
{
  // Properties
  //----------------------------------------------------------------

  Ani easing;
  PVector loc;
  RShape art;
  PGraphics canvas;

  // Constructor
  //----------------------------------------------------------------

  ArtWork(Sample sample, int w, int h, int x, int y)
  {
    loc = new PVector(x, y);
    art = sampleToShape(sample, w, h);
    canvas = createGraphics(w, h);

    // draw art to canvas
    canvas.beginDraw();
    canvas.colorMode(HSB, 1, 1, 1, 1);
    canvas.smooth();  
    art.draw(canvas);
    canvas.endDraw();
  }

  // Display
  //----------------------------------------------------------------

  void display()
  {
    image(canvas, loc.x, loc.y); 
  }

  void moveTo(int x, int y, int sec)
  {
    Ani.to(loc, sec, "x", x, Ani.QUAD_OUT);
    Ani.to(loc, sec, "y", y, Ani.QUAD_OUT);
  }

  // Sample to RShape
  //----------------------------------------------------------------
  
  RShape sampleToShape(Sample sample, int w, int h)
  {
    //--> Setup

    ColorList colors = sample.colorscheme.getColors();

    TColor bgColor = sample.colorscheme.getBackgroundColor(colors);
    RShape frontShape = sample.composition.getShape(w, h);
    RShape backgroundShape = RShape.createRectangle(0, 0, w, h);
    ColorList frontColors = new ColorList();

    //--> Background

    backgroundShape.setStroke(false);
    backgroundShape.setFill(bgColor.toARGB());

    //--> Remove Background Color
    
    for(int i = 0; i < colors.size(); i++)
    {
      if(!colors.get(i).equals(bgColor))  frontColors.add(colors.get(i));
    }
  
    //--> Color Fill

    for(int i = 0; i < frontShape.children.length; i++)
    {
      TColor col = frontColors.get(i % frontColors.size());
      frontShape.children[i].setFill(col.toARGB());
      frontShape.children[i].setStroke(false);
    }
  
    backgroundShape.addChild(frontShape);  
    return backgroundShape;
  }

  // Saving
  //----------------------------------------------------------------

  void saveSVG(String filename, int w, int h)
  {
    RG.saveShape(filename, art);

    XML xml = loadXML(filename);
    xml.setString("width", w + "px");
    xml.setString("height", h + "px");
    saveXML(xml, filename);
  }
}