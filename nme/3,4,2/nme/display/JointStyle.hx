package nme.display;
#if code_completion


/**
 * The JointStyle class is an enumeration of constant values that specify the
 * joint style to use in drawing lines. These constants are provided for use
 * as values in the <code>joints</code> parameter of the
 * <code>nme.display.Graphics.lineStyle()</code> method. The method supports
 * three types of joints: miter, round, and bevel, as the following example
 * shows:
 */
@:fakeEnum(String) extern enum JointStyle {

	/**
	 * Specifies beveled joints in the <code>joints</code> parameter of the
	 * <code>nme.display.Graphics.lineStyle()</code> method.
	 */
	BEVEL;

	/**
	 * Specifies mitered joints in the <code>joints</code> parameter of the
	 * <code>nme.display.Graphics.lineStyle()</code> method.
	 */
	MITER;

	/**
	 * Specifies round joints in the <code>joints</code> parameter of the
	 * <code>nme.display.Graphics.lineStyle()</code> method.
	 */
	ROUND;
}


#elseif (cpp || neko)
typedef JointStyle = neash.display.JointStyle;
#elseif js
typedef JointStyle = jeash.display.JointStyle;
#else
typedef JointStyle = flash.display.JointStyle;
#end
