package won.page 
{
	import flash.display.Sprite;
	
	public class Preview extends Sprite
	{
		public function Preview()
		{
			
		}
		
		public function clear():void
		{			
			var i:int = this.numChildren;
			while (i > 0)
			{				
				this.removeChildAt(0);
				i = (i - 1);
			}
		}
		
	}	
	
}