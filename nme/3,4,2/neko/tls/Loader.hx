package neko.tls;

import sys.io.Process;

class Loader {
	
	public static function load( f : String, args : Int ) : Dynamic {
		
		return neko.Lib.load ("tls", f, args);
		
	}
	
}
