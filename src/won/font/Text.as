package won.font
{
	import flash.text.*;
	
	public class Text extends Object
	{
		
		public function Text()
		{			
		}
		
		public static function write(text:String, param:Object = null) : TextField
		{
			var font:String = param.font != null ? param.font : "arial";
			var size:Number = param.size != null ? param.size : 12;
			var color:uint = param.color != null ? param.color : 0;
			var autoSize:String = param.autoSize != null ? param.autoSize : "left";
			var antiAlias:String = param.antiAlias != null ? param.antiAlias : "advanced";
			var filters:Array = param.filters != null ? param.filters : null;
			var embed:Boolean = param.embed != null ? param.embed : false;
			var selectable:Boolean = param.selectable != null ? param.selectable : true;
			var wordWrap:Boolean = param.wordWrap != null ? param.wordWrap : false;
			var align:String = param.align != null ? param.align : "left";
			var bold:Boolean = param.bold != null ? param.bold : false;
			var bullet:Boolean = param.bullet != null ? param.bullet : false;
			var italic:Boolean = param.italic != null ? param.italic : false;
			var underline:Boolean = param.underline != null ? param.underline : false;
			var kerning:Boolean = param.kerning != null ? param.kerning : false;
			var indent:Number = param.indent != null ? param.indent : 0;
			var blockIndent:Number = param.blockIndent != null ? param.blockIndent : 0;
			var letterSpacing:Number = param.letterSpacing != null ? param.letterSpacing : 0;
			var leading:Number = param.leading != null ? param.leading : 0;
			var leftMargin:Number = param.leftMargin != null ? param.leftMargin : 0;
			var rightMargin:Number = param.rightMargin != null ? param.rightMargin : 0;
			
			var tff:TextFormat = new TextFormat(font, size, color, bold, italic, underline, null, null, align, leftMargin, rightMargin, indent, leading);
			tff.blockIndent = blockIndent;
			tff.bullet = bullet;
			tff.kerning = kerning;
			tff.letterSpacing = letterSpacing;
			
			var tf:TextField = new TextField();
			tf.defaultTextFormat = tff;
			tf.embedFonts = embed;
			tf.selectable = selectable;
			tf.antiAliasType = antiAlias;
			tf.autoSize = autoSize;
			tf.filters = filters;
			tf.wordWrap = wordWrap;
			tf.text = text;
			return tf;
		}
	}
}
