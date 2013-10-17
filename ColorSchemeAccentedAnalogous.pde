class ColorSchemeAccentedAnalogous extends ColorScheme
{
	public String getName() { return "Accented Analogous"; }
	public boolean hasAngleColors() { return true; }
  public boolean hasMoreColors() { return random(1) < 0.5; }
  public boolean hasVariableSaturation()  { return random(1) < 0.8; }
  public boolean hasVariableBrightness()  { return random(1) < 0.5; }
  public boolean hasFewerColors()  { return random(1) < 0.5; }

	ColorSchemeAccentedAnalogous() {}

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
		colors.add(TColor.newHSV( colors.get(0).hue() + 0.5, 1, 1));   // complementary

		// more colors
		addColors(colors, pickMoreColorsFromColor(colors.get(0)));
		addColors(colors, pickMoreColorsFromColor(colors.get(1)));

		// variable saturation
		colors = scaleSaturations(colors, scaleSat);

		// variable brightness
		colors = scaleBrightnesses(colors, scaleBri);

		// fewer colors

		return colors;
	}

	// Choose Vars
	//----------------------------------------------------------------

	void pickAngleColors()
	{
		// pick angle 5º-90º away from base hue
		angle = random(5f/360f, 90f/360f);
	}

	void pickMoreColors()
	{
		pickMoreColorsDisperse(2, 6);
	}
}