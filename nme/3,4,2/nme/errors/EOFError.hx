package nme.errors;
#if code_completion


/**
 * An EOFError exception is thrown when you attempt to read past the end of
 * the available data. For example, an EOFError is thrown when one of the read
 * methods in the IDataInput interface is called and there is insufficient
 * data to satisfy the read request.
 */
extern class EOFError/* extends IOError*/ {

	/**
	 * Creates a new EOFError object.
	 * 
	 * @param message A string associated with the error object.
	 */
	function new(?message : String, id : Int = 0) : Void;
}


#elseif (cpp || neko)
typedef EOFError = neash.errors.EOFError;
#elseif js
typedef EOFError = jeash.errors.EOFError;
#else
typedef EOFError = flash.errors.EOFError;
#end
