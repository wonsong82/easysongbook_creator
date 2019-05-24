package won.page
{
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.system.System;
	import flash.utils.*;
	
	import org.alivepdf.images.ColorSpace;
	import org.alivepdf.layout.Mode;
	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Position;
	import org.alivepdf.layout.Resize;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	import org.alivepdf.saving.Method;
	
	import won.codec.JPEGEncoder;
	import won.events.*;

	public class PageSaveControllerAll extends EventDispatcher
	{
		private var _app:Object;
		private var _saveFolder:File;
		private var _pageNum:int;
		private var _pageTo:int;
		private var _t:Timer = null;
		private var _encoder:JPEGEncoder;		
		
		
		private var _timeElapsed:Number = 0;
		
		private var _pdf:PDF;
		private var _imgba:Array = [];
		
		public function PageSaveControllerAll(application:Object)
		{
			_app = application;			
			
		}
				
		public function checkMinRange(e:Event=null):void
		{
			var min:int = int(e.target.text);
			var max:int = int(_app.saveTo.text);
			if (min < 1)
				e.target.text = "1";	
			if (min > max)
				e.target.text = max.toString();
			
		}
		
		public function checkMaxRange(e:Event=null):void
		{
			var min:int = int(_app.saveFrom.text);
			var max:int = int(e.target.text);
			if (max > _app.totalPages)
				e.target.text = _app.totalPages.toString();
			if (min > max)
				_app.saveFrom.text = max.toString();
			
		}
		
		public function getAllRange(e:Event=null):void
		{
			if (_app.totalPages > 0)
			{
				_app.saveFrom.text = "1";
				_app.saveTo.text = _app.page.totalPages.toString();
			}
			
			else
			{
				_app.saveFrom.text = "0";
				_app.saveTo.text = "0";
			}
		}		
		
		
		public function browseForSave(e:Event=null):void
		{
			_app.disableControls();
			var saveFolder:File = _app.dataController.file.parent;
			saveFolder.addEventListener(Event.SELECT, showSavePanel);
			saveFolder.addEventListener(Event.CANCEL, _app.enableControls);
			saveFolder.browseForDirectory("Save to");
			
		}
				
		
		// set the variables and show the saving panel
		private function showSavePanel(e:Event):void
		{
			var by:String = (_app.typeController.selectedIndex == 1) ? 'Title' : 'Artist';
			var folder:File = File(e.target).resolvePath(by);
			folder.createDirectory();
			_saveFolder = folder;
				
			_app.saveFrom.text = '1';
			_app.saveTo.text = _app.totalPages.toString();			
			_app.saveFolderLbl.text = folder.nativePath;			
			
			_app.savePanel.visible = true;	
			
		}
		
				
		
		// when OK button from save panel is clicked
		public function save(e:Event=null):void
		{
			_app.savePanel.visible = false;
			_app.disableControls();
			
			_pageNum = int(_app.saveFrom.text);
			_pageTo = int(_app.saveTo.text);
			
			_pdf = new PDF(Orientation.PORTRAIT, Unit.INCHES, Size.LETTER);	
			_pdf.setMargins(0,0,0,0);
			
			
			writeInitialize();		
			
			
		}
		
		// when cancel is clicked from save panel
		public function cancel(e:Event=null):void
		{
			if (_pdf != null)
				_pdf = null;
			
			_app.savePanel.visible = false;
			_app.enableControls();
		}
		
		public function reset(e:Event=null):void
		{
			if (_pdf != null)
				_pdf = null;
			
			_app.timeEstimate.text = "";			
			if (_t != null)
			{
				_timeElapsed = 0;
				_t.reset();
				_t.stop();
				_t = null;
			}
		}
		
		public function writeInitialize():void // savetofile
		{
			// if timer is not already set, reset it and start the timer
			if (_t == null)
			{
				_t = new Timer(1000);
				_t.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void{
					_timeElapsed ++;
				});
				_t.start();			
			}
			
			_app.page = null;
			_app.page = new Page(_app.saveDPI.value, _pageNum);
			_app.page.addEventListener(ProcessEvent.INIT, function(e:ProcessEvent):void{
				_app.message(e.text);
			});
			
			_app.page.addEventListener(LoadingEvent.PROGRESS, saveLoadingHandler);
			_app.page.addEventListener(ErrorEvent.ERROR, _app.errorHandler);
			_app.page.addEventListener(ProcessEvent.COMPLETE, convertToBitmap);
			_app.draw();		
		}
		
		 
		
		
		
		private function convertToBitmap(e:ProcessEvent):void
		{			
			var bitmapData:BitmapData = new BitmapData(_app.page.width, _app.page.height, true, 0);
			bitmapData.draw(_app.page);
			_encoder = new JPEGEncoder(_app.saveQuality.value);
			_encoder.speed = int(_app.saveSpeed.value);
			_encoder.addEventListener(LoadingEvent.PROGRESS, saveLoadingHandler);
			_encoder.addEventListener(Event.COMPLETE, write);
			_encoder.encode(bitmapData);
			
		}
		
		private function write(e:Event):void
		{
			var file:File = _saveFolder.resolvePath(_pageNum.toString()+'.jpg');
			var ba:ByteArray = e.target.data;
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeBytes(ba);
			fs.close();
			_pdf.addPage();
			var resize:Resize = new Resize(Mode.FIT_TO_PAGE, Position.CENTERED);			
			_pdf.addImageStream(ba, ColorSpace.DEVICE_RGB, resize , 0, 0, 0, 0);
			
			trace ("totalMemory in use:" + System.totalMemory);
			
			_app.message("Saving " + _pageNum.toString() + '.jpg done.');
			
			if (_pageNum >= _pageTo)
			{
				_app.enableControls();
				saveLoadingCompleteHandler();
				if (_t != null) 
				{
					_t.reset();
					_t = null;
					_timeElapsed = 0;
				}
				_app.message("Songbook creation completed.");			
			}
			
			else
			{
				_pageNum++;
				writeInitialize();
			}		
		}
		
		private function saveLoadingHandler(e:LoadingEvent):void
		{
			_app.saveProgress.visible = true;
			_app.saveLoading.setProgress(e.bytesLoaded, e.bytesTotal);
			var msg:String;
			
			// if the same page
			if (e.target == _app.page)
			{
				msg = e.text + '/' + _app.totalPages.toString() + '-' + Math.round(e.bytesLoaded/e.bytesTotal*100).toString() + '%';
				_app.message(msg);
				_app.saveLoading.label = msg;
			}
			
			// if new page
			else
			{
				msg = e.text + ' page '+_pageNum.toString()+'/'+_app.totalPages.toString()+' - '+Math.round(e.bytesLoaded/e.bytesTotal*100).toString()+'%';
				_app.message(msg);
				_app.saveLoading.label = msg;
				
				var from:int = int(_app.saveFrom.text);
				var to:int = _pageTo;
				
				var loaded:Number = (_pageNum-from)/(to-from+1) + (e.bytesLoaded/e.bytesTotal)/(to-from+1);
				_app.saveLoadingTotal.setProgress(loaded,1);
				_app.saveLoadingTotal.label = "Total Progress - " + (_pageNum-from+1).toString()+'/'+(to-from+1)+' - '+Math.round(loaded/1*100).toString()+'%';
				
				_app.timeEstimate.text = "Total time elapsed : " + timeFormat(_timeElapsed);
				_app.timeEstimate.text += "\nTotal time estimate : " + timeFormat(_timeElapsed/loaded);			
			}			
		}
		
		private function saveLoadingCompleteHandler(event:LoadingEvent = null) : void
		{
					
			var by:String = (_app.typeController.selectedIndex.toString() == 1)? '_Title' : '_Artist';
			var fn:String = _app.dataController.file.name;
			var pdfFileName:String = fn.substr(0, fn.length-4) + by + '.pdf';
			
			var pdfFile:File = _saveFolder.parent.resolvePath(pdfFileName);
			var ba:ByteArray = _pdf.save(Method.LOCAL);
			
			var fs:FileStream = new FileStream();
			fs.open(pdfFile, FileMode.WRITE);
			fs.writeBytes(ba);
			fs.close();
			
			
			_app.saveProgress.visible = false;
			_app.saveLoading.setProgress(0,0);
			_app.saveLoading.label = '';
			_app.saveLoadingTotal.setProgress(0,0);
			_app.saveLoadingTotal.label = '';
			_app.enableControls();			
		}
		
		
		
		
		
		
		private function timeFormat(time:int) : String
		{			
			var hr:int = time / 3600;
			var min:int = time / 60 % 60;
			time = time % 60;
			var h:String = hr.toString();
			var m:String = (min.toString().length == 1) ? "0" + min.toString() : min.toString();
			var s:String = (time.toString().length == 1) ? "0" + time.toString() : time.toString();
			return h + ":" + m + ":" + s;
		}
		
		public function writeCancel(e:Event):void
		{	
			if (_pdf != null)
				_pdf = null;
			
			if (_app.page != null)
				_app.page.stop();
			
			if (_encoder != null)
				_encoder.stop();
						
			_app.saveProgress.visible = false;
			_app.saveLoading.setProgress(0, 0);
			_app.saveLoading.label = "";
			_app.saveLoadingTotal.setProgress(0, 0);
			_app.saveLoadingTotal.label = "";
			_app.timeEstimate.text = "";
			_app.enableControls();
			
			if (_t != null)
			{
				_timeElapsed = 0;
				_t.reset();
				_t.stop();
				_t = null;
			}
			
		}
		
		
	}
	
}