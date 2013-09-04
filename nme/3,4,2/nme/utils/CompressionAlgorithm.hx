package nme.utils;
#if code_completion


/**
 * The CompressionAlgorithm class defines string constants for the names of
 * compress and uncompress options. These constants are used as values of the
 * <code>algorithm</code> parameter of the <code>ByteArray.compress()</code>
 * and <code>ByteArray.uncompress()</code> methods.
 */
@:fakeEnum(String) extern enum CompressionAlgorithm {

	/**
	 * Defines the string to use for the deflate compression algorithm.
	 */
	DEFLATE;

	/**
	 * Defines the string to use for the zlib compression algorithm.
	 */
	ZLIB;
}


#elseif (cpp || neko)
typedef CompressionAlgorithm = neash.utils.CompressionAlgorithm;
#elseif js
typedef CompressionAlgorithm = jeash.utils.CompressionAlgorithm;
#else
typedef CompressionAlgorithm = flash.utils.CompressionAlgorithm;
#end
