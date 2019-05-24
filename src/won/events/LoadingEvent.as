package won.events
{
	import flash.events.*;
	
	public class LoadingEvent extends ProgressEvent
	{
		public var text:String;
		public static const PROGRESS:String = "loading_progress";
		public static const COMPLETE:String = "loading_complete";
		
		public function LoadingEvent(type:String, text:String, bytesLoaded:Number = 0, bytesTotal:Number = 0, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable, bytesLoaded, bytesTotal);			
			this.text = text;			
		}
		
	}
}
