class Composition
{
  // Properties
  //----------------------------------------------------------------

  int shapeType;
  float shapeSize;
  float shapeSpacing;
  int shapeRotation;
  float shapeDisplacementY;
  int numShapes;
  int fullShapeRotation;
  int positionType;

  // Constructor
  //----------------------------------------------------------------

  Composition()
  {
    chooseNumShapes();
    chooseShapeSize();
    chooseShapeType();
    chooseShapeSpacing();
    chooseShapeDisplacementY();
    chooseShapeRotation();
    choosePosition();
    chooseFullShapeRotation();
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
    shapeSize = random(0.05, 1);
  }
  
  // Choose: Shape Type
  //----------------------------------------------------------------
  
  void chooseShapeType()
  {
    WeightedRandomSet<Integer> shapes = new WeightedRandomSet<Integer>();
    shapes.add(TRIANGLE, 1);
    shapes.add(RECTANGLE, 1);
    shapes.add(ELLIPSE, 1);
    shapeType = shapes.getRandom();
  }
  
  // Choose: Shape Spacing
  //----------------------------------------------------------------
  
  void chooseShapeSpacing()
  {
    WeightedRandomSet<Float> spacings = new WeightedRandomSet<Float>();
    spacings.add(0.0, 1);
    spacings.add(0.5, 1);
    spacings.add(1.0, 1);
    spacings.add(random(1), 1);
    shapeSpacing = spacings.getRandom();
  }
  
  // Choose: Shape Displacement Y
  //----------------------------------------------------------------
  
  void chooseShapeDisplacementY()
  {
    WeightedRandomSet<Float> displacements = new WeightedRandomSet<Float>();
    displacements.add(0.0, 15);
    displacements.add(0.1, 1);
    displacements.add(0.2, 1);
    displacements.add(0.3, 1);
    displacements.add(0.4, 1);
    displacements.add(0.5, 1);
    displacements.add(random(1), 1);
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
    //positions.add(CENTER, 1);
    //positions.add(ROTATION, 1);
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

  // Get Shape
  //----------------------------------------------------------------

  RShape getShape(int w, int h)
  {
    RShape frontShape = new RShape();

    int scaledShapeSize           = round(shapeSize * w);
    int scaledShapeSpacing        = round(scaledShapeSize * shapeSpacing);
    int scaleShapeDisplacementY   = round(scaledShapeSize * shapeDisplacementY);

    if(positionType == HORIZONTAL)
    {
      for(int i = 0; i < numShapes; i++)
      {
        int x = (i * scaledShapeSize) + (i * scaledShapeSpacing);
        RShape newShape = getShapeType(shapeType, scaledShapeSize);
        newShape.translate(x, i * shapeDisplacementY);
        newShape.rotate(radians(shapeRotation * i), new RPoint(newShape.getX() + (newShape.getWidth()/2), newShape.getY() + (newShape.  getHeight()/2)));
        frontShape.addChild(newShape);
      }
    }
  
    else if(positionType == GRID)
    {
      for(int i = 0; i < numShapes; i++)
      {
        for(int j = 0; j < numShapes; j++)
        {
          int x = (i * scaledShapeSize) + (i * scaledShapeSpacing);
          int y = (j * scaledShapeSize) + (j * scaledShapeSpacing);
          RShape newShape = getShapeType(shapeType, scaledShapeSize);
          newShape.translate(x, y);
          newShape.rotate(radians(shapeRotation * i), new RPoint(newShape.getX() + (newShape.getWidth()/2), newShape.getY() + (newShape.  getHeight()/2)));
          frontShape.addChild(newShape);
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
  
    // place in center of screen - important this happens before rotation!
    frontShape.translate((w/2) - (frontShape.getWidth()/2), (h/2) - (frontShape.getHeight()/2));
  
    // rotate
    frontShape.rotate(radians(fullShapeRotation), new RPoint(frontShape.getX() + (frontShape.getWidth()/2), frontShape.getY() + (frontShape.getHeight ()/2)));
    
    return frontShape;
  }

  // Get Shape Type
  //----------------------------------------------------------------

  RShape getShapeType(int type, int shapeSize)
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