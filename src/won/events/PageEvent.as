package won.events
{
	import flash.events.*;
	
	public class PageEvent extends Event
	{
		public static const COMPLETE:String = "page_complete";
		
		public function PageEvent(type:String, bubble:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubble, cancelable);			
		}
		
	}
}
