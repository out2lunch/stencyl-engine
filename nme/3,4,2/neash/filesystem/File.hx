package neash.filesystem;


import StringTools;
import neash.Loader;


class File 
{
   static inline var APP = 0;
   static inline var STORAGE = 1;
   static inline var DESKTOP = 2;
   static inline var DOCS = 3;
   static inline var USER = 4;
	
	public static var applicationDirectory(nmeGetAppDir, null):File;
   public static var applicationStorageDirectory(nmeGetStorageDir,null) : File;
   public static var desktopDirectory(nmeGetDesktopDir,null) : File;
   public static var documentsDirectory(nmeGetDocsDir,null) : File;
   public static var userDirectory(nmeGetUserDir,null) : File;

	
	public var nativePath(default, nmeSetNativePath):String;
	public var url(default, nmeSetURL):String;
	
	
	public function new(?path:String = null)
	{
		nmeSetURL(path);
		nmeSetNativePath(path);
	}
	
   #if !android
	private static var nme_filesystem_get_special_dir = Loader.load("nme_filesystem_get_special_dir", 1);
   #else
   static var jni_filesystem_get_special_dir:Dynamic = null;
   static function nme_filesystem_get_special_dir(inWhich:Int) : String
   {
      if (jni_filesystem_get_special_dir==null)
         jni_filesystem_get_special_dir = nme.JNI.createStaticMethod("org.haxe.nme.GameActivity","getSpecialDir","(I)Ljava/lang/String;");
      return jni_filesystem_get_special_dir(inWhich);
   }
   #end
	
	
	// Getters & Setters
	private static function nmeGetAppDir():File
	{
		return new File(nme_filesystem_get_special_dir(APP));
	}
	private static function nmeGetStorageDir():File
	{
		return new File(nme_filesystem_get_special_dir(STORAGE));
	}
	private static function nmeGetDesktopDir():File
	{
		return new File(nme_filesystem_get_special_dir(DESKTOP));
	}
	private static function nmeGetDocsDir():File
	{
		return new File(nme_filesystem_get_special_dir(DOCS));
	}
	private static function nmeGetUserDir():File
	{
		return new File(nme_filesystem_get_special_dir(USER));
	}
	
	
	/** @private */ private function nmeSetNativePath(inPath:String):String
	{
		nativePath = inPath;
		return nativePath;
	}
	
	
	/** @private */ private function nmeSetURL(inPath:String):String
	{
		if (inPath == null)
		{
			url = null;
		}
		else
		{
			url = StringTools.replace(inPath, " ", "%20");
         #if iphone
			if (StringTools.startsWith(inPath, nme_get_resource_path()))
			{
				url = "app:" + url;
			}
			else
         #end
			{
				url = "file:" + url;
			}
		}
		return url;
	}
	
	
	
	// Native Methods
	
	
	

   #if iphone
	private static var nme_get_resource_path = Loader.load("nme_get_resource_path", 0);
   #end
	
}