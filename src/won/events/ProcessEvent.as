package won.events
{
	import flash.events.*;
	
	public class ProcessEvent extends Event
	{
		public var text:String;
		public static const INIT:String = "process_initialized";
		public static const COMPLETE:String = "process_completed";
		
		public function ProcessEvent(type:String, text:String="", bubble:Boolean = false, cancelable:Boolean = false)
		{
			
			super(type, bubble, cancelable);
			this.text = text;
			
		}
	}
}
