package won.assets
{
	import flash.events.*;
	import flash.filesystem.*;
	import flash.net.*;	
	import won.events.*;
	import spark.components.Button;
	
	public class XmlBtn extends Button
	{
		public var isDataProvided:Boolean = false;
		public var songdata:Array;
		public var xml:XML = null;
		public var list:XMLList = null;
		public var artistIndex:int = -1;
		public var titleIndex:int = -1;
		public var numberIndex:int = -1;
		
		public function XmlBtn()
		{
			this.songdata = [];
			this.label = "Select XML Data";
			this.addEventListener(MouseEvent.CLICK, this.openBrowser);			
		}
		
		// Public Methods
		public function reset() : void
		{
			this.isDataProvided = false;
			this.songdata = [];
			this.xml = null;
			this.list = null;
			this.artistIndex = -1;
			this.titleIndex = -1;
			this.numberIndex = -1;
			this.label = "Select XML Data";			
		}
		
		public function sort(by:String) : void
		{
			if (by == "title")
			{
				this.songdata.sortOn(["title", "artist", "number"]);
			}
			else if (by == "artist")
			{
				this.songdata.sortOn(["artist", "title", "number"]);
			}
			else if (by == "none")
			{
				// do not sort the song data
			}
			else
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: sort must be done by either title or artist"));
			}
			return;
		}
		
		
		
		private function openBrowser(e:MouseEvent) : void
		{
			// disable the button
			this.enabled = false;
			
			// reset the data
			this.isDataProvided = false;
			
			var f:File = new File();
			f.addEventListener(Event.CANCEL, this.xmlCanceled);
			f.addEventListener(Event.SELECT, this.xmlSelected);
			f.browseForOpen("Songbook Data", [new FileFilter("songbook xml", "*.xml")]);
			
		}
		
		private function xmlCanceled(event:Event) : void
		{
			default xml namespace = new Namespace("urn:schemas-microsoft-com:office:spreadsheet");
			this.enabled = true;			
		}
		
		private function xmlSelected(e:Event) : void
		{
			var f:File = File(e.target);
			this.label = f.name;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, this.xmlLoaded);
			loader.addEventListener(ProgressEvent.PROGRESS, this.xmlLoading);
			loader.load(new URLRequest(f.nativePath));
			
		}
		
		private function xmlLoading(e:ProgressEvent) : void
		{
			default xml namespace = new Namespace("urn:schemas-microsoft-com:office:spreadsheet");
			dispatchEvent(new LoadingEvent(LoadingEvent.PROGRESS, "Loading XML Data..", e.bytesLoaded, e.bytesTotal));			
		}
		
		private function xmlLoaded(e:Event) : void
		{
			dispatchEvent(new LoadingEvent(LoadingEvent.COMPLETE, "Loading XML Data Completed.."));
			default xml namespace = new Namespace("urn:schemas-microsoft-com:office:spreadsheet");
			try
			{
				this.xml = XML(e.target.data);
				this.list = this.xml..Row;
			}
			catch (e:Error)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: XML file is invalid.\rChoose another xml data."));
				this.enabled = true;
				this.label = "Choose another xml data";
				return;
			}
			
			
			
			/*
			
				while (i < this.list[0].Cell.length())
				{
					
					switch(String(this.list[0].Cell[i].Data).toLowerCase())
					{
						case "artist":
						{
							this.artistIndex = i;
							break;
						}
						case "title":
						{
							this.titleIndex = i;
							break;
						}
						case "number":
						{
							this.numberIndex = i;
							break;
						}
						default:
						{
							break;
						}
					}
					i = (i + 1);
				}
			}
			catch (e:Error)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: XML file is either empty or invalid.\rChoose another xml data."));
				this.enabled = true;
				this.label = "Choose another xml data";
				return;
			}
			if (this.artistIndex == -1 || this.titleIndex == -1 || this.numberIndex == -1)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: XML data contains invalid headings. \rThe first row must have \'artist\',\'title\',\'number\' headings.\rChoose another xml data."));
				this.enabled = true;
				this.label = "Choose another xml data";
				return;
			}
			this.parseData();
			return;
			*/
		}
	}
}
