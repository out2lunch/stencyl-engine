package nme.events;
#if code_completion


/**
 * The EventPhase class provides values for the <code>eventPhase</code>
 * property of the Event class.
 */
@:fakeEnum(Int) extern enum EventPhase {
	AT_TARGET;
	BUBBLING_PHASE;
	CAPTURING_PHASE;
}


#elseif (cpp || neko)
typedef EventPhase = neash.events.EventPhase;
#elseif js
typedef EventPhase = jeash.events.EventPhase;
#else
typedef EventPhase = flash.events.EventPhase;
#end
