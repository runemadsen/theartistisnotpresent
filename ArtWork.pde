class ArtWork
{
  // Properties
  //----------------------------------------------------------------

  RShape art;
  PGraphics canvas;

  // Constructor
  //----------------------------------------------------------------

  ArtWork(Sample sample, int w, int h)
  {
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
    image(canvas, 0, 0);
  }

  // Sample to RShape
  //----------------------------------------------------------------
  
  RShape sampleToShape(Sample sample, int w, int h)
  {
    sample.composition.positionType = GRID;

    //--> Setup

    ColorList colors = sample.colorscheme.colors;
    RShape frontShape = new RShape();
    RShape backgroundShape = RShape.createRectangle(0, 0, w, h);

    int shapeSize           = round(sample.composition.shapeSize * w);
    int shapeSpacing        = round(shapeSize * sample.composition.shapeSpacing);
    int shapeDisplacementY  = round(shapeSize * sample.composition.shapeDisplacementY);

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
  
    //--> Position

    if(sample.composition.positionType == HORIZONTAL)
    {
      for(int i = 0; i < sample.composition.numShapes; i++)
      {
        int x = (i * shapeSize) + (i * shapeSpacing);
        RShape newShape = getShape(sample.composition.shapeType, shapeSize);
        newShape.translate(x, i * shapeDisplacementY);
        newShape.rotate(radians(sample.composition.shapeRotation * i), new RPoint(newShape.getX() + (newShape.getWidth()/2), newShape.getY() + (newShape.  getHeight()/2)));
        frontShape.addChild(newShape);
      }
    }
  
    // grid
    else if(sample.composition.positionType == GRID)
    {
      for(int i = 0; i < sample.composition.numShapes; i++)
      {
        for(int j = 0; j < sample.composition.numShapes; j++)
        {
          int x = (i * shapeSize) + (i * shapeSpacing);
          int y = (j * shapeSize) + (j * shapeSpacing);
          RShape newShape = getShape(sample.composition.shapeType, shapeSize);
          newShape.translate(x, y);
          newShape.rotate(radians(sample.composition.shapeRotation * i), new RPoint(newShape.getX() + (newShape.getWidth()/2), newShape.getY() + (newShape.  getHeight()/2)));
          frontShape.addChild(newShape);
        }
      }
    }
  
    // center
    else if(sample.composition.positionType == CENTER)
    {
  
    }
  
    // rotation
    else if(sample.composition.positionType == ROTATION)
    {
  
    }

    // set colors
    for(int i = 0; i < frontShape.children.length; i++)
    {
      TColor col = colors.get(i % colors.size());
      frontShape.children[i].setFill(col.toARGB());
      frontShape.children[i].setStroke(false);
    }
  
    // place in center of screen - important this happens before rotation!
    frontShape.translate((w/2) - (frontShape.getWidth()/2), (h/2) - (frontShape.getHeight()/2));
  
    // rotate
    frontShape.rotate(radians(sample.composition.fullShapeRotation), new RPoint(frontShape.getX() + (frontShape.getWidth()/2), frontShape.getY() + (frontShape.getHeight ()/2)));

    backgroundShape.addChild(frontShape);
    
    return backgroundShape;
  }

  // Choose: Helpers
  //----------------------------------------------------------------

  RShape getShape(int type, int shapeSize)
  {
    RShape returnShape;
  
    if(type == ELLIPSE)
    {
      returnShape = RShape.createCircle(0, 0, shapeSize);
      returnShape.translate(returnShape.getWidth()/2, returnShape.getHeight()/2);
    }
    else if(type == RECTANGLE)
    {
      returnShape = RShape.createRectangle(0, 0, shapeSize, shapeSize);
    }
    else
    {
      float half = shapeSize/2;
      returnShape = new RShape();
      returnShape.addLineTo(half, shapeSize);
      returnShape.addLineTo(-half, shapeSize);
      returnShape.addLineTo(0, 0);
      returnShape.translate(returnShape.getWidth()/2, 0);
    }
  
    return returnShape;
  }

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