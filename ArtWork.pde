class ArtWork
{
  // Properties
  //----------------------------------------------------------------

  ColorScheme colorScheme;
  Composition composition;
  RShape art;
  PGraphics canvas;
  int w;
  int h;

  // Constructor
  //----------------------------------------------------------------

  ArtWork(int _w, int _h)
  {
    w = _w;
    h = _h;
    canvas = createGraphics(w, h);

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
  
    composition = new Composition(w, h);
    composition.chooseNumShapes();
    composition.chooseShapeSize();
    composition.chooseShapeType();
    composition.chooseShapeSpacing();
    composition.chooseShapeDisplacementY();
    composition.chooseShapeRotation();
    composition.choosePosition();
    composition.chooseFullShapeRotation();
    art = composition.getShape(colorScheme.colors);

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
    // draw bounding box
    stroke(0, 0, 0.8);
    noFill();
    rect(0, 0, w, h);

    // draw art
    image(canvas, 0, 0);
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