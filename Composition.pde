class Composition
{
  // Constants
  //----------------------------------------------------------------

  int HORIZONTAL = 0;
  int GRID = 1;
  int CENTER = 2;
  int ROTATION = 3;
  
  int TRIANGLE = 0;
  int ELLIPSE = 1;
  int RECTANGLE = 2;

  // Properties
  //----------------------------------------------------------------

  int w;
  int h;

  int shapeType;
  int shapeSize;
  int shapeSpacing;
  int shapeRotation;
  int shapeDisplacementY;
  int numShapes;
  int fullShapeRotation;
  int positionType;

  // Constructor
  //----------------------------------------------------------------

  Composition(int _w, int _h)
  {
    w = _w;
    h = _h;
  }

  // Choose: Num Shapes
  //----------------------------------------------------------------
  
  void chooseNumShapes()
  {
    WeightedRandomSet<Integer> nums = new WeightedRandomSet<Integer>();
    nums.add(1, 1);
    nums.add(round(random(2, 5)), 1);
    nums.add(round(random(6, 20)), 1);
    numShapes = nums.getRandom();
  }
  
  // Choose: Shape Size
  //----------------------------------------------------------------
  
  void chooseShapeSize()
  {
    shapeSize = round(random(w * 0.05, w));
  }
  
  // Choose: Shape Type
  //----------------------------------------------------------------
  
  void chooseShapeType()
  {
    WeightedRandomSet<Integer> shapes = new WeightedRandomSet<Integer>();
    shapes.add(TRIANGLE, 1);
    shapes.add(RECTANGLE, 1);
    shapes.add(ELLIPSE, 1);
  
    // we could manipulate it here in size
    // we could add numerous shapes?
  
    shapeType = shapes.getRandom();
  }
  
  // Choose: Shape Spacing
  //----------------------------------------------------------------
  
  void chooseShapeSpacing()
  {
    WeightedRandomSet<Integer> spacings = new WeightedRandomSet<Integer>();
    spacings.add(0, 1);
    spacings.add(round(shapeSize/2), 1);
    spacings.add(shapeSize, 1);
    spacings.add(round(random(w)), 1);
    shapeSpacing = spacings.getRandom();
  }
  
  // Choose: Shape Displacement Y
  //----------------------------------------------------------------
  
  void chooseShapeDisplacementY()
  {
    WeightedRandomSet<Integer> displacements = new WeightedRandomSet<Integer>();
    displacements.add(0, 15);
    displacements.add(round(shapeSize * 0.1), 1);
    displacements.add(round(shapeSize * 0.2), 1);
    displacements.add(round(shapeSize * 0.3), 1);
    displacements.add(round(shapeSize * 0.4), 1);
    displacements.add(round(shapeSize * 0.5), 1);
    displacements.add(round(random(shapeSize)), 1);
    shapeDisplacementY = displacements.getRandom();
  }
  
  // Choose: Shape Rotation
  //----------------------------------------------------------------
  
  void chooseShapeRotation()
  {
    WeightedRandomSet<Integer> rotations = new WeightedRandomSet<Integer>();
    rotations.add(0, 8);
    rotations.add(45, 1);
    rotations.add(90, 1);
    rotations.add(135, 1);
    rotations.add(180, 4);
    rotations.add(225, 1);
    rotations.add(270, 1);
    rotations.add(315, 1);
    rotations.add(round(random(360)), 2);
    shapeRotation = rotations.getRandom();
  }
  
  // Choose: Position
  //----------------------------------------------------------------
  
  void choosePosition()
  {
    WeightedRandomSet<Integer> positions = new WeightedRandomSet<Integer>();
    positions.add(HORIZONTAL, 1);
    positions.add(GRID, 1);
    positions.add(CENTER, 1);
    positions.add(ROTATION, 1);
    positionType = positions.getRandom();
  }
  
  // Choose: Full Shape Rotation
  //----------------------------------------------------------------
  
  void chooseFullShapeRotation()
  {
    WeightedRandomSet<Integer> rotations = new WeightedRandomSet<Integer>();
    rotations.add(0, 15);
    rotations.add(45, 1);
    rotations.add(90, 1);
    rotations.add(135, 1);
    rotations.add(180, 4);
    rotations.add(225, 1);
    rotations.add(270, 1);
    rotations.add(315, 1);
    rotations.add(round(random(360)), 2);
    fullShapeRotation = rotations.getRandom();
  }

  // Generate Shape
  //----------------------------------------------------------------

  RShape getShape(ColorList colors)
  {
    RShape theShape = new RShape();

    // make sure the shape is correct dimensions

    // colors background
  
    positionType = GRID;
  
    // horizontal
    if(positionType == HORIZONTAL)
    {
      for(int i = 0; i < numShapes; i++)
      {
        int x = (i * shapeSize) + (i * shapeSpacing);
        RShape newShape = getShapeType(shapeType);
        newShape.translate(x, i * shapeDisplacementY);
        newShape.rotate(radians(shapeRotation * i), new RPoint(newShape.getX() + (newShape.getWidth()/2), newShape.getY() + (newShape.  getHeight()/2)));
        theShape.addChild(newShape);
      }
    }
  
    // grid
    else if(positionType == GRID)
    {
      for(int i = 0; i < numShapes; i++)
      {
        for(int j = 0; j < numShapes; j++)
        {
          int x = (i * shapeSize) + (i * shapeSpacing);
          int y = (j * shapeSize) + (j * shapeSpacing);
          RShape newShape = getShapeType(shapeType);
          newShape.translate(x, y);
          newShape.rotate(radians(shapeRotation * i), new RPoint(newShape.getX() + (newShape.getWidth()/2), newShape.getY() + (newShape.  getHeight()/2)));
          theShape.addChild(newShape);
        }
      }
    }
  
    // center
    else if(positionType == CENTER)
    {
  
    }
  
    // rotation
    else if(positionType == ROTATION)
    {
  
    }

    // set colors
    for(int i = 0; i < theShape.children.length; i++)
    {
      TColor col = colors.get(i % colors.size());
      theShape.children[i].setFill(col.toARGB());
      theShape.children[i].setStroke(false);
    }
  
    // place in center of screen - important this happens before rotation!
    theShape.translate((w/2) - (theShape.getWidth()/2), (h/2) - (theShape.getHeight()/2));
  
    // rotate
    theShape.rotate(radians(fullShapeRotation), new RPoint(theShape.getX() + (theShape.getWidth()/2), theShape.getY() + (theShape.getHeight ()/2)));
    
    return theShape;
  }
  
  // Choose: Helpers
  //----------------------------------------------------------------

  RShape getShapeType(int type)
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
}