package nme.filters;
#if code_completion


/**
 * The BitmapFilterQuality class contains values to set the rendering quality
 * of a BitmapFilter object.
 */
extern class BitmapFilterQuality {

	/**
	 * Defines the high quality filter setting.
	 */
	static inline var HIGH : Int = 3;

	/**
	 * Defines the low quality filter setting.
	 */
	static inline var LOW : Int = 1;

	/**
	 * Defines the medium quality filter setting.
	 */
	static inline var MEDIUM : Int = 2;
}


#elseif (cpp || neko)
typedef BitmapFilterQuality = neash.filters.BitmapFilterQuality;
#elseif js
typedef BitmapFilterQuality = jeash.filters.BitmapFilterQuality;
#else
typedef BitmapFilterQuality = flash.filters.BitmapFilterQuality;
#end
