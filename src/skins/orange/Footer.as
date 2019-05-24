﻿package skins.metalicBW
{
    import flash.display.*;
    import flash.filters.*;

    public class Footer extends Sprite
    {
        public function Footer(documentWidth:Number, documentHeight:Number, marginTop:Number, marginBottom:Number, marginLeft:Number, marginRight:Number, headingHeight:Number, footerHeight:Number)
        {
            var thisWidth:Number = documentWidth - (marginLeft + marginRight);
            var thisHeight:Number = footerHeight - documentWidth / 612 * 1;
            var roundCorner:Number = thisWidth * 0.01;
            this.graphics.beginGradientFill(GradientType.LINEAR, [0xe6e6e6, 0xbebebe], [1, 1], [0, 255]);
            this.graphics.drawRoundRectComplex(0, documentWidth / 612 * 1, thisWidth, thisHeight, 0, 0, roundCorner, roundCorner);
            this.graphics.endFill();
            var line:Shape = new Shape();
			line.graphics.lineStyle(1, 0xffffff);
            line.graphics.lineTo(thisWidth, 0);
            this.filters = [new DropShadowFilter(documentWidth / 612 * 4, 45, 0x666666, 1, documentWidth / 612 * 10, documentWidth / 612 * 10)];
           
        }
    }
}
