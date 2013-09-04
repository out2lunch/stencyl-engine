package nme.text;
#if code_completion


/**
 * The TextFieldType class is an enumeration of constant values used in
 * setting the <code>type</code> property of the TextField class.
 */
@:fakeEnum(String) extern enum TextFieldType {

	/**
	 * Used to specify a <code>dynamic</code> TextField.
	 */
	DYNAMIC;

	/**
	 * Used to specify an <code>input</code> TextField.
	 */
	INPUT;
}


#elseif (cpp || neko)
typedef TextFieldType = neash.text.TextFieldType;
#elseif js
typedef TextFieldType = jeash.text.TextFieldType;
#else
typedef TextFieldType = flash.text.TextFieldType;
#end
