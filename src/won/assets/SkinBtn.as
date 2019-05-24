package won.assets
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import mx.containers.*;
	import mx.controls.*;
	import mx.events.*;
	
	import won.events.*;
	
	public class SkinBtn extends PopUpButton
	{
		private var _xml:XML;
		private var _list:XMLList;
		private var _name:String = ""; // chosen name
		private var _url:String = ""; // chosen url
		private var _skinSelected:Boolean = false;
		private var _swfs:Array = [];
		
		private var _thumbWidth:Number = 170;
		private var _thumbHeight:Number = 220;
		private var _thumbMargin:Number = 5;
		private var _thumbContainer:Sprite;
		
		// public functions 
		public function get isSkinSelected() : Boolean{return _skinSelected;}		
		override public function get name() : String{return _name;}		
		public function get url() : String{return _url;}		
		public function reset() : void
		{
			_name = "";
			_url = "";
			_skinSelected = false;
			_swfs = [];
			this.label = "Select Skin";			
		}
		
		// first , load the xml data	
		public function SkinBtn()
		{			
			this.label = "Select Skin";
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			loader.addEventListener(Event.COMPLETE, xmlLoaded);
			loader.load(new URLRequest("skins/skins.xml"));			
		}
		
		// after xml is automatically loaded, set up the click function
		private function xmlLoaded(e:Event) : void
		{
			_xml = new XML(URLLoader(e.target).data);
			_list = this._xml.skin;
			this.enabled = true;
			addEventListener(MouseEvent.CLICK, openBrowser);			
		}
		
		private function openBrowser(event:MouseEvent) : void
		{
			
			
			this.enabled = false;
			
			// create a _thumbContainertainer panel
			var panel:Panel = new Panel();			
			panel.title = "Select Skin";
			panel.width = (_thumbWidth + _thumbMargin) * 3 + 40;			
			panel.height = 320;
			panel.x = (700 - panel.width) /2;
			panel.y = 100;			
			document.addElement(panel);
			
			// create a _thumbContainertainer
			_thumbContainer = new Sprite();
			_thumbContainer.x = 20;
			_thumbContainer.y = 40;
			_thumbContainer.addEventListener(MouseEvent.MOUSE_OVER, thumbMouseOver);
			_thumbContainer.addEventListener(MouseEvent.MOUSE_OUT, thumbMouseOut);
			_thumbContainer.addEventListener(MouseEvent.CLICK, thumbClicked);
			panel.rawChildren.addChild(_thumbContainer);
			
			// mask the container
			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0,0);
			mask.graphics.drawRect(0,0, (_thumbWidth + _thumbMargin) * 3, _thumbHeight);
			mask.x = 20;
			mask.y = 40;
			panel.rawChildren.addChild(mask);
			_thumbContainer.mask = mask;
			
			// get thumbnails of skins
			for (var i:int=0; i<this._list.length(); i++)
			{
				var loader:Loader = new Loader();
				loader.name = i.toString();
				loader.contentLoaderInfo.addEventListener(Event.INIT, setVars);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, skinLoaded);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoading);
				loader.load(new URLRequest("skins/" + _list[i].@url));
				loader.x = _thumbMargin + (_thumbWidth + _thumbMargin) * i;
				loader.y = _thumbMargin;
				loader.mouseChildren = false;
				_thumbContainer.addChild(loader);
				_swfs.push(loader);				
			}
			
			// get scroll bar
			var sbar:HScrollBar = new HScrollBar();
			sbar.width = 200;
			sbar.x = (panel.width - sbar.width) * 0.5 + 10;
			sbar.y = 280;
			sbar.minScrollPosition = 0;
			sbar.maxScrollPosition = 100;
			sbar.lineScrollSize = 20;
			sbar.pageScrollSize = 20;
			sbar.addEventListener(ScrollEvent.SCROLL, scrollThumbnail);
			panel.rawChildren.addChild(sbar);			
			
		}
		
		// when skin is being loaded
		private function onLoading(e:ProgressEvent):void
		{			
			var loadedPercentage:Number = int(e.target.loader.name) / _list.length() + e.bytesLoaded / e.bytesTotal / _list.length();
			dispatchEvent(new LoadingEvent(LoadingEvent.PROGRESS, "Loading Skins..", loadedPercentage, 1));				
		}
		
		// when the thumbnail is hovered
		private function thumbMouseOver(e:MouseEvent):void
		{
			e.target.alpha = 0.8;
		}
		
		// when thumbnail is not hovered
		private function thumbMouseOut(e:MouseEvent):void
		{
			e.target.alpha = 1;
		}
		
		// send out the initial variables to the skin instance		
		private function setVars(e:Event):void
		{
			var skin:* = Object(e.target.loader.content);
			skin.dpi = 50;
			skin.numColumn = 2;
			skin.marginTop = skin.marginBottom = 0.25;				
			skin.marginLeft = skin.marginRight = 0.5;
			skin.headerHeight = 1;
			skin.footerHeight = 0.25;
			skin.drawSkin();
		}
		
		// when skins fully loaded, set its sizes
		private function skinLoaded(e:Event):void
		{	
			e.target.loader.width = 170;
			e.target.loader.height = 220;
			
			if (e.target.loader.name == (_list.length() -1 ))
			{
				dispatchEvent(new LoadingEvent(LoadingEvent.COMPLETE, _list.length() + " skins loaded.."));
			}			
		}
		
		// when skin is clicked
		private function thumbClicked(e:MouseEvent) : void
		{
			var loader:Loader = null;
			_name = _list[e.target.name].@name;
			_url = "skins/" + _list[e.target.name].@url;
			_skinSelected = true;
			this.label = _name;
			this.enabled = true;
			dispatchEvent(new ProcessEvent(ProcessEvent.COMPLETE, "\'" + _name + "\'" + " skin has been chosen.."));
			e.target.parent.parent.parent.removeElement(e.target.parent.parent);
			for each (var swf:* in _swfs)
			{
				swf.unload();
			}		
		}
		
		// scroll function
		private function scrollThumbnail(e:ScrollEvent):void
		{
			if (_list.length() <= 3) return;
			else 
			{
				var x:Number = (_thumbWidth + _thumbMargin) * _list.length() - ( _thumbWidth + _thumbMargin) * 3;
				_thumbContainer.x = 20 - e.target.scrollPosition / 100 * x;
			}
		}
		
		
		private function ioError(event:IOErrorEvent) : void
		{
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: there was a problem reading skins.xml"));
		}
		
	}
}
