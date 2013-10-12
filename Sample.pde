class Sample {
  
  double[] featureVector;
  int label;

  ColorScheme colorscheme;
  Composition composition;

  // New Random
  // ------------------------------------------------------

  Sample()
  {
    int schemeIndex = round(random(5));
    if(schemeIndex == 0)         colorscheme = new ColorSchemeMonoChrome();
    else if(schemeIndex == 1)    colorscheme = new ColorSchemeTriadic();
    else if(schemeIndex == 2)    colorscheme = new ColorSchemeComplementary();
    else if(schemeIndex == 3)    colorscheme = new ColorSchemeTetradic();
    else if(schemeIndex == 4)    colorscheme = new ColorSchemeAnalogous();
    else if(schemeIndex == 5)    colorscheme = new ColorSchemeAccentedAnalogous();
     
    composition = new Composition();

    featureVector = {
      (double) schemeIndex,                       // (int)    index number of color scheme
      (double) colorscheme.hue,                        // (float)  0-1
      (double) colorscheme.angle,                      // (float)  0-1
      (double) colorscheme.moreColors,                 // (int)    number of colors, 0 if none
      (double) colorscheme.moreColorsType,             // (int)    sat, bri or both satbri
      (double) colorscheme.moreColorsSatLow,           // (float)  multiplier
      (double) colorscheme.moreColorsBriLow,           // (float)  multiplier
      (double) colorscheme.moreColorsSatEasing,        // (int)    index number of easing
      (double) colorscheme.moreColorsBriEasing,        // (int)    index number of easing
      (double) colorscheme.scaleSat,                   // (float)  multiplier
      (double) colorscheme.scaleBri,                   // (float)  multiplier
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