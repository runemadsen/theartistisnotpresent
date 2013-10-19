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
    RShape frontShape = sample.composition.getShape(w, h);
    RShape backgroundShape = RShape.createRectangle(0, 0, w, h);

    //--> Background

    ReadonlyTColor bg;
    if(sample.composition.backgroundType == DARKEST)         bg = colors.getDarkest();
    else if(sample.composition.backgroundType == BRIGHTEST)  bg = colors.getLightest();
    else if(sample.composition.backgroundType == RANDOM)     bg = colors.getRandom();
    else if(sample.composition.backgroundType == DARKGRAY)   bg = TColor.newHSV(0, 0, 0.1);
    else                                                                        bg = TColor.newHSV(0, 0, 1);

    backgroundShape.setStroke(false);
    backgroundShape.setFill(bg.toARGB());
    colors = removeColor(colors, bg);
  
    //--> Color Fill

    for(int i = 0; i < frontShape.children.length; i++)
    {
      TColor col = colors.get(i % colors.size());
      frontShape.children[i].setFill(col.toARGB());
      frontShape.children[i].setStroke(false);
    }
  
    backgroundShape.addChild(frontShape);  
    return backgroundShape;
  }

  // Choose: Helpers
  //----------------------------------------------------------------

  ColorList removeColor(ColorList cols, ReadonlyTColor col)
  {
    ColorList newCols = new ColorList();
    for(int i = 0; i < cols.size(); i++)
    {
      if(!cols.get(i).equals(col))
      {
        newCols.add(cols.get(i));
      }
    }
    return newCols;
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