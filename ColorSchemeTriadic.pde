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

	/* Execute
	--------------------------------------------------------- */

	void pickAngleColors()
	{
		// pick angle 90º-175º away from base hue
		angle = random(90f/360f, 175f/360f);

		// find left color
		colors.add(TColor.newHSV( colors.get(0).hue() - angle, 1, 1));

		// find right color
		colors.add(TColor.newHSV( colors.get(0).hue() + angle, 1, 1));
	}

	void pickMoreColors()
	{
		pickMoreColorsDisperse(2, 4);
		pickMoreColorsFromColor(colors.get(0));
		pickMoreColorsFromColor(colors.get(1));
		pickMoreColorsFromColor(colors.get(2));
	}
}