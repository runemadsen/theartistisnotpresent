class ColorSchemeTriadic extends ColorScheme
{
	/* Define
	------------------------------------------------------------- */

	public String getName() { return "Triadic"; };

  public boolean hasAngleColors() { return true; }
  public boolean hasMoreColors() { return random(1) < 0.5; }
  public boolean hasVariableSaturation()  { return random(1) < 0.8; }
  public boolean hasVariableBrightness()  { return random(1) < 0.5; }
  public boolean hasFewerColors()  { return random(1) < 0.5; }

	ColorSchemeTriadic() {}

	int getIndex() { return TRIADIC; }

  // Get Colors
  //----------------------------------------------------------------

	ColorList getColors()
	{
		ColorList colors = new ColorList();

		// hue
		colors.add(TColor.newHSV(hue, 1, 1));

		// angle colors
		colors.add(TColor.newHSV( colors.get(0).hue() - angle, 1, 1)); // left
		colors.add(TColor.newHSV( colors.get(0).hue() + angle, 1, 1)); // right

		// more colors
		addColors(colors, pickMoreColorsFromColor(colors.get(0)));
		addColors(colors, pickMoreColorsFromColor(colors.get(1)));
		addColors(colors, pickMoreColorsFromColor(colors.get(2)));

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
		// pick angle 90º-175º away from base hue
		angle = random(90f/360f, 175f/360f);
	}

	void pickMoreColors()
	{
		pickMoreColorsDisperse(2, 4);
	}
}