package won.assets
{
	import flash.events.*;
	import flash.filesystem.*;
	import flash.net.*;
	
	import mx.utils.ObjectUtil;
	
	import spark.components.Button;
	
	import won.events.*;
	
	public class DataController  extends Button
	{
		private var _isDataProvided:Boolean = false;		
		private var _songdata:Array;
		private var _sortedBy:String = '';
		private var _songdataSorted:Array;
		private var _xml:XML = null;
		private var _list:XMLList = null;
		private var _artistIndex:int = -1;
		private var _titleIndex:int = -1;
		private var _numberIndex:int = -1;
		private var _file:File = null;
		
		public function get isDataProvided():Boolean {return _isDataProvided;}
		public function get songdata():Array {return _songdata;}
		public function get songdataSorted():Array {return _songdataSorted;}
		public function get xml():XML {return _xml;}
		public function get list():XMLList {return _list;}
		public function get artistIndex():int {return _artistIndex;}
		public function get titleIndex():int {return _titleIndex;}
		public function get numberIndex():int {return _numberIndex;}
		public function get sortedBy():String {return _sortedBy;}
		public function get file():File {return _file;}
		
		public function DataController()
		{
			_songdata = [];
			_songdataSorted = [];
			this.label = "Select XML Data";
			this.addEventListener(MouseEvent.CLICK, this.openBrowser);	
			
		}
		
		// Public Methods
		public function reset() : void
		{
			_isDataProvided = false;
			_sortedBy = '';
			_songdata = [];	
			_songdataSorted = [];
			_xml = null;
			_list = null;
			_artistIndex = -1;
			_titleIndex = -1;
			_numberIndex = -1;
			this.enabled = true;
			this.label = "Select XML Data";			
		}
		
		public function sort(by:String) : void
		{
			_songdataSorted = [];
			
			// copy the songdata to new songdataSorted array
			for each (var song:Object in _songdata) 			
				_songdataSorted.push(song);			
			
			// sort accordingly
			if (by == "title")
			{
				_songdataSorted.sortOn(["title", "artist", "number"]);
				_sortedBy = "title"; 
			}
			
			else if (by == "artist")
			{
				_songdataSorted.sortOn(["artist", "title", "number"]);
				_sortedBy = "artist";
			}
			
			else
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: sort must be done by either title or artist"));		
			
		}
		
		public function getSongData(sort:Boolean, sortBy:String = ''):Array
		{			
			if (!sort) // if you dont have to sort
				return _songdata;	
			
			else // if you have to sort,
			{				
				// if the sorted data already exists
				if (_sortedBy != '')
				{
					// if sorted requested is title and theres already title sorted data, just return the sorteddata
					if (_sortedBy == "title" && sortBy == "title")				
						return _songdataSorted;	
						
						// if sorted requested is artist and theres already artist sorted data, just return the data
					else if (_sortedBy == "artist" && sortBy == "artist")				
						return _songdataSorted;
						
						// sort accordingly
					else  
					{					
						this.sort(sortBy);
						return _songdataSorted;
					}				
				}
					// if the sorted data doesnt exist 
				else 
				{
					this.sort(sortBy);
					return _songdataSorted;
				}
			}
		}
		
		
		
		private function openBrowser(e:MouseEvent) : void
		{
			reset();	
			
			// disable the button
			this.enabled = false;
			
			// reset the data
			_isDataProvided = false;
			
			var f:File = new File();
			f.addEventListener(Event.CANCEL, xmlCanceled);
			f.addEventListener(Event.SELECT, xmlSelected);
			f.browseForOpen("Songbook Data", [new FileFilter("songbook xml", "*.xml")]);
			
		}
		
		private function xmlCanceled(event:Event) : void
		{
			default xml namespace = new Namespace("urn:schemas-microsoft-com:office:spreadsheet");
			this.enabled = true;			
		}
		
		private function xmlSelected(e:Event = null) : void
		{
			var f:File = File(e.target);
			this.label = f.name;
			_file = f;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, xmlLoaded);
			loader.addEventListener(ProgressEvent.PROGRESS, xmlLoading);
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, e.text));
			});
			
			loader.load(new URLRequest(f.url));			
			
		}
		
		private function xmlLoading(e:ProgressEvent) : void
		{
			default xml namespace = new Namespace("urn:schemas-microsoft-com:office:spreadsheet");
			dispatchEvent(new LoadingEvent(LoadingEvent.PROGRESS, "Loading XML Data..", e.bytesLoaded, e.bytesTotal));			
		}
		
		private function xmlLoaded(e:Event = null) : void
		{
			dispatchEvent(new LoadingEvent(LoadingEvent.COMPLETE, "Loading XML Data Completed.."));
			
			// read XML
			default xml namespace = new Namespace("urn:schemas-microsoft-com:office:spreadsheet");
			
			// try if the xml is in right format
			try
			{
				_xml = XML(e.target.data);
				_list = _xml..Row;				
				dispatchEvent(new ProcessEvent(ProcessEvent.COMPLETE));				
			}
			catch (e:Error)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: XML file is invalid.\rChoose another xml data."));
				this.enabled = true;
				this.label = "Choose another xml data";
				return;
			}
			
			// try if the xml data has valid index row
			try
			{
				var indexRow:XMLList = _list[0].Cell;				
				for (var i:int=0; i<indexRow.length(); i++)
				{
					var curIndex:String = String(indexRow[i].Data).toLowerCase();
					if (curIndex == 'artist')
						_artistIndex = i;
					else if (curIndex == 'title')
						_titleIndex = i;
					else if (curIndex == 'number')
						_numberIndex = i;
					//else {
						//dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: error while parsing index row."));
						//return;
					//}
				}			
			}
			catch (e:Error)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: XML file is either empty or invalid.\rChoose another xml data."));
				this.enabled = true;
				this.label = "Choose another xml data";
				return;
			}			
			if (_artistIndex == -1 || _titleIndex == -1 || _numberIndex == -1)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: XML data contains invalid headings. \rThe first row must have \'artist\',\'title\',\'number\' headings.\rChoose another xml data."));
				this.enabled = true;
				this.label = "Choose another xml data";
				return;
			}
						
			// parse Data and save it to songdata array
			var song:Object;		
			var errors:Array = new Array();
			for (i=1; i<_list.length(); i++)
			{
				// if the row has an error, add it to error number and move on
				if (!_list[i].Cell[_titleIndex] || !_list[i].Cell[_artistIndex] || !_list[i].Cell[_numberIndex])				
					errors.push(i);
				
				else 
				{				
					song = new Object();				
					song.title = _list[i].Cell[_titleIndex].Data;
					song.artist = _list[i].Cell[_artistIndex].Data;
					song.number = _list[i].Cell[_numberIndex].Data;
					_songdata.push(song);
				}
			}
			
			if (errors.length > 0)
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: Listed row(s) have a missing field. \rPlease check your data. If you are OK with this error, continue. The missing rows will be skipped upon songbook creation. \r{"+errors.join(', ')+"}"));
							
			
			_isDataProvided = true;			
			dispatchEvent(new ProcessEvent(ProcessEvent.COMPLETE, this.label + " has been chosen.."));
			
		}
		
		
	}
}
