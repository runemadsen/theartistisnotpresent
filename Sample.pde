class Sample {
  
  double[] featureVector;
  int label;

  ColorScheme colorscheme;
  Composition composition;

  // New from CSV String
  // ------------------------------------------------------

  Sample(String csvString)
  {
    String[] nums = csvString.split(",");
    double[] newFeatureVector = new double[nums.length - 1]; // minus one to not include label
    
    for(int i = 0; i < nums.length - 1; i++)
    {
      newFeatureVector[i] = Double.parseDouble(nums[i]);
    }

    fromFeatureVector(newFeatureVector);
    label = Integer.parseInt(nums[nums.length - 1]);
  }

  // New Random
  // ------------------------------------------------------

  Sample()
  {
    ColorScheme newColorscheme = getColorSchemeFromInteger(round(random(5)));
    Composition newComposition = new Composition();
    fromObjects(newColorscheme, newComposition);
  }

  // New Existing
  // ------------------------------------------------------

  Sample(double[] newFeatureVector)
  {
    fromFeatureVector(newFeatureVector);
  }

  Sample(double[] newFeatureVector, int newLabel)
  {
    fromFeatureVector(newFeatureVector);
    label = newLabel;
  }

  // Feature To Objects
  // ------------------------------------------------------

  void fromFeatureVector(double[] newFeatureVector)
  {
    featureVector = newFeatureVector;
    colorscheme = getColorSchemeFromInteger((int) featureVector[0]);
    composition = new Composition();

    // MAKE SURE THESE ALWAYS FIT WITH ORDER FROM UNDERNEATH
    colorscheme.hue =                  (float)  featureVector[1];
    colorscheme.angle =                (float)  featureVector[2];
    colorscheme.moreColors =           (int)    featureVector[3];
    colorscheme.moreColorsType =       (int)    featureVector[4];
    colorscheme.moreColorsSatLow =     (float)  featureVector[5];
    colorscheme.moreColorsBriLow =     (float)  featureVector[6];
    colorscheme.moreColorsSatEasing =  (int)    featureVector[7];
    colorscheme.moreColorsBriEasing =  (int)    featureVector[8];
    colorscheme.scaleSat =             (float)  featureVector[9];
    colorscheme.scaleBri =             (float)  featureVector[10];
    colorscheme.sortMode =             (int)    featureVector[11];
    colorscheme.sortReversed =         (int)    featureVector[12];
    composition.shapeType =            (int)    featureVector[13];
    composition.shapeSize =            (float)  featureVector[14];
    composition.shapeSpacing =         (float)  featureVector[15];
    composition.shapeRotation =        (int)    featureVector[16];
    composition.shapeDisplacementY =   (float)  featureVector[17];
    composition.numShapes =            (int)    featureVector[18];
    composition.fullShapeRotation =    (int)    featureVector[19];
    composition.positionType =         (int)    featureVector[20];
    composition.backgroundType =       (int)    featureVector[21];
  }

  // Objects to Feature
  // ------------------------------------------------------

  void fromObjects(ColorScheme newColorscheme, Composition newComposition)
  {
    colorscheme = newColorscheme;
    composition = newComposition;

    // MAKE SURE THESE ALWAYS FIT WITH ORDER FROM ABOVE
    double[] newFeatureVector = {
      (double) colorscheme.getIndex(),                           // (int)    index number of color scheme
      (double) colorscheme.hue,                       // (float)  0-1
      (double) colorscheme.angle,                     // (float)  0-1
      (double) colorscheme.moreColors,                // (int)    number of colors, 0 if none
      (double) colorscheme.moreColorsType,            // (int)    sat, bri or both satbri
      (double) colorscheme.moreColorsSatLow,          // (float)  multiplier
      (double) colorscheme.moreColorsBriLow,          // (float)  multiplier
      (double) colorscheme.moreColorsSatEasing,       // (int)    index number of easing
      (double) colorscheme.moreColorsBriEasing,       // (int)    index number of easing
      (double) colorscheme.scaleSat,                  // (float)  multiplier
      (double) colorscheme.scaleBri,                  // (float)  multiplier
      (double) colorscheme.sortMode,                  // (int)    constant val of sortMode
      (double) colorscheme.sortReversed,              // (float)  0 or 1 for reversed
      (double) composition.shapeType,                 // (int)    constant val of shape
      (double) composition.shapeSize,                 // (float)  normalized size of shape
      (double) composition.shapeSpacing,              // (float)  normalized shape spacing
      (double) composition.shapeRotation,             // (int)    degrees
      (double) composition.shapeDisplacementY,        // (float)  normalized displacement
      (double) composition.numShapes,                 // (int)    number of shapes
      (double) composition.fullShapeRotation,         // (int)    degrees
      (double) composition.positionType,              // (int)    constant val of position type
      (double) composition.backgroundType             // (int)    constants val of background type
    };
    featureVector = newFeatureVector;
  }

  // Mutants! Oh Mutants!
  // ------------------------------------------------------

  Sample crossover(Sample partner)
  {
    double[] childFeatureVector = new double[featureVector.length];
    int splitIndex = int(random(featureVector.length));
    
    for(int i = 0; i < featureVector.length; i++)
    {
      if (i > splitIndex) childFeatureVector[i] = featureVector[i];
      else                childFeatureVector[i] = partner.featureVector[i];
    }
  
    return new Sample(childFeatureVector);
  }
  
  void mutate(float m)
  {
    for(int i = 0; i < featureVector.length; i++)
    {
      if(random(1) < m)
      {
        //featureVector[i] = 
      }
    }
  }

  // Getter / Setter
  // ------------------------------------------------------

  ColorScheme getColorSchemeFromInteger(int type)
  {
    if(type == 0)         return new ColorSchemeMonoChrome();
    else if(type == 1)    return new ColorSchemeTriadic();
    else if(type == 2)    return new ColorSchemeComplementary();
    else if(type == 3)    return new ColorSchemeTetradic();
    else if(type == 4)    return new ColorSchemeAnalogous();
    else                  return new ColorSchemeAccentedAnalogous();
  }
  
  void setLabel(int label)
  {
    this.label = label;
  }

  // To String
  // ------------------------------------------------------

  String toString()
  {
    String output = "";
    for(int i = 0; i < featureVector.length; i++)
    {
      output += featureVector[i] + ",";
    }
    output += label;
    return output;
  }
}