class Sample {
  
  double[] featureVector;
  int label;

  ColorScheme colorscheme;
  Composition composition;

  // Constructors
  // ------------------------------------------------------

  Sample()
  {
    ColorScheme newColorscheme = new ColorScheme();
    Composition newComposition = new Composition();
    fromObjects(newColorscheme, newComposition);
  }

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
    colorscheme = new ColorScheme();
    composition = new Composition();

    // MAKE SURE THESE ALWAYS FIT WITH ORDER FROM UNDERNEATH
    colorscheme.hue =                       (float) featureVector[0];
    colorscheme.numColors =                   (int) featureVector[1];
    colorscheme.colorDistance =             (float) featureVector[2];
    colorscheme.moreColors =                  (int) featureVector[3];
    colorscheme.moreColorsMode =              (int) featureVector[4];
    colorscheme.moreColorsSaturationBase =  (float) featureVector[5];
    colorscheme.moreColorsBrightnessBase =  (float) featureVector[6];
    colorscheme.moreColorsSaturationEasing =  (int) featureVector[7];
    colorscheme.moreColorsBrightnessEasing =  (int) featureVector[8];
    colorscheme.saturationScale =           (float) featureVector[9];
    colorscheme.brightnessScale =           (float) featureVector[10];
    colorscheme.sortMode =                    (int) featureVector[11];
    colorscheme.sortReversed =                (int) featureVector[12];
    colorscheme.backgroundMode =              (int) featureVector[13];
    composition.shapeType =                   (int) featureVector[14];
    composition.shapeSize =                 (float) featureVector[15];
    composition.shapeSpacing =              (float) featureVector[16];
    composition.shapeRotation =               (int) featureVector[17];
    composition.shapeDisplacementY =        (float) featureVector[18];
    composition.numShapes =                   (int) featureVector[19];
    composition.fullShapeRotation =           (int) featureVector[20];
    composition.positionType =                (int) featureVector[21];
    composition.divide =                      (int) featureVector[22];
    composition.divideRotation =              (int) featureVector[23];
    composition.fillMode =                    (int) featureVector[24];
  }

  // Objects to Feature
  // ------------------------------------------------------

  void fromObjects(ColorScheme newColorscheme, Composition newComposition)
  {
    colorscheme = newColorscheme;
    composition = newComposition;

    // MAKE SURE THESE ALWAYS FIT WITH ORDER FROM ABOVE
    double[] newFeatureVector = {         
      (double) colorscheme.hue,
      (double) colorscheme.numColors,
      (double) colorscheme.colorDistance,
      (double) colorscheme.moreColors,
      (double) colorscheme.moreColorsMode,
      (double) colorscheme.moreColorsSaturationBase,
      (double) colorscheme.moreColorsBrightnessBase,
      (double) colorscheme.moreColorsSaturationEasing,
      (double) colorscheme.moreColorsBrightnessEasing,
      (double) colorscheme.saturationScale,
      (double) colorscheme.brightnessScale,
      (double) colorscheme.sortMode,
      (double) colorscheme.sortReversed,
      (double) colorscheme.backgroundMode,
      (double) composition.shapeType,
      (double) composition.shapeSize,
      (double) composition.shapeSpacing,
      (double) composition.shapeRotation,
      (double) composition.shapeDisplacementY,
      (double) composition.numShapes,
      (double) composition.fullShapeRotation,
      (double) composition.positionType,
      (double) composition.divide,
      (double) composition.divideRotation,
      (double) composition.fillMode
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
    Sample mutant = new Sample();
    mutant.fromFeatureVector(mutant.featureVector); // hack to set composition and colorscheme

    for(int i = 0; i < featureVector.length; i++)
    {
      if(random(1) < m)
      {
        featureVector[i] = mutant.featureVector[i];
      }
    }
  }

  // Label
  // ------------------------------------------------------
  
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