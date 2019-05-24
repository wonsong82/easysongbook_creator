﻿package skins.metalicBW
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.text.*;
    import won.font.Text;

    public class Alphabet extends MovieClip
    {
        private var _char:String;
        private var _bgWidth:Number;
        private var _bgHeight:Number;

        public function Alphabet(char, backgroundWidth, backgroundHeight)
        {
            _char = char;
            _bgWidth = backgroundWidth;
            _bgHeight = backgroundHeight;            
        }
		
		public function draw() : void
        {
            var fontLoader:Loader = new Loader();
            fontLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, drawBackground);
            fontLoader.load(new URLRequest("fonts/GillSans-UltraBold.swf"));           
        }
		
		
		private function drawBackground(e:Event) : void
        {
            var matrix:Matrix = new Matrix();
            matrix.createGradientBox(_bgWidth, _bgHeight, Math.PI * 90 / 180);
            this.graphics.beginGradientFill("linear", [0xbebebe, 0xe6e6e6], [1, 1], [0, 255], matrix);
            this.graphics.drawRect(0, 0, _bgWidth, _bgHeight);
            this.graphics.endFill();
            writeAlphabet();            
        }
		
		
        private function writeAlphabet() : void
        {
            var alphabet:Sprite = new Sprite();
            var tf:TextField = Text.write(_char, {font:"GillSans-UltraBold", embed:true});
            alphabet.addChild(tf);
			
            var alphabetWidth:Number = alphabet.width;
            var alphabetHeight:Number = alphabet.height;
            
			alphabet.height = _bgHeight * 0.8;
            alphabet.width = alphabetWidth * alphabet.height / alphabetHeight;
            
			alphabet.x = (_bgWidth - alphabet.width) * 0.5;
            alphabet.y = (_bgHeight - alphabet.height) * 0.5;
            
			this.addChild(alphabet);
            dispatchEvent(new Event(Event.COMPLETE));            
        }

        
       
    }
}
