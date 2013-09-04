package nme.display;
#if code_completion


/**
 * The GradientType class provides values for the <code>type</code> parameter
 * in the <code>beginGradientFill()</code> and
 * <code>lineGradientStyle()</code> methods of the nme.display.Graphics
 * class.
 */
@:fakeEnum(String) extern enum GradientType {

	/**
	 * Value used to specify a linear gradient fill.
	 */
	LINEAR;

	/**
	 * Value used to specify a radial gradient fill.
	 */
	RADIAL;
}


#elseif (cpp || neko)
typedef GradientType = neash.display.GradientType;
#elseif js
typedef GradientType = jeash.display.GradientType;
#else
typedef GradientType = flash.display.GradientType;
#end
