﻿package won.color
{
	
	public class RGB extends Object
	{
		private var _c:uint;
		private var _r:uint;
		private var _g:uint;
		private var _b:uint;
		private var _hex:String;
		
		public function RGB(color:uint)
		{
			_c = color;		
		}
			
		public function get red():uint{ return _r; }		
		public function get green():uint{ return _g;}
		public function get blue():uint{	return _b;}
		public function get hex():String{return _hex;}
		
		private function parseRGB() : void
		{			
			_r = Math.floor(_c / 65536);
			_g = Math.floor((_c - Math.floor(_c / 65536) * 65536) / 256);
			_b = _c - Math.floor(_c / 256) * 256;
			
			var hex:String = _c.toString(16);
			while (hex.length < 6)
				hex = "0" + hex;
			
			_hex = "0x" + hex;			
		}		
		
		
		public static function parseRGB(color:uint) : RGB
		{
			var c:RGB = new RGB(color);
			c.parseRGB();
			return c;
		}		
		
	}
}
