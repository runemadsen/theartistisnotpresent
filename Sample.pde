class Sample {
  
  double[] featureVector;
  int label;

  ColorScheme colorScheme;
  Composition composition;

  // New Random
  // ------------------------------------------------------

  Sample()
  {
    int schemeIndex = round(random(5));
    if(schemeIndex == 0)         colorScheme = new ColorSchemeMonoChrome();
    else if(schemeIndex == 1)    colorScheme = new ColorSchemeTriadic();
    else if(schemeIndex == 2)    colorScheme = new ColorSchemeComplementary();
    else if(schemeIndex == 3)    colorScheme = new ColorSchemeTetradic();
    else if(schemeIndex == 4)    colorScheme = new ColorSchemeAnalogous();
    else if(schemeIndex == 5)    colorScheme = new ColorSchemeAccentedAnalogous();
     
    composition = new Composition();

    featureVector = {
      (double) schemeIndex,                       // (int)    index number of color scheme
      (double) scheme.hue,                        // (float)  0-1
      (double) scheme.angle,                      // (float)  0-1
      (double) scheme.moreColors,                 // (int)    number of colors, 0 if none
      (double) scheme.moreColorsType,             // (int)    sat, bri or both satbri
      (double) scheme.moreColorsSatLow,           // (float)  multiplier
      (double) scheme.moreColorsBriLow,           // (float)  multiplier
      (double) scheme.moreColorsSatEasing,        // (int)    index number of easing
      (double) scheme.moreColorsBriEasing,        // (int)    index number of easing
      (double) scheme.scaleSat,                   // (float)  multiplier
      (double) scheme.scaleBri,                   // (float)  multiplier
      (double) composition.shapeType;             // (int)    constant val of shape
      (double) composition.shapeSize;             // (float)  normalized size of shape
      (double) composition.shapeSpacing;          // (float)  normalized shape spacing
      (double) composition.shapeRotation;         // (int)    degrees
      (double) composition.shapeDisplacementY;    // (float)  normalized displacement
      (double) composition.numShapes;             // (int)    number of shapes
      (double) composition.fullShapeRotation;     // (int)    degrees
      (double) composition.positionType;          // (int)    constant val of position type
      (double) composition.backgroundType;        // (int)    constants val of background type
    }
  }

  // New Existing
  // ------------------------------------------------------

  Sample(double[] featureVector, int label)
  {
    this.featureVector = featureVector;
    this.label = label;
  }

  // Getter / Setter
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