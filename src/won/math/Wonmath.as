package won.math
{
	public class Wonmath
	{
		
		public static function precise(number:Number):Number
		{
			var precision:int = Math.pow(10,10);
			return Math.round(number * precision)/precision;	
		}
	}
	
}