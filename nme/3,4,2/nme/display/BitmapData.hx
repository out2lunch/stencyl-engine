package nme.display;
#if code_completion


/**
 * The BitmapData class lets you work with the data (pixels) of a Bitmap
 * object. You can use the methods of the BitmapData class to create
 * arbitrarily sized transparent or opaque bitmap images and manipulate them
 * in various ways at runtime. You can also access the BitmapData for a bitmap
 * image that you load with the <code>nme.Assets</code> or 
 * <code>nme.display.Loader</code> classes.
 *
 * <p>This class lets you separate bitmap rendering operations from the
 * internal display updating routines of NME. By manipulating a
 * BitmapData object directly, you can create complex images without incurring
 * the per-frame overhead of constantly redrawing the content from vector
 * data.</p>
 *
 * <p>The methods of the BitmapData class support effects that are not
 * available through the filters available to non-bitmap display objects.</p>
 *
 * <p>A BitmapData object contains an array of pixel data. This data can
 * represent either a fully opaque bitmap or a transparent bitmap that
 * contains alpha channel data. Either type of BitmapData object is stored as
 * a buffer of 32-bit integers. Each 32-bit integer determines the properties
 * of a single pixel in the bitmap.</p>
 *
 * <p>Each 32-bit integer is a combination of four 8-bit channel values (from
 * 0 to 255) that describe the alpha transparency and the red, green, and blue
 * (ARGB) values of the pixel. (For ARGB values, the most significant byte
 * represents the alpha channel value, followed by red, green, and blue.)</p>
 * 
 * <p>When you are targeting the Neko runtime, the pixel data is stored as an object
 * with separate red, green, blue (RGB) and alpha (A) values. Unlike other targets, 
 * Neko uses 31-bit integers, so this necessary in order to store the full data for each 
 * pixel. You can use the <code>nme.display.BitmapInt32</class> object to represent
 * either data format.</p>
 *
 * <p>The four channels (alpha, red, green, and blue) are represented as
 * numbers when you use them with the <code>BitmapData.copyChannel()</code>
 * method or the <code>DisplacementMapFilter.componentX</code> and
 * <code>DisplacementMapFilter.componentY</code> properties, and these numbers
 * are represented by the following constants in the BitmapDataChannel
 * class:</p>
 *
 * <ul>
 *   <li><code>BitmapDataChannel.ALPHA</code></li>
 *   <li><code>BitmapDataChannel.RED</code></li>
 *   <li><code>BitmapDataChannel.GREEN</code></li>
 *   <li><code>BitmapDataChannel.BLUE</code></li>
 * </ul>
 *
 * <p>You can attach BitmapData objects to a Bitmap object by using the
 * <code>bitmapData</code> property of the Bitmap object.</p>
 *
 * <p>You can use a BitmapData object to fill a Graphics object by using the
 * <code>Graphics.beginBitmapFill()</code> method.</p>
 * 
 * <p>You can also use a BitmapData object to perform batch tile rendering
 * using the <code>nme.display.Tilesheet</code> class.</p>
 *
 * <p>In Flash Player 10, the maximum size for a BitmapData object
 * is 8,191 pixels in width or height, and the total number of pixels cannot
 * exceed 16,777,215 pixels. (So, if a BitmapData object is 8,191 pixels wide,
 * it can only be 2,048 pixels high.) In Flash Player 9 and earlier, the limitation 
 * is 2,880 pixels in height and 2,880 in width.</p>
 */
extern class BitmapData implements IBitmapDrawable {
	
	/**
	 * The height of the bitmap image in pixels.
	 */
	var height (default, null):Int;
	
	/**
	 * The rectangle that defines the size and location of the bitmap image. The
	 * top and left of the rectangle are 0; the width and height are equal to the
	 * width and height in pixels of the BitmapData object.
	 */
	var rect (default, null):nme.geom.Rectangle;
	
	/**
	 * Defines whether the bitmap image supports per-pixel transparency. You can
	 * set this value only when you construct a BitmapData object by passing in
	 * <code>true</code> for the <code>transparent</code> parameter of the
	 * constructor. Then, after you create a BitmapData object, you can check
	 * whether it supports per-pixel transparency by determining if the value of
	 * the <code>transparent</code> property is <code>true</code>.
	 */
	var transparent (default, null):Bool;
	
	/**
	 * The width of the bitmap image in pixels.
	 */
	var width (default, null):Int;
	
	/**
	 * Creates a BitmapData object with a specified width and height. If you specify a value for 
	 * the <code>fillColor</code> parameter, every pixel in the bitmap is set to that color. 
	 * 
	 * By default, the bitmap is created as transparent, unless you pass the value <code>false</code>
	 * for the transparent parameter. After you create an opaque bitmap, you cannot change it 
	 * to a transparent bitmap. Every pixel in an opaque bitmap uses only 24 bits of color channel 
	 * information. If you define the bitmap as transparent, every pixel uses 32 bits of color 
	 * channel information, including an alpha transparency channel.
	 * 
	 * @param	width		The width of the bitmap image in pixels. 
	 * @param	height		The height of the bitmap image in pixels. 
	 * @param	transparent		Specifies whether the bitmap image supports per-pixel transparency. The default value is <code>true</code> (transparent). To create a fully transparent bitmap, set the value of the <code>transparent</code> parameter to <code>true</code> and the value of the <code>fillColor</code> parameter to 0x00000000 (or to 0). Setting the <code>transparent</code> property to <code>false</code> can result in minor improvements in rendering performance.
	 * @param	fillColor		A 32-bit ARGB color value that you use to fill the bitmap image area. The default value is 0xFFFFFFFF (solid white).
	 */
	function new (width:Int, height:Int, transparent:Bool = true, fillColor:BitmapInt32 = 0xFFFFFFFF):Void;
	
	/**
	 * Takes a source image and a filter object and generates the filtered image. 
	 * 
	 * This method relies on the behavior of built-in filter objects, which determine the 
	 * destination rectangle that is affected by an input source rectangle.
	 * 
	 * After a filter is applied, the resulting image can be larger than the input image. 
	 * For example, if you use a BlurFilter class to blur a source rectangle of (50,50,100,100) 
	 * and a destination point of (10,10), the area that changes in the destination image is 
	 * larger than (10,10,60,60) because of the blurring. This happens internally during the 
	 * applyFilter() call.
	 * 
	 * If the <code>sourceRect</code> parameter of the sourceBitmapData parameter is an 
	 * interior region, such as (50,50,100,100) in a 200 x 200 image, the filter uses the source 
	 * pixels outside the <code>sourceRect</code> parameter to generate the destination rectangle.
	 * 
	 * If the BitmapData object and the object specified as the <code>sourceBitmapData</code> 
	 * parameter are the same object, the application uses a temporary copy of the object to 
	 * perform the filter. For best performance, avoid this situation.
	 * 
	 * @param	sourceBitmapData		The input bitmap image to use. The source image can be a different BitmapData object or it can refer to the current BitmapData instance.
	 * @param	sourceRect		A rectangle that defines the area of the source image to use as input.
	 * @param	destPoint		The point within the destination image (the current BitmapData instance) that corresponds to the upper-left corner of the source rectangle. 
	 * @param	filter		The filter object that you use to perform the filtering operation. 
	 */
	function applyFilter (sourceBitmapData:BitmapData, sourceRect:nme.geom.Rectangle, destPoint:nme.geom.Point, filter:nme.filters.BitmapFilter):Void;
	
	/**
	 * Returns a new BitmapData object that is a clone of the original instance with an exact copy of the contained bitmap. 
	 * @return		A new BitmapData object that is identical to the original.
	 */
	function clone ():BitmapData;
	
	/**
	 * Adjusts the color values in a specified area of a bitmap image by using a <code>ColorTransform</code>
	 * object. If the rectangle matches the boundaries of the bitmap image, this method transforms the color 
	 * values of the entire image. 
	 * @param	rect		A Rectangle object that defines the area of the image in which the ColorTransform object is applied.
	 * @param	colorTransform		A ColorTransform object that describes the color transformation values to apply.
	 */
	function colorTransform (rect:nme.geom.Rectangle, colorTransform:nme.geom.ColorTransform):Void;
	

	/**
	 * Compares two BitmapData objects. If the two BitmapData objects have the
	 * same dimensions (width and height), the method returns a new BitmapData
	 * object, in which each pixel is the "difference" between the pixels in the
	 * two source objects:
	 * <ul>
	 *   <li>If two pixels are equal, the difference pixel is 0x00000000. </li>
	 *   <li>If two pixels have different RGB values (ignoring the alpha value),
	 * the difference pixel is 0xRRGGBB where RR/GG/BB are the individual
	 * difference values between red, green, and blue channels (the pixel value
	 * in the source object minus the pixel value in the
	 * <code>otherBitmapData</code> object). Alpha channel differences are
	 * ignored in this case. </li>
	 *   <li>If only the alpha channel value is different, the pixel value is
	 * 0x<i>ZZ</i>FFFFFF, where <i>ZZ</i> is the difference in the alpha values
	 * (the alpha value in the source object minus the alpha value in the
	 * <code>otherBitmapData</code> object).</li>
	 * </ul>
	 *
	 * <p>For example, consider the following two BitmapData objects:</p>
	 * 
	 * @param otherBitmapData The BitmapData object to compare with the source
	 *                        BitmapData object.
	 * @return If the two BitmapData objects have the same dimensions (width and
	 *         height), the method returns a new BitmapData object that has the
	 *         difference between the two objects (see the main discussion). If
	 *         the BitmapData objects are equivalent, the method returns the
	 *         number 0. If the widths of the BitmapData objects are not equal,
	 *         the method returns the number -3. If the heights of the BitmapData
	 *         objects are not equal, the method returns the number -4.
	 * @throws TypeError The otherBitmapData is null.
	 */
	//function compare(otherBitmapData : BitmapData) : Dynamic;

	/**
	 * Transfers data from one channel of another BitmapData object or the
	 * current BitmapData object into a channel of the current BitmapData object.
	 * All of the data in the other channels in the destination BitmapData object
	 * are preserved.
	 *
	 * <p>The source channel value and destination channel value can be one of
	 * following values: </p>
	 *
	 * <ul>
	 *   <li><code>BitmapDataChannel.RED</code></li>
	 *   <li><code>BitmapDataChannel.GREEN</code></li>
	 *   <li><code>BitmapDataChannel.BLUE</code></li>
	 *   <li><code>BitmapDataChannel.ALPHA</code></li>
	 * </ul>
	 * 
	 * @param sourceBitmapData The input bitmap image to use. The source image
	 *                         can be a different BitmapData object or it can
	 *                         refer to the current BitmapData object.
	 * @param sourceRect       The source Rectangle object. To copy only channel
	 *                         data from a smaller area within the bitmap,
	 *                         specify a source rectangle that is smaller than
	 *                         the overall size of the BitmapData object.
	 * @param destPoint        The destination Point object that represents the
	 *                         upper-left corner of the rectangular area where
	 *                         the new channel data is placed. To copy only
	 *                         channel data from one area to a different area in
	 *                         the destination image, specify a point other than
	 *                         (0,0).
	 * @param sourceChannel    The source channel. Use a value from the
	 *                         BitmapDataChannel class
	 *                         (<code>BitmapDataChannel.RED</code>,
	 *                         <code>BitmapDataChannel.BLUE</code>,
	 *                         <code>BitmapDataChannel.GREEN</code>,
	 *                         <code>BitmapDataChannel.ALPHA</code>).
	 * @param destChannel      The destination channel. Use a value from the
	 *                         BitmapDataChannel class
	 *                         (<code>BitmapDataChannel.RED</code>,
	 *                         <code>BitmapDataChannel.BLUE</code>,
	 *                         <code>BitmapDataChannel.GREEN</code>,
	 *                         <code>BitmapDataChannel.ALPHA</code>).
	 * @throws TypeError The sourceBitmapData, sourceRect or destPoint are null.
	 */
	function copyChannel(sourceBitmapData : BitmapData, sourceRect : nme.geom.Rectangle, destPoint : nme.geom.Point, sourceChannel : Int, destChannel : Int) : Void;

	/**
	 * Provides a fast routine to perform pixel manipulation between images with
	 * no stretching, rotation, or color effects. This method copies a
	 * rectangular area of a source image to a rectangular area of the same size
	 * at the destination point of the destination BitmapData object.
	 *
	 * <p>If you include the <code>alphaBitmap</code> and <code>alphaPoint</code>
	 * parameters, you can use a secondary image as an alpha source for the
	 * source image. If the source image has alpha data, both sets of alpha data
	 * are used to composite pixels from the source image to the destination
	 * image. The <code>alphaPoint</code> parameter is the point in the alpha
	 * image that corresponds to the upper-left corner of the source rectangle.
	 * Any pixels outside the intersection of the source image and alpha image
	 * are not copied to the destination image.</p>
	 *
	 * <p>The <code>mergeAlpha</code> property controls whether or not the alpha
	 * channel is used when a transparent image is copied onto another
	 * transparent image. To copy pixels with the alpha channel data, set the
	 * <code>mergeAlpha</code> property to <code>true</code>. By default, the
	 * <code>mergeAlpha</code> property is <code>false</code>.</p>
	 * 
	 * @param sourceBitmapData The input bitmap image from which to copy pixels.
	 *                         The source image can be a different BitmapData
	 *                         instance, or it can refer to the current
	 *                         BitmapData instance.
	 * @param sourceRect       A rectangle that defines the area of the source
	 *                         image to use as input.
	 * @param destPoint        The destination point that represents the
	 *                         upper-left corner of the rectangular area where
	 *                         the new pixels are placed.
	 * @param alphaBitmapData  A secondary, alpha BitmapData object source.
	 * @param alphaPoint       The point in the alpha BitmapData object source
	 *                         that corresponds to the upper-left corner of the
	 *                         <code>sourceRect</code> parameter.
	 * @param mergeAlpha       To use the alpha channel, set the value to
	 *                         <code>true</code>. To copy pixels with no alpha
	 *                         channel, set the value to <code>false</code>.
	 * @throws TypeError The sourceBitmapData, sourceRect, destPoint are null.
	 */
	function copyPixels(sourceBitmapData : BitmapData, sourceRect : nme.geom.Rectangle, destPoint : nme.geom.Point, ?alphaBitmapData : BitmapData, ?alphaPoint : nme.geom.Point, mergeAlpha : Bool = false) : Void;

	/**
	 * Frees memory that is used to store the BitmapData object.
	 *
	 * <p>When the <code>dispose()</code> method is called on an image, the width
	 * and height of the image are set to 0. All subsequent calls to methods or
	 * properties of this BitmapData instance fail, and an exception is thrown.
	 * </p>
	 *
	 * <p><code>BitmapData.dispose()</code> releases the memory occupied by the
	 * actual bitmap data, immediately (a bitmap can consume up to 64 MB of
	 * memory). After using <code>BitmapData.dispose()</code>, the BitmapData
	 * object is no longer usable and an exception may be thrown if
	 * you call functions on the BitmapData object. However,
	 * <code>BitmapData.dispose()</code> does not garbage collect the BitmapData
	 * object (approximately 128 bytes); the memory occupied by the actual
	 * BitmapData object is released at the time the BitmapData object is
	 * collected by the garbage collector.</p>
	 * 
	 */
	function dispose() : Void;

	/**
	 * Draws the <code>source</code> display object onto the bitmap image, using
	 * the NME software renderer. You can specify <code>matrix</code>,
	 * <code>colorTransform</code>, <code>blendMode</code>, and a destination
	 * <code>clipRect</code> parameter to control how the rendering performs.
	 * Optionally, you can specify whether the bitmap should be smoothed when
	 * scaled (this works only if the source object is a BitmapData object).
	 *
	 * <p>The source display object does not use any of its applied
	 * transformations for this call. It is treated as it exists in the library
	 * or file, with no matrix transform, no color transform, and no blend mode.
	 * To draw a display object (such as a movie clip) by using its own transform
	 * properties, you can copy its <code>transform</code> property object to the
	 * <code>transform</code> property of the Bitmap object that uses the
	 * BitmapData object.</p>
	 * 
	 * @param source         The display object or BitmapData object to draw to
	 *                       the BitmapData object. (The DisplayObject and
	 *                       BitmapData classes implement the IBitmapDrawable
	 *                       interface.)
	 * @param matrix         A Matrix object used to scale, rotate, or translate
	 *                       the coordinates of the bitmap. If you do not want to
	 *                       apply a matrix transformation to the image, set this
	 *                       parameter to an identity matrix, created with the
	 *                       default <code>new Matrix()</code> constructor, or
	 *                       pass a <code>null</code> value.
	 * @param colorTransform A ColorTransform object that you use to adjust the
	 *                       color values of the bitmap. If no object is
	 *                       supplied, the bitmap image's colors are not
	 *                       transformed. If you must pass this parameter but you
	 *                       do not want to transform the image, set this
	 *                       parameter to a ColorTransform object created with
	 *                       the default <code>new ColorTransform()</code>
	 *                       constructor.
	 * @param blendMode      A string value, from the nme.display.BlendMode
	 *                       class, specifying the blend mode to be applied to
	 *                       the resulting bitmap.
	 * @param clipRect       A Rectangle object that defines the area of the
	 *                       source object to draw. If you do not supply this
	 *                       value, no clipping occurs and the entire source
	 *                       object is drawn.
	 * @param smoothing      A Boolean value that determines whether a BitmapData
	 *                       object is smoothed when scaled or rotated, due to a
	 *                       scaling or rotation in the <code>matrix</code>
	 *                       parameter. The <code>smoothing</code> parameter only
	 *                       applies if the <code>source</code> parameter is a
	 *                       BitmapData object. With <code>smoothing</code> set
	 *                       to <code>false</code>, the rotated or scaled
	 *                       BitmapData image can appear pixelated or jagged. For
	 *                       example, the following two images use the same
	 *                       BitmapData object for the <code>source</code>
	 *                       parameter, but the <code>smoothing</code> parameter
	 *                       is set to <code>true</code> on the left and
	 *                       <code>false</code> on the right:
	 *
	 *                       <p>Drawing a bitmap with <code>smoothing</code> set
	 *                       to <code>true</code> takes longer than doing so with
	 *                       <code>smoothing</code> set to
	 *                       <code>false</code>.</p>
	 * @throws ArgumentError The <code>source</code> parameter is not a
	 *                       BitmapData or DisplayObject object.
	 * @throws ArgumentError The source is null or not a valid IBitmapDrawable
	 *                       object.
	 * @throws SecurityError The <code>source</code> object and (in the case of a
	 *                       Sprite or MovieClip object) all of its child objects
	 *                       do not come from the same domain as the caller, or
	 *                       are not in a content that is accessible to the
	 *                       caller by having called the
	 *                       <code>Security.allowDomain()</code> method. This
	 *                       restriction does not apply to AIR content in the
	 *                       application security sandbox.
	 */
	function draw(source : IBitmapDrawable, ?matrix : nme.geom.Matrix, ?colorTransform : nme.geom.ColorTransform, ?blendMode : BlendMode, ?clipRect : nme.geom.Rectangle, smoothing : Bool = false) : Void;
	
	/**
	 * Encodes the current image as a JPG or PNG format ByteArray.
	 * 
	 * This method is not available to the HTML5 and Flash targets.
	 * 
	 * @param format  The encoding format, either "png" or "jpg".
	 * @param quality The encoding quality, when encoding with the JPG format.
	 * @return  A ByteArray in the specified encoding format
	 */
	function encode(format : String, quality : Float = 0.9) : nme.utils.ByteArray;
	
	/**
	 * Fills a rectangular area of pixels with a specified ARGB color.
	 * 
	 * @param rect  The rectangular area to fill.
	 * @param color The ARGB color value that fills the area. ARGB colors are
	 *              often specified in hexadecimal format; for example,
	 *              0xFF336699.
	 * @throws TypeError The rect is null.
	 */
	function fillRect(rect : nme.geom.Rectangle, color : Int) : Void;

	/**
	 * Performs a flood fill operation on an image starting at an (<i>x</i>,
	 * <i>y</i>) coordinate and filling with a certain color. The
	 * <code>floodFill()</code> method is similar to the paint bucket tool in
	 * various paint programs. The color is an ARGB color that contains alpha
	 * information and color information.
	 * 
	 * @param x     The <i>x</i> coordinate of the image.
	 * @param y     The <i>y</i> coordinate of the image.
	 * @param color The ARGB color to use as a fill.
	 */
	//function floodFill(x : Int, y : Int, color : Int) : Void;

	/**
	 * Determines the destination rectangle that the <code>applyFilter()</code>
	 * method call affects, given a BitmapData object, a source rectangle, and a
	 * filter object.
	 *
	 * <p>For example, a blur filter normally affects an area larger than the
	 * size of the original image. A 100 x 200 pixel image that is being filtered
	 * by a default BlurFilter instance, where <code>blurX = blurY = 4</code>
	 * generates a destination rectangle of <code>(-2,-2,104,204)</code>. The
	 * <code>generateFilterRect()</code> method lets you find out the size of
	 * this destination rectangle in advance so that you can size the destination
	 * image appropriately before you perform a filter operation.</p>
	 *
	 * <p>Some filters clip their destination rectangle based on the source image
	 * size. For example, an inner <code>DropShadow</code> does not generate a
	 * larger result than its source image. In this API, the BitmapData object is
	 * used as the source bounds and not the source <code>rect</code>
	 * parameter.</p>
	 * 
	 * @param sourceRect A rectangle defining the area of the source image to use
	 *                   as input.
	 * @param filter     A filter object that you use to calculate the
	 *                   destination rectangle.
	 * @return A destination rectangle computed by using an image, the
	 *         <code>sourceRect</code> parameter, and a filter.
	 * @throws TypeError The sourceRect or filter are null.
	 */
	function generateFilterRect(sourceRect : nme.geom.Rectangle, filter : nme.filters.BitmapFilter) : nme.geom.Rectangle;

	/**
	 * Determines a rectangular region that either fully encloses all pixels of a
	 * specified color within the bitmap image (if the <code>findColor</code>
	 * parameter is set to <code>true</code>) or fully encloses all pixels that
	 * do not include the specified color (if the <code>findColor</code>
	 * parameter is set to <code>false</code>).
	 *
	 * <p>For example, if you have a source image and you want to determine the
	 * rectangle of the image that contains a nonzero alpha channel, pass
	 * <code>{mask: 0xFF000000, color: 0x00000000}</code> as parameters. If the
	 * <code>findColor</code> parameter is set to <code>true</code>, the entire
	 * image is searched for the bounds of pixels for which <code>(value & mask)
	 * == color</code> (where <code>value</code> is the color value of the
	 * pixel). If the <code>findColor</code> parameter is set to
	 * <code>false</code>, the entire image is searched for the bounds of pixels
	 * for which <code>(value & mask) != color</code> (where <code>value</code>
	 * is the color value of the pixel). To determine white space around an
	 * image, pass <code>{mask: 0xFFFFFFFF, color: 0xFFFFFFFF}</code> to find the
	 * bounds of nonwhite pixels.</p>
	 * 
	 * @param mask      A hexadecimal value, specifying the bits of the ARGB
	 *                  color to consider. The color value is combined with this
	 *                  hexadecimal value, by using the <code>&</code> (bitwise
	 *                  AND) operator.
	 * @param color     A hexadecimal value, specifying the ARGB color to match
	 *                  (if <code>findColor</code> is set to <code>true</code>)
	 *                  or <i>not</i> to match (if <code>findColor</code> is set
	 *                  to <code>false</code>).
	 * @param findColor If the value is set to <code>true</code>, returns the
	 *                  bounds of a color value in an image. If the value is set
	 *                  to <code>false</code>, returns the bounds of where this
	 *                  color doesn't exist in an image.
	 * @return The region of the image that is the specified color.
	 */
	function getColorBoundsRect(mask : Int, color : Int, findColor : Bool = true) : nme.geom.Rectangle;

	/**
	 * Returns an integer that represents an RGB pixel value from a BitmapData
	 * object at a specific point (<i>x</i>, <i>y</i>). The
	 * <code>getPixel()</code> method returns an unmultiplied pixel value. No
	 * alpha information is returned.
	 *
	 * <p>All pixels in a BitmapData object are stored as premultiplied color
	 * values. A premultiplied image pixel has the red, green, and blue color
	 * channel values already multiplied by the alpha data. For example, if the
	 * alpha value is 0, the values for the RGB channels are also 0, independent
	 * of their unmultiplied values. This loss of data can cause some problems
	 * when you perform operations. All BitmapData methods take and return
	 * unmultiplied values. The internal pixel representation is converted from
	 * premultiplied to unmultiplied before it is returned as a value. During a
	 * set operation, the pixel value is premultiplied before the raw image pixel
	 * is set.</p>
	 * 
	 * @param x The <i>x</i> position of the pixel.
	 * @param y The <i>y</i> position of the pixel.
	 * @return A number that represents an RGB pixel value. If the (<i>x</i>,
	 *         <i>y</i>) coordinates are outside the bounds of the image, the
	 *         method returns 0.
	 */
	function getPixel(x : Int, y : Int) : Int;

	/**
	 * Returns an ARGB color value that contains alpha channel data and RGB data.
	 * This method is similar to the <code>getPixel()</code> method, which
	 * returns an RGB color without alpha channel data.
	 *
	 * <p>All pixels in a BitmapData object are stored as premultiplied color
	 * values. A premultiplied image pixel has the red, green, and blue color
	 * channel values already multiplied by the alpha data. For example, if the
	 * alpha value is 0, the values for the RGB channels are also 0, independent
	 * of their unmultiplied values. This loss of data can cause some problems
	 * when you perform operations. All BitmapData methods take and return
	 * unmultiplied values. The internal pixel representation is converted from
	 * premultiplied to unmultiplied before it is returned as a value. During a
	 * set operation, the pixel value is premultiplied before the raw image pixel
	 * is set.</p>
	 * 
	 * @param x The <i>x</i> position of the pixel.
	 * @param y The <i>y</i> position of the pixel.
	 * @return A number representing an ARGB pixel value. If the (<i>x</i>,
	 *         <i>y</i>) coordinates are outside the bounds of the image, 0 is
	 *         returned.
	 */
	function getPixel32(x : Int, y : Int) : Int;

	/**
	 * Generates a byte array from a rectangular region of pixel data. Writes an
	 * unsigned integer (a 32-bit unmultiplied pixel value) for each pixel into
	 * the byte array.
	 * 
	 * @param rect A rectangular area in the current BitmapData object.
	 * @return A ByteArray representing the pixels in the given Rectangle.
	 * @throws TypeError The rect is null.
	 */
	function getPixels(rect : nme.geom.Rectangle) : nme.utils.ByteArray;

	/**
	 * Generates a vector array from a rectangular region of pixel data. Returns
	 * a Vector object of unsigned integers (a 32-bit unmultiplied pixel value)
	 * for the specified rectangle.
	 * 
	 * @param rect A rectangular area in the current BitmapData object.
	 * @return A Vector representing the given Rectangle.
	 * @throws TypeError The rect is null.
	 */
	function getVector(rect : nme.geom.Rectangle) : nme.Vector<Int>;

	/**
	 * Computes a 256-value binary number histogram of a BitmapData object. This
	 * method returns a Vector object containing four Vector.<Number> instances
	 * (four Vector objects that contain Number objects). The four Vector
	 * instances represent the red, green, blue and alpha components in order.
	 * Each Vector instance contains 256 values that represent the population
	 * count of an individual component value, from 0 to 255.
	 * 
	 * @param hRect The area of the BitmapData object to use.
	 */
	//@:require(flash10) function histogram(?hRect : nme.geom.Rectangle) : nme.Vector<nme.Vector<Float>>;

	/**
	 * Performs pixel-level hit detection between one bitmap image and a point,
	 * rectangle, or other bitmap image. A hit is defined as an overlap of a
	 * point or rectangle over an opaque pixel, or two overlapping opaque pixels.
	 * No stretching, rotation, or other transformation of either object is
	 * considered when the hit test is performed.
	 *
	 * <p>If an image is an opaque image, it is considered a fully opaque
	 * rectangle for this method. Both images must be transparent images to
	 * perform pixel-level hit testing that considers transparency. When you are
	 * testing two transparent images, the alpha threshold parameters control
	 * what alpha channel values, from 0 to 255, are considered opaque.</p>
	 * 
	 * @param firstPoint            A position of the upper-left corner of the
	 *                              BitmapData image in an arbitrary coordinate
	 *                              space. The same coordinate space is used in
	 *                              defining the <code>secondBitmapPoint</code>
	 *                              parameter.
	 * @param firstAlphaThreshold   The smallest alpha channel value that is
	 *                              considered opaque for this hit test.
	 * @param secondObject          A Rectangle, Point, Bitmap, or BitmapData
	 *                              object.
	 * @param secondBitmapDataPoint A point that defines a pixel location in the
	 *                              second BitmapData object. Use this parameter
	 *                              only when the value of
	 *                              <code>secondObject</code> is a BitmapData
	 *                              object.
	 * @param secondAlphaThreshold  The smallest alpha channel value that is
	 *                              considered opaque in the second BitmapData
	 *                              object. Use this parameter only when the
	 *                              value of <code>secondObject</code> is a
	 *                              BitmapData object and both BitmapData objects
	 *                              are transparent.
	 * @return A value of <code>true</code> if a hit occurs; otherwise,
	 *         <code>false</code>.
	 * @throws ArgumentError The <code>secondObject</code> parameter is not a
	 *                       Point, Rectangle, Bitmap, or BitmapData object.
	 * @throws TypeError     The firstPoint is null.
	 */
	//function hitTest(firstPoint : nme.geom.Point, firstAlphaThreshold : Int, secondObject : Dynamic, ?secondBitmapDataPoint : nme.geom.Point, secondAlphaThreshold : Int = 1) : Bool;

	/**
	 * Locks an image so that any objects that reference the BitmapData object,
	 * such as Bitmap objects, are not updated when this BitmapData object
	 * changes. To improve performance, use this method along with the
	 * <code>unlock()</code> method before and after numerous calls to the
	 * <code>setPixel()</code> or <code>setPixel32()</code> method.
	 * 
	 */
	function lock() : Void;

	/**
	 * Performs per-channel blending from a source image to a destination image.
	 * For each channel and each pixel, a new value is computed based on the
	 * channel values of the source and destination pixels. For example, in the
	 * red channel, the new value is computed as follows (where
	 * <code>redSrc</code> is the red channel value for a pixel in the source
	 * image and <code>redDest</code> is the red channel value at the
	 * corresponding pixel of the destination image):
	 *
	 * <p> <code> new redDest = [(redSrc * redMultiplier) + (redDest * (256 -
	 * redMultiplier))] / 256; </code> </p>
	 *
	 * <p>The <code>redMultiplier</code>, <code>greenMultiplier</code>,
	 * <code>blueMultiplier</code>, and <code>alphaMultiplier</code> values are
	 * the multipliers used for each color channel. Use a hexadecimal value
	 * ranging from <code>0</code> to <code>0x100</code> (256) where
	 * <code>0</code> specifies the full value from the destination is used in
	 * the result, <code>0x100</code> specifies the full value from the source is
	 * used, and numbers in between specify a blend is used (such as
	 * <code>0x80</code> for 50%).</p>
	 * 
	 * @param sourceBitmapData The input bitmap image to use. The source image
	 *                         can be a different BitmapData object, or it can
	 *                         refer to the current BitmapData object.
	 * @param sourceRect       A rectangle that defines the area of the source
	 *                         image to use as input.
	 * @param destPoint        The point within the destination image (the
	 *                         current BitmapData instance) that corresponds to
	 *                         the upper-left corner of the source rectangle.
	 * @param redMultiplier    A hexadecimal uint value by which to multiply the
	 *                         red channel value.
	 * @param greenMultiplier  A hexadecimal uint value by which to multiply the
	 *                         green channel value.
	 * @param blueMultiplier   A hexadecimal uint value by which to multiply the
	 *                         blue channel value.
	 * @param alphaMultiplier  A hexadecimal uint value by which to multiply the
	 *                         alpha transparency value.
	 * @throws TypeError The sourceBitmapData, sourceRect or destPoint are null.
	 */
	//function merge(sourceBitmapData : BitmapData, sourceRect : nme.geom.Rectangle, destPoint : nme.geom.Point, redMultiplier : Int, greenMultiplier : Int, blueMultiplier : Int, alphaMultiplier : Int) : Void;

	/**
	 * Fills an image with pixels representing random noise.
	 * 
	 * @param randomSeed     The random seed number to use. If you keep all other
	 *                       parameters the same, you can generate different
	 *                       pseudo-random results by varying the random seed
	 *                       value. The noise function is a mapping function, not
	 *                       a true random-number generation function, so it
	 *                       creates the same results each time from the same
	 *                       random seed.
	 * @param low            The lowest value to generate for each channel (0 to
	 *                       255).
	 * @param high           The highest value to generate for each channel (0 to
	 *                       255).
	 * @param channelOptions A number that can be a combination of any of the
	 *                       four color channel values
	 *                       (<code>BitmapDataChannel.RED</code>,
	 *                       <code>BitmapDataChannel.BLUE</code>,
	 *                       <code>BitmapDataChannel.GREEN</code>, and
	 *                       <code>BitmapDataChannel.ALPHA</code>). You can use
	 *                       the logical OR operator (<code>|</code>) to combine
	 *                       channel values.
	 * @param grayScale      A Boolean value. If the value is <code>true</code>,
	 *                       a grayscale image is created by setting all of the
	 *                       color channels to the same value. The alpha channel
	 *                       selection is not affected by setting this parameter
	 *                       to <code>true</code>.
	 */
	function noise(randomSeed : Int, low : Int = 0, high : Int = 255, channelOptions : Int = 7, grayScale : Bool = false) : Void;

	/**
	 * Remaps the color channel values in an image that has up to four arrays of
	 * color palette data, one for each channel.
	 *
	 * <p>Flash runtimes use the following steps to generate the resulting
	 * image:</p>
	 *
	 * <ol>
	 *   <li>After the red, green, blue, and alpha values are computed, they are
	 * added together using standard 32-bit-integer arithmetic. </li>
	 *   <li>The red, green, blue, and alpha channel values of each pixel are
	 * extracted into separate 0 to 255 values. These values are used to look up
	 * new color values in the appropriate array: <code>redArray</code>,
	 * <code>greenArray</code>, <code>blueArray</code>, and
	 * <code>alphaArray</code>. Each of these four arrays should contain 256
	 * values. </li>
	 *   <li>After all four of the new channel values are retrieved, they are
	 * combined into a standard ARGB value that is applied to the pixel.</li>
	 * </ol>
	 *
	 * <p>Cross-channel effects can be supported with this method. Each input
	 * array can contain full 32-bit values, and no shifting occurs when the
	 * values are added together. This routine does not support per-channel
	 * clamping. </p>
	 *
	 * <p>If no array is specified for a channel, the color channel is copied
	 * from the source image to the destination image.</p>
	 *
	 * <p>You can use this method for a variety of effects such as general
	 * palette mapping (taking one channel and converting it to a false color
	 * image). You can also use this method for a variety of advanced color
	 * manipulation algorithms, such as gamma, curves, levels, and
	 * quantizing.</p>
	 * 
	 * @param sourceBitmapData The input bitmap image to use. The source image
	 *                         can be a different BitmapData object, or it can
	 *                         refer to the current BitmapData instance.
	 * @param sourceRect       A rectangle that defines the area of the source
	 *                         image to use as input.
	 * @param destPoint        The point within the destination image (the
	 *                         current BitmapData object) that corresponds to the
	 *                         upper-left corner of the source rectangle.
	 * @throws TypeError The sourceBitmapData, sourceRect or destPoint are null.
	 */
	//function paletteMap(sourceBitmapData : BitmapData, sourceRect : nme.geom.Rectangle, destPoint : nme.geom.Point, ?redArray : Array<Int>, ?greenArray : Array<Int>, ?blueArray : Array<Int>, ?alphaArray : Array<Int>) : Void;

	/**
	 * Generates a Perlin noise image.
	 *
	 * <p>The Perlin noise generation algorithm interpolates and combines
	 * individual random noise functions (called octaves) into a single function
	 * that generates more natural-seeming random noise. Like musical octaves,
	 * each octave function is twice the frequency of the one before it. Perlin
	 * noise has been described as a "fractal sum of noise" because it combines
	 * multiple sets of noise data with different levels of detail.</p>
	 *
	 * <p>You can use Perlin noise functions to simulate natural phenomena and
	 * landscapes, such as wood grain, clouds, and mountain ranges. In most
	 * cases, the output of a Perlin noise function is not displayed directly but
	 * is used to enhance other images and give them pseudo-random
	 * variations.</p>
	 *
	 * <p>Simple digital random noise functions often produce images with harsh,
	 * contrasting points. This kind of harsh contrast is not often found in
	 * nature. The Perlin noise algorithm blends multiple noise functions that
	 * operate at different levels of detail. This algorithm results in smaller
	 * variations among neighboring pixel values.</p>
	 * 
	 * @param baseX          Frequency to use in the <i>x</i> direction. For
	 *                       example, to generate a noise that is sized for a 64
	 *                       x 128 image, pass 64 for the <code>baseX</code>
	 *                       value.
	 * @param baseY          Frequency to use in the <i>y</i> direction. For
	 *                       example, to generate a noise that is sized for a 64
	 *                       x 128 image, pass 128 for the <code>baseY</code>
	 *                       value.
	 * @param numOctaves     Number of octaves or individual noise functions to
	 *                       combine to create this noise. Larger numbers of
	 *                       octaves create images with greater detail. Larger
	 *                       numbers of octaves also require more processing
	 *                       time.
	 * @param randomSeed     The random seed number to use. If you keep all other
	 *                       parameters the same, you can generate different
	 *                       pseudo-random results by varying the random seed
	 *                       value. The Perlin noise function is a mapping
	 *                       function, not a true random-number generation
	 *                       function, so it creates the same results each time
	 *                       from the same random seed.
	 * @param stitch         A Boolean value. If the value is <code>true</code>,
	 *                       the method attempts to smooth the transition edges
	 *                       of the image to create seamless textures for tiling
	 *                       as a bitmap fill.
	 * @param fractalNoise   A Boolean value. If the value is <code>true</code>,
	 *                       the method generates fractal noise; otherwise, it
	 *                       generates turbulence. An image with turbulence has
	 *                       visible discontinuities in the gradient that can
	 *                       make it better approximate sharper visual effects
	 *                       like flames and ocean waves.
	 * @param channelOptions A number that can be a combination of any of the
	 *                       four color channel values
	 *                       (<code>BitmapDataChannel.RED</code>,
	 *                       <code>BitmapDataChannel.BLUE</code>,
	 *                       <code>BitmapDataChannel.GREEN</code>, and
	 *                       <code>BitmapDataChannel.ALPHA</code>). You can use
	 *                       the logical OR operator (<code>|</code>) to combine
	 *                       channel values.
	 * @param grayScale      A Boolean value. If the value is <code>true</code>,
	 *                       a grayscale image is created by setting each of the
	 *                       red, green, and blue color channels to identical
	 *                       values. The alpha channel value is not affected if
	 *                       this value is set to <code>true</code>.
	 */
	//function perlinNoise(baseX : Float, baseY : Float, numOctaves : Int, randomSeed : Int, stitch : Bool, fractalNoise : Bool, channelOptions : Int = 7, grayScale : Bool = false, ?offsets : Array<nme.geom.Point>) : Void;

	/**
	 * Performs a pixel dissolve either from a source image to a destination
	 * image or by using the same image. Flash runtimes use a
	 * <code>randomSeed</code> value to generate a random pixel dissolve. The
	 * return value of the function must be passed in on subsequent calls to
	 * continue the pixel dissolve until it is finished.
	 *
	 * <p>If the source image does not equal the destination image, pixels are
	 * copied from the source to the destination by using all of the properties.
	 * This process allows dissolving from a blank image into a fully populated
	 * image.</p>
	 *
	 * <p>If the source and destination images are equal, pixels are filled with
	 * the <code>color</code> parameter. This process allows dissolving away from
	 * a fully populated image. In this mode, the destination <code>point</code>
	 * parameter is ignored.</p>
	 * 
	 * @param sourceBitmapData The input bitmap image to use. The source image
	 *                         can be a different BitmapData object, or it can
	 *                         refer to the current BitmapData instance.
	 * @param sourceRect       A rectangle that defines the area of the source
	 *                         image to use as input.
	 * @param destPoint        The point within the destination image (the
	 *                         current BitmapData instance) that corresponds to
	 *                         the upper-left corner of the source rectangle.
	 * @param randomSeed       The random seed to use to start the pixel
	 *                         dissolve.
	 * @param numPixels        The default is 1/30 of the source area (width x
	 *                         height).
	 * @param fillColor        An ARGB color value that you use to fill pixels
	 *                         whose source value equals its destination value.
	 * @return The new random seed value to use for subsequent calls.
	 * @throws TypeError The sourceBitmapData, sourceRect or destPoint are null.
	 * @throws TypeError The numPixels value is negative
	 */
	//function pixelDissolve(sourceBitmapData : BitmapData, sourceRect : nme.geom.Rectangle, destPoint : nme.geom.Point, randomSeed : Int = 0, numPixels : Int = 0, fillColor : Int = 0) : Int;

	/**
	 * Scrolls an image by a certain (<i>x</i>, <i>y</i>) pixel amount. Edge
	 * regions outside the scrolling area are left unchanged.
	 * 
	 * @param x The amount by which to scroll horizontally.
	 * @param y The amount by which to scroll vertically.
	 */
	function scroll(x : Int, y : Int) : Void;

	/**
	 * Sets a single pixel of a BitmapData object. The current alpha channel
	 * value of the image pixel is preserved during this operation. The value of
	 * the RGB color parameter is treated as an unmultiplied color value.
	 *
	 * <p><b>Note:</b> To increase performance, when you use the
	 * <code>setPixel()</code> or <code>setPixel32()</code> method repeatedly,
	 * call the <code>lock()</code> method before you call the
	 * <code>setPixel()</code> or <code>setPixel32()</code> method, and then call
	 * the <code>unlock()</code> method when you have made all pixel changes.
	 * This process prevents objects that reference this BitmapData instance from
	 * updating until you finish making the pixel changes.</p>
	 * 
	 * @param x     The <i>x</i> position of the pixel whose value changes.
	 * @param y     The <i>y</i> position of the pixel whose value changes.
	 * @param color The resulting RGB color for the pixel.
	 */
	function setPixel(x : Int, y : Int, color : Int) : Void;

	/**
	 * Sets the color and alpha transparency values of a single pixel of a
	 * BitmapData object. This method is similar to the <code>setPixel()</code>
	 * method; the main difference is that the <code>setPixel32()</code> method
	 * takes an ARGB color value that contains alpha channel information.
	 *
	 * <p>All pixels in a BitmapData object are stored as premultiplied color
	 * values. A premultiplied image pixel has the red, green, and blue color
	 * channel values already multiplied by the alpha data. For example, if the
	 * alpha value is 0, the values for the RGB channels are also 0, independent
	 * of their unmultiplied values. This loss of data can cause some problems
	 * when you perform operations. All BitmapData methods take and return
	 * unmultiplied values. The internal pixel representation is converted from
	 * premultiplied to unmultiplied before it is returned as a value. During a
	 * set operation, the pixel value is premultiplied before the raw image pixel
	 * is set.</p>
	 *
	 * <p><b>Note:</b> To increase performance, when you use the
	 * <code>setPixel()</code> or <code>setPixel32()</code> method repeatedly,
	 * call the <code>lock()</code> method before you call the
	 * <code>setPixel()</code> or <code>setPixel32()</code> method, and then call
	 * the <code>unlock()</code> method when you have made all pixel changes.
	 * This process prevents objects that reference this BitmapData instance from
	 * updating until you finish making the pixel changes.</p>
	 * 
	 * @param x     The <i>x</i> position of the pixel whose value changes.
	 * @param y     The <i>y</i> position of the pixel whose value changes.
	 * @param color The resulting ARGB color for the pixel. If the bitmap is
	 *              opaque (not transparent), the alpha transparency portion of
	 *              this color value is ignored.
	 */
	function setPixel32(x : Int, y : Int, color : Int) : Void;

	/**
	 * Converts a byte array into a rectangular region of pixel data. For each
	 * pixel, the <code>ByteArray.readUnsignedInt()</code> method is called and
	 * the return value is written into the pixel. If the byte array ends before
	 * the full rectangle is written, the function returns. The data in the byte
	 * array is expected to be 32-bit ARGB pixel values. No seeking is performed
	 * on the byte array before or after the pixels are read.
	 * 
	 * @param rect           Specifies the rectangular region of the BitmapData
	 *                       object.
	 * @param inputByteArray A ByteArray object that consists of 32-bit
	 *                       unmultiplied pixel values to be used in the
	 *                       rectangular region.
	 * @throws EOFError  The <code>inputByteArray</code> object does not include
	 *                   enough data to fill the area of the <code>rect</code>
	 *                   rectangle. The method fills as many pixels as possible
	 *                   before throwing the exception.
	 * @throws TypeError The rect or inputByteArray are null.
	 */
	function setPixels(rect : nme.geom.Rectangle, inputByteArray : nme.utils.ByteArray) : Void;

	/**
	 * Converts a Vector into a rectangular region of pixel data. For each pixel,
	 * a Vector element is read and written into the BitmapData pixel. The data
	 * in the Vector is expected to be 32-bit ARGB pixel values.
	 * 
	 * @param rect Specifies the rectangular region of the BitmapData object.
	 * @throws RangeError The vector array is not large enough to read all the
	 *                    pixel data.
	 */
	function setVector(rect : nme.geom.Rectangle, inputVector : nme.Vector<Int>) : Void;

	/**
	 * Tests pixel values in an image against a specified threshold and sets
	 * pixels that pass the test to new color values. Using the
	 * <code>threshold()</code> method, you can isolate and replace color ranges
	 * in an image and perform other logical operations on image pixels.
	 *
	 * <p>The <code>threshold()</code> method's test logic is as follows:</p>
	 *
	 * <ol>
	 *   <li>If <code>((pixelValue & mask) operation (threshold & mask))</code>,
	 * then set the pixel to <code>color</code>;</li>
	 *   <li>Otherwise, if <code>copySource == true</code>, then set the pixel to
	 * corresponding pixel value from <code>sourceBitmap</code>.</li>
	 * </ol>
	 *
	 * <p>The <code>operation</code> parameter specifies the comparison operator
	 * to use for the threshold test. For example, by using "==" as the
	 * <code>operation</code> parameter, you can isolate a specific color value
	 * in an image. Or by using <code>{operation: "<", mask: 0xFF000000,
	 * threshold: 0x7F000000, color: 0x00000000}</code>, you can set all
	 * destination pixels to be fully transparent when the source image pixel's
	 * alpha is less than 0x7F. You can use this technique for animated
	 * transitions and other effects.</p>
	 * 
	 * @param sourceBitmapData The input bitmap image to use. The source image
	 *                         can be a different BitmapData object or it can
	 *                         refer to the current BitmapData instance.
	 * @param sourceRect       A rectangle that defines the area of the source
	 *                         image to use as input.
	 * @param destPoint        The point within the destination image (the
	 *                         current BitmapData instance) that corresponds to
	 *                         the upper-left corner of the source rectangle.
	 * @param operation        One of the following comparison operators, passed
	 *                         as a String: "<", "<=", ">", ">=", "==", "!="
	 * @param threshold        The value that each pixel is tested against to see
	 *                         if it meets or exceeds the threshhold.
	 * @param color            The color value that a pixel is set to if the
	 *                         threshold test succeeds. The default value is
	 *                         0x00000000.
	 * @param mask             The mask to use to isolate a color component.
	 * @param copySource       If the value is <code>true</code>, pixel values
	 *                         from the source image are copied to the
	 *                         destination when the threshold test fails. If the
	 *                         value is <code>false</code>, the source image is
	 *                         not copied when the threshold test fails.
	 * @return The number of pixels that were changed.
	 * @throws ArgumentError The operation string is not a valid operation
	 * @throws TypeError     The sourceBitmapData, sourceRect destPoint or
	 *                       operation are null.
	 */
	//function threshold(sourceBitmapData : BitmapData, sourceRect : nme.geom.Rectangle, destPoint : nme.geom.Point, operation : String, threshold : Int, color : Int = 0, mask : Int = 0xFFFFFFFF, copySource : Bool = false) : Int;

	/**
	 * Unlocks an image so that any objects that reference the BitmapData object,
	 * such as Bitmap objects, are updated when this BitmapData object changes.
	 * To improve performance, use this method along with the <code>lock()</code>
	 * method before and after numerous calls to the <code>setPixel()</code> or
	 * <code>setPixel32()</code> method.
	 * 
	 * @param changeRect The area of the BitmapData object that has changed. If
	 *                   you do not specify a value for this parameter, the
	 *                   entire area of the BitmapData object is considered
	 *                   changed.
	 */
	function unlock(?changeRect : nme.geom.Rectangle) : Void;
}


#elseif (cpp || neko)
typedef BitmapData = neash.display.BitmapData;
#elseif js
typedef BitmapData = jeash.display.BitmapData;
#else
typedef BitmapData = flash.display.BitmapData;
#end
