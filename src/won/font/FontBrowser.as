package won.font
{
	import flash.text.*;	
	import mx.collections.ArrayCollection;	
	import spark.components.ComboBox;
	
	public class FontBrowser extends ComboBox
	{
		
		public function FontBrowser(width:Number = 200, height:Number = 20)
		{
			var font:Font = null;
			this.width = width;
			this.height = height;
			var fonts:Array = Font.enumerateFonts(true).sortOn("fontName");
			var dataList:Array = [];
			
			for each (font in fonts)			
				dataList.push(font.fontName);
			
			var dataCollection:ArrayCollection = new ArrayCollection(dataList);
			
			this.dataProvider = dataCollection;
			this.selectedItem = "Myriad Pro";
		}
	}
}
