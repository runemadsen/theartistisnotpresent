class ArtWork
{
  // Properties
  //----------------------------------------------------------------

  ColorScheme colorScheme;
  Composition composition;
  RShape art;

  // Constructor
  //----------------------------------------------------------------

  ArtWork()
  {
    ColorScheme[] schemes = {
      new ColorSchemeMonoChrome(),
      new ColorSchemeTriadic(),
      new ColorSchemeComplementary(),
      new ColorSchemeTetradic(),
      new ColorSchemeAnalogous(),
      new ColorSchemeAccentedAnalogous()
    };
  
    int schemeIndex = floor(random(schemes.length));
    colorScheme = schemes[schemeIndex];
    colorScheme.schemeType = schemeIndex;
  
    colorScheme.pickHue();
    if(colorScheme.hasAngleColors())          colorScheme.pickAngleColors();
    if(colorScheme.hasMoreColors())           colorScheme.pickMoreColors();
    if(colorScheme.hasVariableSaturation())   colorScheme.pickVariableSaturation();
    if(colorScheme.hasVariableBrightness())   colorScheme.pickVariableBrightness();
    if(colorScheme.hasFewerColors())          colorScheme.pickFewerColors();
  
    composition = new Composition();
    composition.chooseNumShapes();
    composition.chooseShapeSize();
    composition.chooseShapeType();
    composition.chooseShapeSpacing();
    composition.chooseShapeDisplacementY();
    composition.chooseShapeRotation();
    composition.choosePosition();
    composition.chooseFullShapeRotation();
    art = composition.getShape(colorScheme.colors);

    //RG.saveShape("myimage.svg", art);
  }

  // Display
  //----------------------------------------------------------------

  void display()
  {
    art.draw();
  }

  // Convert ArtWork to Sample
  //----------------------------------------------------------------
  
  Sample toSample(ColorScheme scheme, int rating)
  {
    double[] features = {
      (double) scheme.schemeType,          // (int)    index number of color scheme
      (double) scheme.hue,                 // (float)  0-1
      (double) scheme.angle,               // (float)  0-1
      (double) scheme.moreColorsSat,       // (int)    number of colors, 0 if none
      (double) scheme.moreColorsBri,       // (int)    number of colors, 0 if none
      (double) scheme.moreColorsSatLow,    // (float)  multiplier
      (double) scheme.moreColorsBriLow,    // (float)  multiplier
      (double) scheme.moreColorsSatEasing, // (int)    index number of easing
      (double) scheme.moreColorsBriEasing, // (int)    index number of easing
      (double) scheme.scaleSat,            // (float)  multiplier
      (double) scheme.scaleBri             // (float)  multiplier
      // NEED COMPOSITION HERE!!!!
    };
  
    return new Sample(features, rating);
  }
}