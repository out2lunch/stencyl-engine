package nme.ui;
#if code_completion


extern class Accelerometer
{
	static function get():Acceleration;
}

#elseif (cpp || neko)
typedef Accelerometer = neash.ui.Accelerometer;
#elseif js
typedef Accelerometer = jeash.ui.Accelerometer;
#end