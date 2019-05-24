﻿package skins.metalicBW
{
    import flash.display.*;

    public class Bg extends Sprite
    {

        public function Bg(documentWidth:Number, documentHeight:Number)
        {
            this.graphics.beginFill(0xDDDDDD);
            this.graphics.drawRect(0, 0, documentWidth, documentHeight);
            this.graphics.endFill();            
        }
    }
}
