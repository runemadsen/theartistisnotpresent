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

    // color scheme
    int schemeIndex = round(random(5));
    if(schemeIndex == 0)         colorScheme = new ColorSchemeMonoChrome();
    else if(schemeIndex == 1)    colorScheme = new ColorSchemeTriadic();
    else if(schemeIndex == 2)    colorScheme = new ColorSchemeComplementary();
    else if(schemeIndex == 3)    colorScheme = new ColorSchemeTetradic();
    else if(schemeIndex == 4)    colorScheme = new ColorSchemeAnalogous();
    else if(schemeIndex == 5)    colorScheme = new ColorSchemeAccentedAnalogous();
    colorScheme.schemeType = schemeIndex;
  
    // composition
    composition = new Composition(w, h, colorScheme.colors);
    art = composition.getShape();

    // draw to canvas
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
      (double) scheme.moreColors,          // (int)    number of colors, 0 if none
      (double) scheme.moreColorsType,      // (int)    sat, bri or both satbri
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

  // Saving
  //----------------------------------------------------------------

  void saveSVG(String filename)
  {
    RG.saveShape(filename, art);

    XML xml = loadXML(filename);
    xml.setString("width", w + "px");
    xml.setString("height", h + "px");
    saveXML(xml, filename);
  }
}