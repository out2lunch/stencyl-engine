package nme.display;
#if code_completion


/**
 * The StageAlign class provides constant values to use for the
 * <code>Stage.align</code> property.
 */
@:fakeEnum(String) extern enum StageAlign {

	/**
	 * Specifies that the Stage is aligned at the bottom.
	 */
	BOTTOM;

	/**
	 * Specifies that the Stage is aligned on the left.
	 */
	BOTTOM_LEFT;

	/**
	 * Specifies that the Stage is aligned to the right.
	 */
	BOTTOM_RIGHT;

	/**
	 * Specifies that the Stage is aligned on the left.
	 */
	LEFT;

	/**
	 * Specifies that the Stage is aligned to the right.
	 */
	RIGHT;

	/**
	 * Specifies that the Stage is aligned at the top.
	 */
	TOP;

	/**
	 * Specifies that the Stage is aligned on the left.
	 */
	TOP_LEFT;

	/**
	 * Specifies that the Stage is aligned to the right.
	 */
	TOP_RIGHT;
}


#elseif (cpp || neko)
typedef StageAlign = neash.display.StageAlign;
#elseif js
typedef StageAlign = jeash.display.StageAlign;
#else
typedef StageAlign = flash.display.StageAlign;
#end
