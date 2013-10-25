class ArtWork
{
  // Properties
  //----------------------------------------------------------------

  Sample sample;
  RShape art;
  PGraphics canvas;
  int w;
  int h;

  // Constructor
  //----------------------------------------------------------------

  ArtWork(Sample _sample, int _w, int _h)
  {
    w = _w;
    h = _h;

    sample = _sample;
    canvas = createGraphics(w, h);
    art = getShape();

    canvas.beginDraw();
    canvas.colorMode(HSB, 1, 1, 1, 1);
    //canvas.smooth();  
    art.draw(canvas);
    canvas.endDraw();
  }

  //void moveTo(int x, int y, int sec)
  //{
  //  Ani.to(loc, sec, "x", x, Ani.QUAD_OUT);
  //  Ani.to(loc, sec, "y", y, Ani.QUAD_OUT);
  //}

  // Sample to RShape
  //----------------------------------------------------------------
  
  RShape getShape()
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
      if(!colors.get(i).equals(bgColor))
      {
        frontColors.add(colors.get(i));
      }
    }
  
    //--> Color Fill

    for(int i = 0; i < frontShape.children.length; i++)
    {
      TColor col = frontColors.get(i % frontColors.size());

      if(sample.composition.fillMode == FILL)
      {
        frontShape.children[i].setFill(col.toARGB());
        frontShape.children[i].setStroke(false);
      }
      else
      {
        frontShape.children[i].setStrokeWeight(3);
        frontShape.children[i].setStroke(col.toARGB());
        frontShape.children[i].setFill(false);
      }
      
    }
  
    backgroundShape.addChild(frontShape); 

    return backgroundShape;
  }

  // Saving
  //----------------------------------------------------------------

  void saveSVG(String filename, RShape art, int w, int h)
  {
    RG.saveShape(filename, art);

    XML xml = loadXML(filename);
    xml.setString("width", w + "px");
    xml.setString("height", h + "px");
    saveXML(xml, filename);
  }
}