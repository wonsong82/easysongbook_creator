﻿package skins.metalicBW
{
    import flash.display.*;
    import flash.filters.*;

    public class Body extends Sprite
    {
		public function Body(documentWidth:Number, documentHeight:Number, marginTop:Number, marginBottom:Number, marginLeft:Number, marginRight:Number, headingHeight:Number, footerHeight:Number, columnRatio:Array, numColumns:Number, columnGap:Number)
        {
           var bodyWidth:Number = (documentWidth - (marginLeft + marginRight) - columnGap * (numColumns - 1)) / numColumns;
            var bodyHeight:Number = documentHeight - (marginTop + marginBottom + headingHeight + footerHeight);
           
			for (var i:int=0; i<numColumns; i++)
            {
                
                var container:Sprite = new Sprite();
                
				var colLeft:Sprite = new Sprite();
                colLeft.graphics.beginFill(16777215);
                colLeft.graphics.drawRect(0, 0, bodyWidth * columnRatio[0], bodyHeight);
                colLeft.graphics.endFill();
                container.addChild(colLeft);
                
				var colMid:Sprite = new Sprite();
                colMid.graphics.beginFill(13750737);
                colMid.graphics.drawRect(0, 0, bodyWidth * columnRatio[1], bodyHeight);
                colMid.graphics.endFill();
                colMid.x = container.width;
                container.addChild(colMid);
                
				var colRight:Sprite = new Sprite();
                colRight.graphics.beginFill(16777215);
                colRight.graphics.drawRect(0, 0, bodyWidth * columnRatio[2], bodyHeight);
                colRight.graphics.endFill();
                colRight.x = container.width;
                container.addChild(colRight);
               
			   container.x = (bodyWidth + columnGap) * i;
               this.addChild(container);               
            }
            this.x = marginLeft;
            this.y = marginTop + headingHeight;
            this.filters = [new DropShadowFilter(documentWidth / 612 * 4, 45, 6710886, 1, documentWidth / 612 * 10, documentWidth / 612 * 10)];
        }

    }
}
