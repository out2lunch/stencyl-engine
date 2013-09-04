package neash.display;


import neash.events.Event;
import neash.events.EventDispatcher;
import neash.events.EventPhase;
import neash.geom.Point;
import neash.geom.Rectangle;
import neash.geom.Matrix;
import neash.geom.Transform;
import neash.geom.ColorTransform;
import neash.geom.Point;
import neash.filters.BitmapFilter;
import neash.Loader;


class DisplayObject extends EventDispatcher, implements IBitmapDrawable
{
	
	/**
	 * The opacity of the object, as a percentage value from 0 to 1
	 */
	public var alpha(nmeGetAlpha, nmeSetAlpha):Float;
	
	/**
	 * Adjusts this object blends with other objects on-screen
	 */
	public var blendMode(nmeGetBlendMode, nmeSetBlendMode):BlendMode;
	
	/**
	 * If set to true, NME will render the object using its software renderer,
	 * then it will cache the result. This can improve performance for certain
	 * types of complex objects.
	 */
	public var cacheAsBitmap(nmeGetCacheAsBitmap, nmeSetCacheAsBitmap):Bool;
	
/**
	 * When cacheAsBitmap is true, new bitmaps are generated when the DisplayObject changes.
	 * When pedanticBitmapCaching=true, new bitmaps will be generated for non-integer sub-pixel movements.
	 * When pedanticBitmapCaching=false, new bitmaps will not be generated for general translations.
    * This allows for the number of renders to be kept small, while maintaining sub-pixel anti-aliasing,
    *  at the cost of sub-pixel accuracy in position.
    * Note that this is not supported in flash (which effectively defaults to true), an it is generally a perfromance optimisation.
	 */
	public var pedanticBitmapCaching(nmeGetPedanticBitmapCaching, nmeSetPedanticBitmapCaching):Bool;

/**
  * This allows translations to be aligned to pixel boundaries, giving more predicatble results.
  * Note that this more general that the flash.display.Bitmap.pixelSnapping in that it can be applied to any DisplayObject.
  */
	public var pixelSnapping(nmeGetPixelSnapping, nmeSetPixelSnapping) :PixelSnapping;
	/**
	 * An array of BitmapFilters being used with this object.
	 * 
	 * If you want to add, remove or change a filter, you need to re-assign
	 * the property, like "displayObject.filters = newFilters;" 
	 */
	public var filters(nmeGetFilters, nmeSetFilters):Array<Dynamic>;
	
	/**
	 * Returns a reference to the nme.display.Graphics interface
	 * for this object. You can use this class to draw primitives
	 * like squares, circles, lines, curves or tiles.
	 */
	public var graphics(nmeGetGraphics, null):Graphics;
	
	/**
	 * The height in pixels for this object
	 */
	public var height(nmeGetHeight, nmeSetHeight):Float;
	
	/**
	 * Define a mask to control how much of this object should
	 * be visible.
	 */
	public var mask(default, nmeSetMask):DisplayObject;
	
	/**
	 * Indicates the current mouse x position, using the coordinate system of
	 * this object.
	 */
	public var mouseX(nmeGetMouseX, null):Float;
	
	/**
	 * Indicates the current mouse y position, using the coordinate system of
	 * this object.
	 */
	public var mouseY(nmeGetMouseY, null):Float;
	
	/**
	 * Get or set the name for this object.
	 */
	public var name(nmeGetName, nmeSetName):String;
	
	/**
	 * @private
	 */
	public var nmeHandle:Dynamic;
	
	/**
	 * Set or change an opaque background color for this object.
	 */
	public var opaqueBackground(nmeGetBG, nmeSetBG):Null <Int>;
	
	/**
	 * If this object has been added to the display list, then this is
	 * the "parent" DisplayObjectContainer. Otherwise this will be
	 * null.
	 */
	public var parent(nmeGetParent, null):DisplayObjectContainer;
	
	/**
	 * Control the rotation of this object, in degrees.
	 */
	public var rotation(nmeGetRotation, nmeSetRotation):Float;
	
	/**
	 * Set a "scale 9" grid to control how the object stretches or
	 * squashes when its scale is changed.
	 */
	public var scale9Grid(nmeGetScale9Grid, nmeSetScale9Grid):Rectangle;
	
	/**
	 * Control the horizontal scale of the object, as a percentage value
	 */
	public var scaleX(nmeGetScaleX, nmeSetScaleX):Float;
	
	/**
	 * Control the vertical scale of the object, as a percentage value
	 */
	public var scaleY(nmeGetScaleY, nmeSetScaleY):Float;
	
	/**
	 * Set a "scroll rect" to control how much of the object should be rendered
	 */
	public var scrollRect(nmeGetScrollRect, nmeSetScrollRect):Rectangle;
	
	/**
	 * If this object has been added to the display list, which has been added
	 * to the stage, this will return the root Stage object. Otherwise, this will
	 * return null.
	 */
	public var stage(nmeGetStage, null):Stage;
	
	/**
	 * Set the matrix and color transform for this object.
	 * 
	 * If you want to change the object's transform, you need to re-assign
	 * the property, like "displayObject.transform = newTransform;" 
	 */
	public var transform(nmeGetTransform, nmeSetTransform):Transform;
	
	/**
	 * Controls whether this object is visible and rendered, or if
	 * it is invisible.
	 * 
	 * An object that has visible set to false will perform faster than
	 * and object that only has its alpha set to 0.
	 */
	public var visible(nmeGetVisible, nmeSetVisible):Bool;
	
	/**
	 * The width in pixels for this object
	 */
	public var width(nmeGetWidth, nmeSetWidth):Float;
	
	/**
	 * The x position for this object, local to its parent
	 */
	public var x(nmeGetX, nmeSetX):Float;
	
	/**
	 * The y position for this object, local to its parent
	 */
	public var y(nmeGetY, nmeSetY):Float;
	
	/** @private */	private var nmeFilters:Array<Dynamic>;
	/** @private */	private var nmeGraphicsCache:Graphics;
	/** @private */	private var nmeID:Int;
	/** @private */	private var nmeParent:DisplayObjectContainer;
	/** @private */	private var nmeScale9Grid:Rectangle;
	/** @private */	private var nmeScrollRect:Rectangle;
	

	public function new(inHandle:Dynamic, inType:String)
	{
		super(this);
		
		nmeParent = null;
		nmeHandle = inHandle;
		nmeID = nme_display_object_get_id(nmeHandle);
		nmeSetName (inType + " " + nmeID);
	}
	
	
	override public function dispatchEvent(event:Event):Bool {
		
		var result = nmeDispatchEvent(event);
		
		if (event.nmeGetIsCancelled ())
			return true;
		
		if (event.bubbles && parent != null)
		{
			parent.dispatchEvent(event);
		}
		
		return result;
	}
	
	
	/**
	 * Converts a point from global coordinates to local coordinates.
	 * @param	inGlobal		A point in global coordinates
	 * @return		A point in local coordinates
	 */
	public function globalToLocal(inGlobal:Point):Point
	{
		var result = inGlobal.clone();
		nme_display_object_global_to_local(nmeHandle, result);
		return result;
	}
	
	
	public function hitTestObject(object:DisplayObject):Bool
	{
		if (object != null && object.parent != null && parent != null)
		{
			var currentMatrix = transform.concatenatedMatrix;
			var targetMatrix = object.transform.concatenatedMatrix;
			
			var xPoint = new Point(1, 0);
			var yPoint = new Point(0, 1);
			
			var currentWidth = width * currentMatrix.deltaTransformPoint(xPoint).length;
			var currentHeight = height * currentMatrix.deltaTransformPoint(yPoint).length;
			var targetWidth = object.width * targetMatrix.deltaTransformPoint(xPoint).length;
			var targetHeight = object.height * targetMatrix.deltaTransformPoint(yPoint).length;
			
			var currentRect = new Rectangle(currentMatrix.tx, currentMatrix.ty, currentWidth, currentHeight);
			var targetRect = new Rectangle(targetMatrix.tx, targetMatrix.ty, targetWidth, targetHeight);
			
			return currentRect.intersects (targetRect);
		}
		
		return false;
	}
	
	
	/**
	 * Determines if the specified global coordinate point overlaps the
	 * contents of this object.
	 * 
	 * This method does not check for transparency, so if the object contains
	 * a bitmap image, transparent pixels will return "true" for a hit test.
	 * @param	x		The x coordinate point to test
	 * @param	y		The y coordinate point to test
	 * @param	shapeFlag		Whether to use the exact shape of this object (slower) or a bounding box
	 * @return		Whether the point intersects with the contents of this object
	 */
	public function hitTestPoint(x:Float, y:Float, shapeFlag:Bool = false):Bool
	{
		return nme_display_object_hit_test_point(nmeHandle, x, y, shapeFlag, true);
	}

	public function getBounds(targetCoordinateSpace : DisplayObject) : Rectangle
   {
      var result = new Rectangle();
		nme_display_object_get_bounds(nmeHandle, targetCoordinateSpace.nmeHandle, result, true );
      return result;
   }

   public function  getRect(targetCoordinateSpace : DisplayObject) : Rectangle
   {
      var result = new Rectangle();
		nme_display_object_get_bounds(nmeHandle, targetCoordinateSpace.nmeHandle, result, false );
      return result;
   }


	
	
	/**
	 * Converts a point from local coordinates to global coordinates.
	 * @param	inGlobal		A point in local coordinates
	 * @return		A point in global coordinates
	 */
	public function localToGlobal(inLocal:Point)
	{
		var result = inLocal.clone();
		nme_display_object_local_to_global(nmeHandle, result);
		return result;
	}
	
	
	/** @private */ private function nmeAsInteractiveObject():InteractiveObject
	{
		return null;
	}
	
	
	/** @private */ public function nmeBroadcast(inEvt:Event)
	{
		nmeDispatchEvent(inEvt);
	}
	
	
	/** @private */ public function nmeDispatchEvent(inEvt:Event):Bool
	{
		if (inEvt.target == null)
		{
			inEvt.target = this;
		}
		inEvt.currentTarget = this;
		return super.dispatchEvent(inEvt);
	}
	
	
	/** @private */ public function nmeDrawToSurface(inSurface:Dynamic, matrix:Matrix, colorTransform:ColorTransform, blendMode:String, clipRect:Rectangle, smoothing:Bool):Void
	{
		// --- IBitmapDrawable interface ---
		nme_display_object_draw_to_surface(nmeHandle, inSurface, matrix, colorTransform, blendMode, clipRect);
	}
	
	
	/** @private */ private function nmeFindByID(inID:Int):DisplayObject
	{
		if (nmeID == inID)
			return this;
		return null;
	}
	
	
	/** @private */ private function nmeFireEvent(inEvt:Event)
	{
		var stack:Array<InteractiveObject> = [];
		
		if (nmeParent != null)
			nmeParent.nmeGetInteractiveObjectStack(stack);
		
		var l = stack.length;
		
		if (l > 0)
		{
			// First, the "capture" phase ...
			inEvt.nmeSetPhase(EventPhase.CAPTURING_PHASE);
			stack.reverse();
			
			for (obj in stack)
			{
				inEvt.currentTarget = obj;
				obj.nmeDispatchEvent(inEvt);
				
				if (inEvt.nmeGetIsCancelled())
					return;
				
			}
		}
		
		// Next, the "target"
		inEvt.nmeSetPhase(EventPhase.AT_TARGET);
		inEvt.currentTarget = this;
		nmeDispatchEvent(inEvt);
		
		if (inEvt.nmeGetIsCancelled())
			return;
		
		// Last, the "bubbles" phase
		if (inEvt.bubbles)
		{
			inEvt.nmeSetPhase(EventPhase.BUBBLING_PHASE);
			stack.reverse();
			
			for (obj in stack)
			{
				inEvt.currentTarget = obj;
				obj.nmeDispatchEvent(inEvt);
				
				if (inEvt.nmeGetIsCancelled())
					return;
			}
		}
	}
	
	
	/** @private */ public function nmeGetColorTransform():ColorTransform
	{ 
		var trans = new ColorTransform();
		nme_display_object_get_color_transform(nmeHandle, trans, false);
		return trans;
	}
	
	
	/** @private */ public function nmeGetConcatenatedColorTransform():ColorTransform
	{
		var trans = new ColorTransform();
		nme_display_object_get_color_transform(nmeHandle, trans, true);
		return trans;
	}
	
	
	/** @private */ public function nmeGetConcatenatedMatrix():Matrix
	{
		var mtx = new Matrix();
		nme_display_object_get_matrix(nmeHandle, mtx, true);
		return mtx;
	}
	
	
	/** @private */ public function nmeGetInteractiveObjectStack(outStack:Array<InteractiveObject>)
	{
		var io = nmeAsInteractiveObject();
		
		if (io != null)
			outStack.push(io);
		
		if (nmeParent != null)
			nmeParent.nmeGetInteractiveObjectStack(outStack);
	}
	
	
	/** @private */ public function nmeGetMatrix():Matrix
	{
		var mtx = new Matrix();
		nme_display_object_get_matrix(nmeHandle, mtx, false);
		return mtx;
	}
	
	
	/** @private */ public function nmeGetObjectsUnderPoint(point:Point, result:Array<DisplayObject>)
	{
		if (nme_display_object_hit_test_point(nmeHandle, point.x, point.y, true, false))
			result.push(this);
	}
	
	
	/** @private */ public function nmeGetPixelBounds():Rectangle
	{
		var rect = new Rectangle();
		nme_display_object_get_pixel_bounds(nmeHandle, rect);
		return rect;
	}
	
	
	/** @private */ private function nmeOnAdded(inObj:DisplayObject, inIsOnStage:Bool)
	{
		if (inObj == this)
		{
			var evt = new Event(Event.ADDED, true, false);
			evt.target = inObj;
			dispatchEvent(evt);
		}
		
		if (inIsOnStage)
		{
			var evt = new Event(Event.ADDED_TO_STAGE, false, false);
			evt.target = inObj;
			dispatchEvent(evt);
		}
	}
	
	
	/** @private */ private function nmeOnRemoved(inObj:DisplayObject, inWasOnStage:Bool)
	{
		if (inObj == this)
		{
			var evt = new Event(Event.REMOVED, true, false);
			evt.target = inObj;
			dispatchEvent(evt);
		}
		
		if (inWasOnStage)
		{
			var evt = new Event(Event.REMOVED_FROM_STAGE, false, false);
			evt.target = inObj;
			dispatchEvent(evt);
		}
	}
	
	
	/** @private */ public function nmeSetColorTransform(inTrans:ColorTransform)
	{
		nme_display_object_set_color_transform(nmeHandle, inTrans);
	}
	
	
	/** @private */ public function nmeSetMatrix(inMatrix:Matrix)
	{
		nme_display_object_set_matrix(nmeHandle, inMatrix);
	}
	
	
	/**
	 * @inheritDoc
	 */
	override public function toString():String
	{
		return name;
	}
	
	
	
	// Getters & Setters
	
	
	
	/** @private */ private function nmeGetAlpha():Float {	return nme_display_object_get_alpha(nmeHandle); }
	/** @private */ private function nmeSetAlpha(inAlpha:Float):Float
	{
		nme_display_object_set_alpha(nmeHandle, inAlpha);
		return inAlpha;	
	}
   
	
	/** @private */ private function nmeGetBG():Null<Int>
	{
		var i:Int = nme_display_object_get_bg(nmeHandle);
		if ((i& 0x01000000)==0)
			return null;
		
		return i & 0xffffff;
	}
	
	
	/** @private */ private function nmeSetBG(inBG:Null<Int>):Null<Int>
	{	
		if (inBG == null)
			nme_display_object_set_bg(nmeHandle, 0);
		else
			nme_display_object_set_bg(nmeHandle, inBG);
		
		return inBG;
	}
	
	
	/** @private */ private function nmeGetBlendMode():BlendMode
	{	
		var i:Int = nme_display_object_get_blend_mode(nmeHandle);
		return Type.createEnumIndex(BlendMode, i);	
	}
	
	
	/** @private */ private function nmeSetBlendMode(inMode:BlendMode):BlendMode
	{	
		nme_display_object_set_blend_mode(nmeHandle, Type.enumIndex(inMode));
		return inMode;	
	}
	
	
	/** @private */ private function nmeGetCacheAsBitmap():Bool { return nme_display_object_get_cache_as_bitmap(nmeHandle); }
	/** @private */ private function nmeSetCacheAsBitmap(inVal:Bool):Bool
	{
		nme_display_object_set_cache_as_bitmap(nmeHandle,inVal);
		return inVal;
	}
	
	/** @private */ private function nmeGetPedanticBitmapCaching():Bool { return nme_display_object_get_pedantic_bitmap_caching(nmeHandle); }
	/** @private */ private function nmeSetPedanticBitmapCaching(inVal:Bool):Bool
	{
		nme_display_object_set_pedantic_bitmap_caching(nmeHandle,inVal);
		return inVal;
	}
	/** @private */ private function nmeGetPixelSnapping():PixelSnapping
   {
      var val:Int = nme_display_object_get_pixel_snapping(nmeHandle);
		return Type.createEnumIndex(PixelSnapping, val);
   }
	/** @private */ private function nmeSetPixelSnapping(inVal:PixelSnapping):PixelSnapping
	{
		if (inVal==null)
			nme_display_object_set_pixel_snapping(nmeHandle,0);
			nme_display_object_set_pixel_snapping(nmeHandle,Type.enumIndex(inVal));
		return inVal;
	}
	
	/** @private */ private function nmeGetFilters():Array<Dynamic>
	{	
		if (nmeFilters==null) return [];
		
		var result = new Array<Dynamic>();
		
		for (filter in nmeFilters)
			result.push(filter.clone());
		
		return result;
	}
	
	
	/** @private */ private function nmeSetFilters (inFilters:Array<Dynamic>):Array<Dynamic>
	{
		if (inFilters == null)
		{	
			nmeFilters = null;	
		}
		else
		{	
			nmeFilters = new Array<Dynamic>();
			
			for (filter in inFilters)
				nmeFilters.push(filter.clone());
		}
		
		nme_display_object_set_filters(nmeHandle, nmeFilters);
		
		return inFilters;
	}
	
	
	/** @private */ public function nmeGetGraphics():Graphics
	{
		if (nmeGraphicsCache == null)
			nmeGraphicsCache = new Graphics(nme_display_object_get_graphics(nmeHandle));
		return nmeGraphicsCache;
	}
	
	
	/** @private */ private function nmeGetHeight():Float { return nme_display_object_get_height(nmeHandle); }
	/** @private */ private function nmeSetHeight(inVal:Float):Float
	{
		nme_display_object_set_height(nmeHandle, inVal);
		return inVal;
	}
	
	
	/** @private */ private function nmeSetMask(inObject:DisplayObject)
	{
		mask = inObject;
		nme_display_object_set_mask(nmeHandle, inObject == null ? null : inObject.nmeHandle);
		return inObject;
	}
	
	
	/** @private */ private function nmeGetMouseX():Float { return nme_display_object_get_mouse_x(nmeHandle); }
	/** @private */ private function nmeGetMouseY():Float { return nme_display_object_get_mouse_y(nmeHandle); }
	
	
	/** @private */ private function nmeGetName():String { return nme_display_object_get_name(nmeHandle); }
	/** @private */ private function nmeSetName(inVal:String):String
	{	
		nme_display_object_set_name(nmeHandle, inVal);
		return inVal;
	}
	
	
	/** @private */ private function nmeGetParent():DisplayObjectContainer { return nmeParent;	}
	
	
	/** @private */ public function nmeSetParent(inParent:DisplayObjectContainer)
	{	
		if (inParent == nmeParent)
			return inParent;
		
		if (nmeParent != null)
			nmeParent.nmeRemoveChildFromArray(this);
		
		if (nmeParent == null && inParent != null)
		{	
			nmeParent = inParent;
			nmeOnAdded(this, (stage != null));	
		}
		else if (nmeParent != null && inParent == null)
		{	
			var was_on_stage = (stage != null);
			nmeParent = inParent;
			nmeOnRemoved(this, was_on_stage);	
		}
		else
		{	
			nmeParent = inParent;	
		}
		
		return inParent;
	}
	
	
	/** @private */ private function nmeGetRotation():Float { return nme_display_object_get_rotation(nmeHandle); }
	/** @private */ private function nmeSetRotation(inVal:Float):Float
	{
		nme_display_object_set_rotation(nmeHandle, inVal);
		return inVal;
	}
	
	
	/** @private */ private function nmeGetScale9Grid():Rectangle { return (nmeScale9Grid == null) ? null : nmeScale9Grid.clone(); }
	/** @private */ private function nmeSetScale9Grid(inRect:Rectangle):Rectangle
	{
		nmeScale9Grid = (inRect == null) ? null : inRect.clone();
		nme_display_object_set_scale9_grid(nmeHandle, nmeScale9Grid);
		return inRect;
	}
	
	
	/** @private */ private function nmeGetScaleX():Float { return nme_display_object_get_scale_x(nmeHandle); }
	/** @private */ private function nmeSetScaleX(inVal:Float):Float
	{	
		nme_display_object_set_scale_x(nmeHandle, inVal);
		return inVal;
	}

	
	/** @private */ private function nmeGetScaleY():Float { return nme_display_object_get_scale_y(nmeHandle); }
	/** @private */ private function nmeSetScaleY(inVal:Float):Float
	{	
		nme_display_object_set_scale_y(nmeHandle, inVal);
		return inVal;
	}
	
	
	/** @private */ private function nmeGetScrollRect():Rectangle { return (nmeScrollRect == null) ? null : nmeScrollRect.clone(); }
	/** @private */ private function nmeSetScrollRect(inRect:Rectangle):Rectangle
	{
		nmeScrollRect = (inRect == null) ? null : inRect.clone();
		nme_display_object_set_scroll_rect(nmeHandle, nmeScrollRect);
		return inRect;
	}
	
	
	/** @private */ public function nmeGetStage():Stage
	{	
		if (nmeParent != null)
			return nmeParent.nmeGetStage();
		
		return null;	
	}
	
	
	/** @private */ private function nmeGetTransform():Transform { return new Transform(this); }
	/** @private */ private function nmeSetTransform(inTransform:Transform):Transform
	{	
		nmeSetMatrix(inTransform.matrix);
		nmeSetColorTransform(inTransform.colorTransform);
		return inTransform;
	}
	
	
	/** @private */ private function nmeGetVisible():Bool { return nme_display_object_get_visible(nmeHandle);	}
	/** @private */ private function nmeSetVisible(inVal:Bool):Bool
	{	
		nme_display_object_set_visible(nmeHandle, inVal);
		return inVal;
	}
	
	
	/** @private */ private function nmeGetWidth():Float { return nme_display_object_get_width(nmeHandle); }
	/** @private */ private function nmeSetWidth(inVal:Float):Float
	{	
		nme_display_object_set_width(nmeHandle, inVal);
		return inVal;
	}
	
	
	/** @private */ private function nmeGetX():Float { return nme_display_object_get_x(nmeHandle); }
	/** @private */ private function nmeSetX(inVal:Float):Float
	{	
		nme_display_object_set_x(nmeHandle, inVal);
		return inVal;	
	}
	
	
	/** @private */ private function nmeGetY():Float { return nme_display_object_get_y(nmeHandle); }
	/** @private */ private function nmeSetY(inVal:Float):Float
	{
		nme_display_object_set_y(nmeHandle, inVal);
		return inVal;
	}
	
	
	
	// Native Methods
	
	
	
	private static var nme_create_display_object = Loader.load("nme_create_display_object", 0);
	private static var nme_display_object_get_graphics = Loader.load("nme_display_object_get_graphics", 1);
	private static var nme_display_object_draw_to_surface = Loader.load("nme_display_object_draw_to_surface", -1);
	private static var nme_display_object_get_id = Loader.load("nme_display_object_get_id", 1);
	private static var nme_display_object_get_x = Loader.load("nme_display_object_get_x", 1);
	private static var nme_display_object_set_x = Loader.load("nme_display_object_set_x", 2);
	private static var nme_display_object_get_y = Loader.load("nme_display_object_get_y", 1);
	private static var nme_display_object_set_y = Loader.load("nme_display_object_set_y", 2);
	private static var nme_display_object_get_scale_x = Loader.load("nme_display_object_get_scale_x", 1);
	private static var nme_display_object_set_scale_x = Loader.load("nme_display_object_set_scale_x", 2);
	private static var nme_display_object_get_scale_y = Loader.load("nme_display_object_get_scale_y", 1);
	private static var nme_display_object_set_scale_y = Loader.load("nme_display_object_set_scale_y", 2);
	private static var nme_display_object_get_mouse_x = Loader.load("nme_display_object_get_mouse_x", 1);
	private static var nme_display_object_get_mouse_y = Loader.load("nme_display_object_get_mouse_y", 1);
	private static var nme_display_object_get_rotation = Loader.load("nme_display_object_get_rotation", 1);
	private static var nme_display_object_set_rotation = Loader.load("nme_display_object_set_rotation", 2);
	private static var nme_display_object_get_bg = Loader.load("nme_display_object_get_bg", 1);
	private static var nme_display_object_set_bg = Loader.load("nme_display_object_set_bg", 2);
	private static var nme_display_object_get_name = Loader.load("nme_display_object_get_name", 1);
	private static var nme_display_object_set_name = Loader.load("nme_display_object_set_name", 2);
	private static var nme_display_object_get_width = Loader.load("nme_display_object_get_width", 1);
	private static var nme_display_object_set_width = Loader.load("nme_display_object_set_width", 2);
	private static var nme_display_object_get_height = Loader.load("nme_display_object_get_height", 1);
	private static var nme_display_object_set_height = Loader.load("nme_display_object_set_height", 2);
	private static var nme_display_object_get_alpha = Loader.load("nme_display_object_get_alpha", 1);
	private static var nme_display_object_set_alpha = Loader.load("nme_display_object_set_alpha", 2);
	private static var nme_display_object_get_blend_mode = Loader.load("nme_display_object_get_blend_mode", 1);
	private static var nme_display_object_set_blend_mode = Loader.load("nme_display_object_set_blend_mode", 2);
	private static var nme_display_object_get_cache_as_bitmap = Loader.load("nme_display_object_get_cache_as_bitmap", 1);
	private static var nme_display_object_set_cache_as_bitmap = Loader.load("nme_display_object_set_cache_as_bitmap", 2);
	private static var nme_display_object_get_pedantic_bitmap_caching = Loader.load("nme_display_object_get_pedantic_bitmap_caching", 1);
	private static var nme_display_object_set_pedantic_bitmap_caching = Loader.load("nme_display_object_set_pedantic_bitmap_caching", 2);
	private static var nme_display_object_get_pixel_snapping = Loader.load("nme_display_object_get_pixel_snapping", 1);
	private static var nme_display_object_set_pixel_snapping = Loader.load("nme_display_object_set_pixel_snapping", 2);
	private static var nme_display_object_get_visible = Loader.load("nme_display_object_get_visible", 1);
	private static var nme_display_object_set_visible = Loader.load("nme_display_object_set_visible", 2);
	private static var nme_display_object_set_filters = Loader.load("nme_display_object_set_filters", 2);
	private static var nme_display_object_global_to_local = Loader.load("nme_display_object_global_to_local", 2);
	private static var nme_display_object_local_to_global = Loader.load("nme_display_object_local_to_global", 2);
	private static var nme_display_object_set_scale9_grid = Loader.load("nme_display_object_set_scale9_grid", 2);
	private static var nme_display_object_set_scroll_rect = Loader.load("nme_display_object_set_scroll_rect", 2);
	private static var nme_display_object_set_mask = Loader.load("nme_display_object_set_mask", 2);
	private static var nme_display_object_set_matrix = Loader.load("nme_display_object_set_matrix", 2);
	private static var nme_display_object_get_matrix = Loader.load("nme_display_object_get_matrix", 3);
	private static var nme_display_object_get_color_transform = Loader.load("nme_display_object_get_color_transform", 3);
	private static var nme_display_object_set_color_transform = Loader.load("nme_display_object_set_color_transform", 2);
	private static var nme_display_object_get_pixel_bounds = Loader.load("nme_display_object_get_pixel_bounds", 2);
	private static var nme_display_object_get_bounds = Loader.load("nme_display_object_get_bounds", 4);
	private static var nme_display_object_hit_test_point = Loader.load("nme_display_object_hit_test_point", 5);

}
