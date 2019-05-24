package won.page
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	
	import skins.metalicBW.Alphabet;
	
	import won.events.*;
	import won.font.*;
	import won.math.Wonmath;
	
	public class Page extends MovieClip
	{
		private var _totalPages:int;
		private var _pages:Array;
		private var _list:Array;
		private var _dpi:int;
		private var _titleIndex:int;
		private var _numberIndex:int;
		private var _artistIndex:int;
		private var _skinURL:String;
		private var _type:String;
		private var _isGrid:Boolean;
		private var _gridColor:uint;
		private var _numRows:int;
		private var _numColumns:int;
		private var _headerHeight:Number;
		private var _footerHeight:Number;
		private var _marginTop:Number;
		private var _marginBottom:Number;
		private var _marginLeft:Number;
		private var _marginRight:Number;
		private var _headerText:String;
		private var _headerFont:String;
		private var _headerColor:uint;
		private var _headerSize:Number;
		private var _descFont:String;
		private var _descColor:uint;
		private var _descSize:Number;
		private var _titleFont:String;
		private var _titleColor:uint;
		private var _titleSize:Number;
		private var _artistFont:String;
		private var _artistColor:uint;
		private var _artistSize:Number;
		private var _numberFont:String;
		private var _numberColor:uint;
		private var _numberSize:Number;
		private var _footerLeftText:String;
		private var _footerLeftFont:String;
		private var _footerLeftColor:uint;
		private var _footerLeftSize:Number;
		private var _footerRightText:String;
		private var _footerRightFont:String;
		private var _footerRightColor:uint;
		private var _footerRightSize:Number;
		private var _alphabetHeight:Number;
		private var _byFont:String;
		private var _byColor:uint;
		private var _bySize:Number;
		private var _gridSize:Number = 0.005;
		private var _pageNumber:int;
		private var _counter:int = 0;
		private var _skin:Object;
		private var _loadingMsg:String;
		private var _curColumnHeight:Number = 0;
		private var _curAlphabet:String = "";
		private var _curArtist:String = "";
		private var _curPageCount:int = 0;
		private var _curColumnCount:int = 0;
		private var _curRowCount:int = 0;
		private var _timer:Timer;
		private var _isAlphabet:Boolean;
		
		public function get totalPages():int {return _totalPages;}
		public function get pages():Array {return _pages;}
			
		
		// main method
		public function Page(dpi:int, pageNumber:int)
		{
			_pages = [];
			_dpi = dpi;
			_pageNumber = pageNumber;
			_loadingMsg = "Creating page " + _pageNumber;
			addEventListener(Event.REMOVED, removed);			
			_timer = new Timer(100);
			_timer.start();
			
		}
		
		override public function stop() : void
		{
			removed();			
		}
		
		private function removed(e:Event = null) : void
		{
			if (_timer != null)			
				_timer.reset();
			
			_timer = null;
		}		
		
		// draw starting
		public function draw(songData:Array, titleIndex:int, numberIndex:int, artistIndex:int, skinURL:String, type:String, alphabet:Boolean, isGrid:Boolean, gridColor:uint, 
							 numRows:int, numColumns:int, headerHeight:Number, footerHeight:Number, marginTop:Number, marginBottom:Number, marginLeft:Number, marginRight:Number, 
							 headerText:String, headerFont:String, headerColor:uint, headerSize:Number, 
							 descriptionFont:String, descriptionColor:uint, descriptionSize:Number, 
							 titleFont:String, titleColor:uint, titleSize:Number, 
							 artistFont:String, artistColor:uint, artistSize:Number, 
							 numberFont:String, numberColor:uint, numberSize:Number, 
							 footerLeftText:String, footerLeftFont:String, footerLeftColor:uint, footerLeftSize:Number, 
							 footerRightText:String, footerRightFont:String, footerRightColor:uint, footerRightSize:Number, 
							 byFont:String, byColor:uint, bySize:Number, pages:Array) : void
		{
			dispatchEvent(new ProcessEvent(ProcessEvent.INIT, _loadingMsg));
			dispatchEvent(new LoadingEvent(LoadingEvent.PROGRESS, _loadingMsg, 0, 1));
			
			// check for errors
			if (isNaN(marginTop)){			
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: Top Margin is invalid"));
				return;
			}
			if (isNaN(marginBottom))
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: Bottom Margin is invalid"));
				return;
			}
			if (isNaN(marginLeft))
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: Left Margin is invalid"));
				return;
			}
			if (isNaN(marginRight))
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: Right Margin is invalid"));
				return;
			}
			if (isNaN(headerHeight))
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: Heading Height is invalid"));
				return;
			}
			if (isNaN(footerHeight))
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error: Footer Height is invalid"));
				return;
			}
			
			// register variables
			_list = songData;
			_artistColor = artistColor;
			_artistFont = artistFont;
			_artistIndex = artistIndex;
			_artistSize = artistSize;
			_descColor = descriptionColor;
			_descFont = descriptionFont;
			_descSize = descriptionSize;
			_footerHeight = footerHeight;
			_footerLeftColor = footerLeftColor;
			_footerLeftFont = footerLeftFont;
			_footerLeftSize = footerLeftSize;
			_footerLeftText = footerLeftText;
			_footerRightColor = footerRightColor;
			_footerRightFont = footerRightFont;
			_footerRightSize = footerRightSize;
			_footerRightText = footerRightText;
			_gridColor = gridColor;
			_headerColor = headerColor;
			_headerFont = headerFont;
			_headerHeight = headerHeight;
			_headerSize = headerSize;
			_headerText = headerText;
			_isGrid = isGrid;
			_marginBottom = marginBottom;
			_marginLeft = marginLeft;
			_marginRight = marginRight;
			_marginTop = marginTop;
			_numberColor = numberColor;
			_numberFont = numberFont;
			_numberIndex = numberIndex;
			_numberSize = numberSize;
			_numColumns = numColumns;
			_numRows = numRows;
			_skinURL = skinURL;
			_titleColor = titleColor;
			_titleFont = titleFont;
			_titleIndex = titleIndex;
			_titleSize = titleSize;
			_type = type;
			_byFont = byFont;
			_byColor = byColor;
			_bySize = bySize;
			_pages = pages;
			_isAlphabet = alphabet;
					
			// load skin, send variables at init, and go to skinloaded after loaded
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, sendVars);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, skinLoading);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, skinLoaded);
			loader.load(new URLRequest(_skinURL));		
		}
		
		
		private function sendVars(e:Event) : void
		{
			// send initial variables to the skin swf, and let it draw the skin
			var skin:Object = Object(e.target.loader.content);
			skin.dpi = _dpi;
			skin.numColumn = _numColumns;
			skin.marginTop = _marginTop;
			skin.marginBottom = _marginBottom;
			skin.marginLeft = _marginLeft;
			skin.marginRight = _marginRight;
			skin.headerHeight = _headerHeight;
			skin.footerHeight = _footerHeight;
			// after set initial variables, let it draw skin, after skin is drew, it will trigger complete event for skinLoaded function
			skin.drawSkin();			
		}		
		
		private function skinLoading(e:ProgressEvent) : void
		{
			var loaded:Number = e.bytesLoaded / e.bytesTotal * 0.1;			
			dispatchEvent(new LoadingEvent(LoadingEvent.PROGRESS, _loadingMsg, loaded, 1));			
		}
		
		// add skin to the page instance
		private function skinLoaded(e:Event) : void
		{
			var skinLoader:Loader = Loader(e.target.loader);
			skinLoader.width = _dpi * 8.5;
			skinLoader.height = _dpi * 11;			
			addChild(skinLoader);
			_skin = Object(skinLoader.content);
			_alphabetHeight = _skin.alphabetHeight;
			
			// start the page drawing 
			if (_timer != null)			
				_timer.addEventListener(TimerEvent.TIMER, drawPage);
						
		}
		
		// after skins loaded, draw page
		private function drawPage(e:TimerEvent) : void
		{
			_timer.removeEventListener(TimerEvent.TIMER, drawPage);
			_counter = 0;		
						
			/*if (_pages.length == 0)
			{
				_pages.push(new Array());
				_pages[0].push(new Array());
				_timer.addEventListener(TimerEvent.TIMER, parseData);
			}
			
			else 
			{
				//_timer.addEventListener(TimerEvent.TIMER, parseData);
				_timer.addEventListener(TimerEvent.TIMER, writeHeader);
			}*/
			
			_pages = [];
			var newPage:Array = [];
			var newColumn:Array = [];
			_pages.push(newPage);
			_pages[0].push(newColumn);
			_timer.addEventListener(TimerEvent.TIMER, parseData);
			
		}
		
			
		// read data and save them into the 'pages' array for cache use
		private function parseData(event:TimerEvent) : void
		{	
			var alpha:Boolean = false; 
			var thread:int = 1000; 
			var loopTil:int = _counter + thread; // need this to stop the looping     
			var bodyHeight:Number = 11 - _marginTop - _marginBottom - _headerHeight - _footerHeight;		
			
			
			
			while (_counter < loopTil)
			{				
				var loadingPercent:Number = 0.1 + _counter / _list.length * 0.3;				
				dispatchEvent(new LoadingEvent(LoadingEvent.PROGRESS, "Parsing Data..", loadingPercent, 1));
				
				// when done reading data, start drawing the page starting from header, trigger the pageevent so main can grab the cached pages array	
				if (_counter == _list.length) 			
				{
					_timer.removeEventListener(TimerEvent.TIMER, parseData);
					_counter = 0;
										
					_timer.addEventListener(TimerEvent.TIMER, writeHeader);
					dispatchEvent(new PageEvent(PageEvent.COMPLETE));
					
					return;					
				}
				
				alpha = (_type == 'title') ? isAlphabet(_list[_counter].title) : isAlphabet(_list[_counter].artist);
				var rowHeight:Number = (_isAlphabet && alpha) ? bodyHeight / _numRows + _skin.alphabetHeight : bodyHeight / _numRows;
				
				if ( Wonmath.precise(_curColumnHeight+rowHeight) > bodyHeight)	{				
					getNextColumn();
					
				}
				
				var thisPage:Array = new Array();
				thisPage[0] = (alpha) ? _curAlphabet : "";
				
				if (_type == 'artist') // artist 
				{
					thisPage[1] = ( _list[_counter].artist == _curArtist ) ? "" : _list[_counter].artist;
					thisPage[2] = _list[_counter].number;
					thisPage[3] = _list[_counter].title;
				}
				
				else // title
				{
					thisPage[1] = _list[_counter].title;
					thisPage[2] = _list[_counter].number;
					thisPage[3] = _list[_counter].artist;
				}
				
				_pages[_curPageCount][_curColumnCount].push(thisPage);
				_curArtist = _list[_counter].artist;				
				
				_curRowCount++;				
				_curColumnHeight = Wonmath.precise(_curColumnHeight+rowHeight);
				_counter++;				
			}		
			
			
		}		
		
		
		private function getNextColumn() : void
		{			
			_curColumnHeight = 0;
			_curRowCount = 0;
			
			_curColumnCount++;
			
			// if all columns are filled, go to next page
			if (_curColumnCount == _numColumns)
			{
				_curPageCount++;				
				_curColumnCount = 0;
				var newPage:Array = [];
				_pages.push(newPage);
			}
			
			var newColumn:Array = [];
			_pages[_curPageCount].push(newColumn);
		}
		
		
		
		
		private function isAlphabet(str:String) : Boolean
		{
			if (!_isAlphabet)
				return false;
						
			var firstLetter:String = str.toLowerCase().substr(0, 1);
				
			// if its a-z
			if (firstLetter.search(/[a-z]/) != -1) 
			{
				if (_curAlphabet.toLowerCase() != firstLetter)
				{
					_curAlphabet = firstLetter.toUpperCase();
					return true;
				}
				else				
					return false;				
			}
			
			// if its not a-z and "#" is not assigned
			else if (_curAlphabet == "")
			{
				_curAlphabet = "#";
				return true;
			}		
			
			else			
				return false;					
		}
		
		
		private function dump_list():void
		{
			for (var i:* in _pages) {
				for (var y:* in _pages[i]){
					for (var z:* in _pages[i][y]){
						trace ("pages["+i+"]["+y+"]["+z+"] :"+pages[i][y][z][1]+", "+pages[i][y][z][3]);
					}
				}
			}
		}
			
		
		private function writeHeader(event:TimerEvent) : void
		{		
			_totalPages = _pages.length;
			if (_pageNumber > _totalPages)			
				_pageNumber = _totalPages;
			
			// dispatch loading event
			var percLoaded:Number = 0.4 + _counter / 1 * 0.05;
			dispatchEvent(new LoadingEvent(LoadingEvent.PROGRESS, _loadingMsg, percLoaded, 1));
			
			// when dont writing header, move on to description
			if (_counter > 0)
			{
				_timer.removeEventListener(TimerEvent.TIMER, writeHeader);
				_counter = 0;
				_timer.addEventListener(TimerEvent.TIMER, writeDescription);
				return;
			}
			
			var headerTf:TextField = Text.write(_headerText, {size:dpiSize(_headerSize), color:_headerColor, font:_headerFont});
			var headerImg:Sprite = bitmapText(headerTf);
			var headerSize:Array = [toPixel(8.5-_marginLeft-_marginRight) , toPixel(_headerHeight*_skin.headerRatio[0])]; // width, height
			
			headerImg.x = toPixel(_marginLeft);
			headerImg.x = headerImg.x + (headerSize[0] - headerImg.width) * 0.5;
			headerImg.y = toPixel(_marginTop);
			headerImg.y = headerImg.y + (headerSize[1] - headerImg.height) * 0.5;
			
			var byText:String = (_type == "title") ? "BY TITLE" : "BY ARTIST";
			var byTf:TextField = Text.write(byText, {size:dpiSize(_bySize), color:_byColor, font:_byFont});
			var byImg:Sprite = bitmapText(byTf);
			
			byImg.x = toPixel(_marginLeft + 0.1);
			byImg.y = toPixel(_marginTop) + (headerSize[1] - byImg.height)*0.5;
			
			addChild(headerImg);			
			addChild(byImg);
			
			_counter++;	
		}
		
		private function writeDescription(event:TimerEvent) : void
		{
			var percLoaded:Number = 0.45 + _counter / _numColumns * 0.05;
			dispatchEvent(new LoadingEvent(LoadingEvent.PROGRESS, _loadingMsg, percLoaded, 1));
			
			// if writing description area for al of the columns, move on to the next
			if (_counter == _numColumns)
			{
				_timer.removeEventListener(TimerEvent.TIMER, writeDescription);
				_counter = 0;
				_curColumnCount = 0;
				_curRowCount = 0;
				_curColumnHeight = 0;
				
				// just enable this here, so when event is dispatched from writecontent, it can go to alphabetLoaded
				_skin.addEventListener(Event.COMPLETE, alphabetLoaded);				
				
				createGrid();				
				return;
			}
			
			var rowOneText:String = (_type == "title") ? "TITLE" : "ARTIST";
			var rowThreeText:String = (_type == "title") ? "ARTIST" : "TITLE";
			var columnGap:Number = toPixel(_skin.columnGap);
			var posY:Number = toPixel(_marginTop + _headerHeight * _skin.headerRatio[0]);
			var posX:Number = toPixel(_marginLeft);
			var columnWidth:Number = toPixel((8.5 - _marginLeft - _marginRight - _skin.columnGap * (_numColumns-1)) / _numColumns)
			var columnHeight:Number = toPixel(_headerHeight * _skin.headerRatio[1]);
			
			var rowOneTf:TextField = Text.write(rowOneText, {size:dpiSize(_descSize), color:_descColor, font:_descFont});
			var rowOne:Sprite = bitmapText(rowOneTf);
			rowOne.x = posX + (columnGap + columnWidth) * _counter;
			rowOne.x += (columnWidth * _skin.columnRatio[0] - rowOne.width) * 0.5;
			rowOne.y = posY + (columnHeight - rowOne.height) * 0.5;
			
			var rowTwoTf:TextField = Text.write("NUMBER", {size:dpiSize(_descSize), color:_descColor, font:_descFont});
			var rowTwo:Sprite = bitmapText(rowTwoTf);
			rowTwo.x = posX + columnWidth * _skin.columnRatio[0] + (columnGap + columnWidth) * _counter;
			rowTwo.x == (columnWidth * _skin.columnRatio[1] - rowTwo.width) * 0.5;
			rowTwo.y = posY + (columnHeight - rowTwo.height) * 0.5;
						
			var rowThreeTf:TextField = Text.write(rowThreeText, {size:dpiSize(_descSize), color:_descColor, font:_descFont});
			var rowThree:Sprite = bitmapText(rowThreeTf);
			rowThree.x = posX + columnWidth * (_skin.columnRatio[0] + _skin.columnRatio[1]) + (columnGap + columnWidth) * _counter;
			rowThree.x += (columnWidth * _skin.columnRatio[2] - rowThree.width) * 0.5;
			rowThree.y = posY + (columnHeight - rowThree.height) * 0.5;
			
			addChild(rowOne);
			addChild(rowTwo);
			addChild(rowThree);
			
			_counter++;			
		}
		
		/*  this method is for : while looping writeContent, if theres a request for drawAlphabet, the writeContent will temporarily stop the loop
			and this function will be triggered when the alphabet is generated, then this function can resume the writeContent */
		private function alphabetLoaded(event:Event) : void
		{
			_timer.addEventListener(TimerEvent.TIMER, writeContent);
			
		}
		
		
		private function createGrid() : void
		{
			if (_isGrid)
			{
				var size:Number = toPixel(_gridSize);
				var margins:Object = {top:toPixel(_marginTop), left:toPixel(_marginLeft), right:toPixel(_marginRight), bottom:toPixel(_marginBottom)};
				var columnGap:Number = toPixel(_skin.columnGap);
				var columnWidth:Number = toPixel( (8.5 - _marginLeft - _marginRight - _skin.columnGap * (_numColumns - 1)) / _numColumns );
				var columnHeight:Number = toPixel( 11 - _marginTop - _marginBottom - _headerHeight - _footerHeight );
				var headHeight:Number = toPixel(_headerHeight);
				var footHeight:Number = toPixel(_footerHeight);
				
				// for each columns
				for (var i:int=0; i< _numColumns ; i++)
				{
					// far left grid
					var leftGrid:Shape = new Shape();
					leftGrid.graphics.beginFill(_gridColor);
					leftGrid.graphics.drawRect(0,0,size, columnHeight+size*2);
					leftGrid.graphics.endFill();
					leftGrid.x = margins.left + (columnWidth+columnGap)*i - size;
					leftGrid.y = margins.top + headHeight - size;
					
					// mid left grid
					var centerLeftGrid:Shape = new Shape();
					centerLeftGrid.graphics.beginFill(_gridColor);
					centerLeftGrid.graphics.drawRect(0,0, size, columnHeight+size*2);
					centerLeftGrid.graphics.endFill();
					centerLeftGrid.x = margins.left + columnWidth * _skin.columnRatio[0] + (columnWidth+columnGap) * i;
					centerLeftGrid.y = margins.top + headHeight - size;
					
					// mid right grid
					var centerRightGrid:Shape = new Shape();
					centerRightGrid.graphics.beginFill(_gridColor);
					centerRightGrid.graphics.drawRect(0,0, size, columnHeight + size*2 );
					centerRightGrid.graphics.endFill();
					centerRightGrid.x = margins.left + columnWidth*(_skin.columnRatio[0]+_skin.columnRatio[1]) + (columnWidth+columnGap) * i - size;
					centerRightGrid.y = margins.top + headHeight - size;
					
					// far right grid
					var rightGrid:Shape = new Shape();
					rightGrid.graphics.beginFill(_gridColor);
					rightGrid.graphics.drawRect(0,0, size, columnHeight + size*2);
					rightGrid.graphics.endFill();
					rightGrid.x = margins.left + columnWidth + (columnWidth+columnGap)*i;
					rightGrid.y = margins.top + headHeight - size;
					
					// top grid
					var topGrid:Shape = new Shape();
					topGrid.graphics.beginFill(_gridColor);
					topGrid.graphics.drawRect(0,0, columnWidth+size*2, size);
					topGrid.graphics.endFill();
					topGrid.x = margins.left + (columnWidth+columnGap)*i - size;
					topGrid.y = margins.top + headHeight - size;
					
					// bottom grid
					var bottomGrid:Shape = new Shape();
					bottomGrid.graphics.beginFill(_gridColor);
					bottomGrid.graphics.drawRect(0,0, columnWidth + size*2, size);
					bottomGrid.graphics.endFill();
					bottomGrid.x = margins.left + (columnWidth+columnGap)*i - size;
					bottomGrid.y = margins.top + headHeight + columnHeight + size;
					
					addChild(leftGrid);
					addChild(centerLeftGrid);
					addChild(centerRightGrid);
					addChild(rightGrid);
					addChild(topGrid);
					addChild(bottomGrid);
				}			
				
			}		
			
			
			_timer.addEventListener(TimerEvent.TIMER, writeContent);			
		}
		
		
				
		
		
		private function writeContent(event:TimerEvent) : void
		{			
			var threadCount:Number = 100; // thread for psuedo threading
			var loopAmt:Number = _counter + threadCount; // add this to the _counter so it would end the loop without skipping
			var contentHeight:Number = toPixel(11 - _marginTop - _marginBottom - _headerHeight - _footerHeight);
			var alphabetHeight:Number = toPixel(_skin.alphabetHeight);
			var rowHeight:Number = contentHeight / _numRows;
			var margins:Object = {top:toPixel(_marginTop), right:toPixel(_marginRight), bottom:toPixel(_marginBottom), left:toPixel(_marginLeft)};
			var columnGap:Number = toPixel(_skin.columnGap);
			var columnWidth:Number = toPixel((8.5 - _marginLeft - _marginRight - _skin.columnGap * (_numColumns - 1)) / _numColumns);
			var headerHeight:Number = toPixel(_headerHeight);
			var leftFieldWidth:Number = columnWidth * _skin.columnRatio[0];
			var midFieldWidth:Number = columnWidth * _skin.columnRatio[1];
			var rightFieldWidth:Number = columnWidth * _skin.columnRatio[2];
			var fieldMargin:Number = toPixel(0.05);
			var gridSize:Number = toPixel(_gridSize);
			var type:String = _type;			
			
			// for the thread amount,
			while (_counter < loopAmt)
			{				
				// dispatch loading event	
				var percentLoaded:Number = 0.5 + (_curColumnCount / _numColumns + _counter / _pages[(_pageNumber - 1)][_curColumnCount].length / _numColumns) * 0.45;
				dispatchEvent(new LoadingEvent(LoadingEvent.PROGRESS, _loadingMsg, percentLoaded, 1));
				
				// if this is last of the page
				if (_counter >= _pages[(_pageNumber - 1)][_curColumnCount].length)
				{
					// remove this event listener to stop the loop
					_timer.removeEventListener(TimerEvent.TIMER, writeContent);
					_counter = 0;
					
					// if this is the last one, go to write footer
					if (_curColumnCount >= (_pages[(_pageNumber - 1)].length - 1))
					{
						_counter = 0;
						_timer.addEventListener(TimerEvent.TIMER, writeFooter);
					}
					// if this is not the last column, move on to the next column 
					else
					{
						_curColumnCount++;
						_curColumnHeight = 0;
						_timer.addEventListener(TimerEvent.TIMER, writeContent);
					}
					return;
				}
				
				
				
				// else		
				var rowArray:Array = _pages[(_pageNumber - 1)][_curColumnCount][_counter];				
				var row:Object = {alphabet:rowArray[0], left:rowArray[1], mid:rowArray[2], right:rowArray[3]};				
				// ex : left:title, mid:number, right:artist				
				
				
				// create the row's sprite
				var rowImg:Sprite = new Sprite();
				rowImg.x = margins.left + (columnWidth + columnGap) * _curColumnCount;
				rowImg.y = margins.top + headerHeight + _curColumnHeight;
							
				
				// create left field text 
			
				var leftFieldTf:TextField = (type == 'title')? 		
					Text.write(row.left, {size:dpiSize(_titleSize), color:_titleColor, font:_titleFont} ) :
					Text.write(row.left, {size:dpiSize(_artistSize), color:_artistColor, font:_artistFont} );	
				
				var leftFieldImg:Sprite = bitmapText(leftFieldTf);
				
				// shrink the size if the width exceed the limit of the width
				if (leftFieldImg.width > leftFieldWidth - fieldMargin * 2)				
					leftFieldImg.width = leftFieldWidth - fieldMargin * 2;								
				
				leftFieldImg.x = fieldMargin;
				leftFieldImg.y = (rowHeight - leftFieldImg.height) * 0.5;
								
				
				// if the row contains the heading alphabet, leave the space for the alphabet
				
				if (row.alphabet != "")				
					leftFieldImg.y += alphabetHeight;
				
				rowImg.addChild(leftFieldImg);
								
				// create mid field text 
			
				var midFieldTf:TextField = Text.write(row.mid, {size:dpiSize(_numberSize), color:_numberColor, font:_numberFont});
				var midFieldImg:Sprite = bitmapText(midFieldTf);
				
				// shrink the size if the width exceed the limit of the width
				if (midFieldImg.width > midFieldWidth - fieldMargin)				
					midFieldImg.width = midFieldWidth - fieldMargin;
				
				midFieldImg.x = leftFieldWidth + (midFieldWidth - midFieldImg.width) / 2;
				midFieldImg.y = (rowHeight - midFieldImg.height) * 0.5;
				
				// if the row contains the heading alphabet, leave the space for the alphabet				
				if (row.alphabet != "")				
					midFieldImg.y += alphabetHeight;
				
				rowImg.addChild(midFieldImg);
				
				// create right field text 
			
				var rightFieldTf:TextField = (type == "title") ? 
					Text.write(row.right, {size:dpiSize(_artistSize), color:_artistColor, font:_artistFont}) : 
					Text.write(row.right, {size:dpiSize(_titleSize), color:_titleColor, font:_titleFont});
				
				var rightFieldImg:Sprite = bitmapText(rightFieldTf);
				
				// shrink the size if the with exceed the limit of the width
				if (rightFieldImg.width > rightFieldWidth - fieldMargin * 2)				
					rightFieldImg.width = rightFieldWidth - fieldMargin * 2;
				
				rightFieldImg.x = leftFieldWidth + midFieldWidth + fieldMargin;
				rightFieldImg.y = (rowHeight - rightFieldImg.height) * 0.5;
				
				// if the row contains the heading alphabet, leave the space for the alphabet
				if (row.alphabet != "")				
					rightFieldImg.y += alphabetHeight;
				
				rowImg.addChild(rightFieldImg);
				
				// add the row
				addChild(rowImg);
								
				_curColumnHeight = _curColumnHeight + rowHeight;
				
				_counter++;
								
				// add grid if grid is enabled 
				
				if (_isGrid)
				{
					// left field, if title	, draw the grid at the bottom of the title box			
					if (type == "title")
					{						
						var titleGrid:Shape = new Shape();
						titleGrid.graphics.beginFill(_gridColor);
						titleGrid.graphics.drawRect(0, 0, leftFieldWidth, gridSize);
						titleGrid.graphics.endFill();
						titleGrid.y = (row.alphabet != "") ? rowHeight + alphabetHeight : rowHeight;
						rowImg.addChild(titleGrid);
					}
					// left field, if artist and a new artist (not the same artist with previous artist, and doesn't contain a new alphabet)
					// draw the grid at the top of the artist box
					else if (row.left != "" && row.alphabet == "")
					{
						var artistGrid:Shape = new Shape();
						artistGrid.graphics.beginFill(_gridColor);
						artistGrid.graphics.drawRect(0, 0, leftFieldWidth, gridSize);
						artistGrid.graphics.endFill();
						rowImg.addChild(artistGrid);
					}
									
					var fieldGrid:Shape = new Shape();
					fieldGrid.graphics.beginFill(_gridColor);
					fieldGrid.graphics.drawRect(0, 0, midFieldWidth + rightFieldWidth, gridSize);
					fieldGrid.graphics.endFill();
					fieldGrid.x = leftFieldWidth;
					fieldGrid.y = (row.alphabet != "") ? rowHeight + alphabetHeight : rowHeight;
					rowImg.addChild(fieldGrid);
				}
				
				// add alphabet if the row contains alphabet 
							
				if (row.alphabet != "")
				{
					_curColumnHeight += alphabetHeight;
					_timer.removeEventListener(TimerEvent.TIMER, writeContent);					
					var alphabet:Sprite = _skin.drawAlphabet(row.alphabet);
					rowImg.addChild(alphabet);
					
					if (_isGrid)
					{
						var alphabetGridTop:Shape = new Shape();
						alphabetGridTop.graphics.beginFill(_gridColor);
						alphabetGridTop.graphics.drawRect(0, 0, columnWidth, gridSize);
						alphabetGridTop.graphics.endFill();
						alphabetGridTop.y = -gridSize;
						rowImg.addChild(alphabetGridTop);
						
						var alphabetGridBottom:Shape = new Shape();
						alphabetGridBottom.graphics.beginFill(_gridColor);
						alphabetGridBottom.graphics.drawRect(0, 0, columnWidth, gridSize);
						alphabetGridBottom.graphics.endFill();
						alphabetGridBottom.y = alphabetHeight;
						rowImg.addChild(alphabetGridBottom);
					}
					// need this return to stop the function, otherwise, even if you removed the listener, it will keep going loop
					return;	
				}
							
			}	
			
		}
		
		
		
		
		private function writeFooter(event:TimerEvent) : void
		{
			var percentLoaded:Number = 0.95 + _counter / 1 * 0.05;
			dispatchEvent(new LoadingEvent(LoadingEvent.PROGRESS, _loadingMsg, percentLoaded, 1));
			
			// when done, go to finish() method
			if (_counter >= 1)
			{
				_timer.removeEventListener(TimerEvent.TIMER, writeFooter);
				finish();
				return;
			}
			
			// draw footer
			var margins:Object = {left:toPixel(_marginLeft), top:toPixel(_marginTop), right:toPixel(_marginRight), bottom:toPixel(_marginBottom)};
			var fieldMargin:Number = toPixel(0.1);
			var footerHeight:Number = toPixel(_footerHeight);
			var footerX:Number = toPixel(11 - _footerHeight - _marginBottom);
			var footerLeftTf:TextField = Text.write(_footerLeftText, {size:dpiSize(_footerLeftSize), color:_footerLeftColor, font:_footerLeftFont});
			var footerLeftImg:Sprite = bitmapText(footerLeftTf);
			footerLeftImg.x = margins.left + fieldMargin;			
			footerLeftImg.y = footerX + (footerHeight - footerLeftImg.height) * 0.5;
			addChild(footerLeftImg);
			
			var footerRightTf:TextField = Text.write(_footerRightText, {size:dpiSize(_footerRightSize), color:_footerRightColor, font:_footerRightFont});
			var footerRightImg:Sprite = bitmapText(footerRightTf);			
			footerRightImg.x = toPixel(8.5) - margins.right - fieldMargin - footerRightImg.width;
			footerRightImg.y = footerX + (footerHeight - footerRightImg.height) * 0.5;
			addChild(footerRightImg);
			
			var pageNumberTf:TextField = Text.write(_pageNumber.toString(), {size:dpiSize(_footerLeftSize), color:_footerLeftColor, font:_footerLeftFont});
			var pageNumberImg:Sprite = bitmapText(pageNumberTf);
			pageNumberImg.x = (toPixel(8.5) - pageNumberImg.width) / 2;
			pageNumberImg.y = footerX + (footerHeight - pageNumberImg.height) * 0.5;
			addChild(pageNumberImg);
			
			_counter++;			
		}
		
		private function finish() : void
		{
			_timer.reset();
			_timer = null;
			dispatchEvent(new LoadingEvent(LoadingEvent.COMPLETE, "Loading done.."));
			dispatchEvent(new ProcessEvent(ProcessEvent.COMPLETE, "Saving done.."));
			return;
		}
		
		
		
		
		
		
		
		
		
		private function bitmapText(tf:TextField) : Sprite
		{
			var bitmapData:BitmapData = new BitmapData(tf.width, tf.height, true, 0);
			bitmapData.draw(tf);
			var bitmap:Bitmap = new Bitmap(bitmapData);
			var textImg:Sprite = new Sprite();
			textImg.addChild(bitmap);
			return textImg;
		}
		
		private function dpiSize(size:Number) : Number
		{
			return size * _dpi / 50;
		}
		
		private function toPixel(inch:Number) : Number
		{
			return inch * _dpi;
		}
	}
		
}
