class ColorSchemeComplementary extends ColorScheme
{
	/* Define
	------------------------------------------------------------- */

	public String getName() { return "Complementary"; }
	
  public boolean hasAngleColors() { return true; }
  public boolean hasMoreColors() { return random(1) < 0.5; }
  public boolean hasVariableSaturation()  { return random(1) < 0.8; }
  public boolean hasVariableBrightness()  { return random(1) < 0.5; }
  public boolean hasFewerColors()  { return random(1) < 0.5; }

	ColorSchemeComplementary() {}

  ColorList getColors()
  {
    ColorList colors = new ColorList();

    // hue
    colors.add(TColor.newHSV(hue, 1, 1));

    // angle colors
    colors.add(TColor.newHSV( colors.get(0).hue() + 0.5, 1, 1)); // complementary

    // more colors
    addColors(colors, pickMoreColorsFromColor(colors.get(0)));
    addColors(colors, pickMoreColorsFromColor(colors.get(1)));

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

	void pickAngleColors()
	{
    angle = 0.5;
	}

	void pickMoreColors()
	{
		pickMoreColorsDisperse(2, 6);
	}
}