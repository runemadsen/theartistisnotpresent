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
  int backgroundType;

  // Constructor
  //----------------------------------------------------------------

  Composition()
  {
    chooseBackground();
    chooseNumShapes();
    chooseShapeSize();
    chooseShapeType();
    chooseShapeSpacing();
    chooseShapeDisplacementY();
    chooseShapeRotation();
    choosePosition();
    chooseFullShapeRotation();
  }

  // Choose: Background
  //----------------------------------------------------------------

  void chooseBackground()
  {
    WeightedRandomSet<Integer> backgrounds = new WeightedRandomSet<Integer>();
    backgrounds.add(DARKEST, 1);
    backgrounds.add(BRIGHTEST, 1);
    backgrounds.add(RANDOM, 1);
    backgrounds.add(DARKGRAY, 1);
    backgrounds.add(WHITE, 1);
    backgroundType = backgrounds.getRandom();
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
}