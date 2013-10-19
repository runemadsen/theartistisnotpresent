class ColorSchemeMonoChrome extends ColorScheme
{
	/* Define
	--------------------------------------------------------- */

	public String getName() { return "Monochromatic"; };

  public boolean hasAngleColors() { return false; }
  public boolean hasMoreColors() { return true; }
  public boolean hasVariableSaturation()  { return random(1) < 0.8; }
  public boolean hasVariableBrightness()  { return random(1) < 0.5; }
  public boolean hasFewerColors()  { return random(1) < 0.5; }

	ColorSchemeMonoChrome() {}

  int getIndex() { return MONOCHROME; }

  // Get Colors
  //----------------------------------------------------------------

  ColorList getColors()
  {
    ColorList colors = new ColorList();

    // hue
    colors.add(TColor.newHSV(hue, 1, 1));

    // more colors
    addColors(colors, pickMoreColorsFromColor(colors.get(0)));

    // variable saturation
    colors = scaleSaturations(colors, scaleSat);

    // variable brightness
    colors = scaleBrightnesses(colors, scaleBri);

    // fewer colors

    // sort colors
    colors = sortColors(colors);

    return colors;
  }

	/* Execute
	--------------------------------------------------------- */

	void pickMoreColors()
	{
    pickMoreColorsDisperse(3, 10);
	}

}