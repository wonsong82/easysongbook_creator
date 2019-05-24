package skins.metalicBW
{
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	
	
	public class Header extends Sprite
	{
		public function Header(documentWidth:Number, documentHeight:Number, marginTop:Number, marginBottom:Number, marginLeft:Number, marginRight:Number, headingHeight:Number, footerHeight:Number, headingRatio:Array)
        {			
			
			
            var thisWidth:Number = documentWidth - (marginLeft + marginRight);
            var thisHeight:Number = headingHeight * headingRatio[0];
            var roundSize:Number = thisWidth * 0.01;
            this.graphics.beginGradientFill("linear", [0xE6E6E6, 0xBEBEBE], [1, 1], [0, 255]);
            this.graphics.drawRoundRectComplex(0, 0, thisWidth, thisHeight, roundSize, roundSize, 0, 0);
            this.graphics.endFill();
            this.filters = [new DropShadowFilter(documentWidth / 612 * 4, 45, 6710886, 1, documentWidth / 612 * 10, documentWidth / 612 * 10)];            
        }		
	}
}