﻿package skins.metalicBW
{
    import flash.display.*;
    import flash.filters.*;
	import won.color.RGB;

    public class Description extends Sprite
    {
		
		public function Description(documentWidth:Number, documentHeight:Number, marginTop:Number, marginBottom:Number, marginLeft:Number, marginRight:Number, headingHeight:Number, footerHeight:Number, headerRatio:Array, numColumns:Number, columnGap:Number)
        {
           var descriptionWidth:Number = documentWidth - (marginLeft + marginRight);
            var columnHeight:Number = headingHeight * headerRatio[1] - documentWidth / 612 * 2;
            var roundCorner:Number = descriptionWidth * 0.01;
            var columnWidth:Number = (descriptionWidth - (numColumns - 1) * columnGap) / numColumns;
            
			for (var i:int=0; i<numColumns; i++)
			{                
                var emptyBg:Sprite = new Sprite();
                emptyBg.graphics.beginFill(0, 0);				
                emptyBg.graphics.drawRect(0, 0, descriptionWidth, headingHeight * headerRatio[1]);
                emptyBg.graphics.endFill();
             	this.addChild(emptyBg);
                
				var desc:Sprite = new Sprite();
                desc.graphics.beginGradientFill(GradientType.LINEAR, getGradientValue(0xe6e6e6, 0xb2b2b2, i, numColumns), [1, 1], [0, 255]);
                desc.graphics.drawRoundRectComplex(0, 0, columnWidth, columnHeight, 0, 0, roundCorner, roundCorner);
                desc.graphics.endFill();
                desc.x = (columnWidth + columnGap) * i;
                desc.y = documentWidth / 612 * 1;
                this.addChild(desc);
               
			   var highLight:Sprite = new Sprite();
                highLight.graphics.beginFill(0xffffff, 1);
                highLight.graphics.drawRect(0, 0, columnWidth, documentWidth / 612 * 1);
                highLight.graphics.endFill();
                highLight.x = (columnWidth + columnGap) * i;
                highLight.y = documentWidth / 612 * 1;
              	this.addChild(highLight);
               
            }
            this.filters = [new DropShadowFilter(documentWidth / 612 * 4, 45, 0x666666, 1, documentWidth / 612 * 10, documentWidth / 612 * 10)];            
        }

        private function getGradientValue(initialColor:uint, finalColor:uint, current:int, total:int) : Array
        {
            var startColor:RGB = RGB.parseRGB(initialColor);
            var endColor:RGB = RGB.parseRGB(finalColor);		
			var colorFrom:String = "0x" + (startColor.red + (endColor.red - startColor.red) / total * current).toString(16) + (startColor.green + (endColor.green - startColor.green) / total * current).toString(16) + (startColor.blue + (endColor.blue - startColor.blue) / total * current).toString(16);
            var colorTo:String = "0x" + (startColor.red + (endColor.red - startColor.red) / total * (current + 1)).toString(16) + (startColor.green + (endColor.green - startColor.green) / total * (current + 1)).toString(16) + (startColor.blue + (endColor.blue - startColor.blue) / total * (current + 1)).toString(16);
            return [uint(colorFrom), uint(colorTo)];			
        }

    }
}
