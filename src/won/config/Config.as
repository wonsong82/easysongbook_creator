package won.config
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	
	import won.color.RGB;

	public class Config
	{
		private var _app:Object;
		private var _filename:String = '';
		
		public function Config(application:Object)
		{
			_app = application;
			
		}
		
		public function browseForSave(e:Event=null, file:String="untitled.config"):void
		{
			var saveFile:File = File.applicationStorageDirectory.resolvePath(file);
			saveFile.addEventListener(Event.SELECT, writeConfig);
			saveFile.browseForSave("Save As");
		}
		
		public function browseForLoad(e:Event=null):void
		{
			var type:FileFilter = new FileFilter("configs", "*.config;"); 
			var loadFile:File = File.applicationStorageDirectory;
			loadFile.addEventListener(Event.SELECT, loadConfig);
			loadFile.browse([type]);
		}
		
		public function loadDefault(e:Event=null):void
		{
			var defaultConfig:File = File.applicationStorageDirectory.resolvePath('default.config');
			
			// if default config doesn't exist, write one
			if (!defaultConfig.exists)
			{
				var fs:FileStream = new FileStream();
				fs.open(defaultConfig, FileMode.WRITE);
				fs.writeUTFBytes(getDefaultConfig());
				fs.close();
				loadDefault();
			}
			
			// else load default config
			else			
				loadConfig();			
			
		}
		
		private function loadConfig(e:Event=null):void
		{
			var config:File = (e==null) ? File.applicationStorageDirectory.resolvePath('default.config') : File(e.target);
			if (config.exists)
			{
				var fs:FileStream = new FileStream();
				fs.open(config, FileMode.READ);				
				var configStr:String = fs.readUTFBytes(fs.bytesAvailable);
				fs.close();
				var c:XML = XML(configStr);
				
				_app.sort.selected = 				(c.book.@sort=='true')?true:false;
				_app.alphabet.selected = 			(c.book.@alphabet=='true')?true:false;
				_app.grid.selected = 				(c.book.@grid=='true')?true:false;
				_app.gridColor.selectedColor = 		String(c.book.@gridColor);
				_app.numRows.value = 				Number(c.layout.@numRows);
				_app.numColumns.value =				Number(c.layout.@numColumns);
				_app.marginLeft.text = 				String(c.layout.@marginLeft);
				_app.marginRight.text = 			String(c.layout.@marginRight);
				_app.marginTop.text = 				String(c.layout.@marginTop);
				_app.marginBottom.text = 			String(c.layout.@marginBottom);
				_app.headingFont.selectedItem =		String(c.heading.@font);
				_app.headingColor.selectedColor =	String(c.heading.@color);
				_app.headingSize.value = 			Number(c.heading.@size);
				_app.headingHeight.text = 			String(c.heading.@height);
				_app.byFont.selectedItem = 			String(c.by.@font);
				_app.byColor.selectedColor = 		String(c.by.@color);
				_app.bySize.value = 				Number(c.by.@size);
				_app.tanFont.selectedItem = 		String(c.tan.@font);
				_app.tanColor.selectedColor = 		String(c.tan.@color);
				_app.tanSize.value = 				Number(c.tan.@size);
				_app.titleFont.selectedItem = 		String(c.title.@font);
				_app.titleColor.selectedColor =	 	String(c.title.@color);
				_app.titleSize.value = 				Number(c.title.@size);
				_app.artistFont.selectedItem = 		String(c.artist.@font);
				_app.artistColor.selectedColor =	String(c.artist.@color);
				_app.artistSize.value = 			Number(c.artist.@size);
				_app.numberFont.selectedItem = 		String(c.number.@font);
				_app.numberColor.selectedColor = 	String(c.number.@color);
				_app.numberSize.value = 			Number(c.number.@size);
				_app.footerLeftText.text =		 	String(c.footer.@textLeft);
				_app.footerRightText.text = 		String(c.footer.@textRight);
				_app.footerFont.selectedItem =		String(c.footer.@font);
				_app.footerColor.selectedColor = 	String(c.footer.@color);
				_app.footerSize.value = 			Number(c.footer.@size);
				_app.footerHeight.text = 			String(c.footer.@height);
				_app.saveDPI.value = 				Number(c.save.@dpi);
				_app.saveQuality.value = 			Number(c.save.@quality);
				_app.saveSpeed.value = 				Number(c.save.@speed);				
				
				_app.message( String(config.name).replace('.config','') + ' configuration loaded.');
				_app.drawPreview();
			}
			else
				_app.errorMsg('Error while loading the config');	
						
		}
		
		
		private function writeConfig(e:Event):void
		{
			// check file, parse filename, and extension
			var configFile:File = File(e.target);
			var fileArr:Array = configFile.name.split('.');
			var filename:String = '';
			var extension:String = '';
			if (fileArr.length >= 2) 
			{
				extension = fileArr[fileArr.length-1];
				fileArr.pop();
				filename = fileArr.join('.');
			}
			else
			{
				filename = configFile.name;
				extension = '';
			}
			
			// resend to the browser if its wrong			
			if (configFile.name.toLowerCase() == 'default.config') 
			{
				_app.errorMsg('Cannot write on default.config File');
				browseForSave();
			}
			
			else if (extension.toLowerCase() != 'config') 
			{
				browseForSave(null, filename+'.config');
			}
			
			
			// if everything is good
			else  
			{
				var fileStream:FileStream = new FileStream();
				fileStream.open(configFile, FileMode.WRITE);
				fileStream.writeUTFBytes(getConfig());
				fileStream.close();
				_app.message(filename+' configuration saved.');
			}
			// end if
			
		}	
		
		private function getConfig():String
		{						
			var c:String = '<?xml version="1.0" encoding="utf-8"?>'+File.lineEnding;
			c+= '<config>'+File.lineEnding;
			c+= '\t<book sort="'+_app.sort.selected+'" alphabet="'+_app.alphabet.selected+'" grid="'+_app.grid.selected+'" gridColor="'+RGB.parseRGB(_app.gridColor.selectedColor).hex+'" />'+File.lineEnding;
			c+= '\t<layout numRows="'+_app.numRows.value+'" numColumns="'+_app.numColumns.value+'" marginLeft="'+_app.marginLeft.text+'" marginRight="'+_app.marginRight.text+'" marginTop="'+_app.marginTop.text+'" marginBottom="'+_app.marginBottom.text+'" />'+File.lineEnding;
			c+= '\t<heading font="'+_app.headingFont.selectedItem+'" color="'+RGB.parseRGB(_app.headingColor.selectedColor).hex+'" size="'+_app.headingSize.value+'" height="'+_app.headingHeight.text+'" />'+File.lineEnding;
			c+= '\t<by font="'+_app.byFont.selectedItem+'" color="'+RGB.parseRGB(_app.byColor.selectedColor).hex+'" size="'+_app.bySize.value+'"   />'+File.lineEnding;
			c+= '\t<tan desc="title,number,artist" font="'+_app.tanFont.selectedItem+'" color="'+RGB.parseRGB(_app.tanColor.selectedColor).hex+'" size="'+_app.tanSize.value+'"   />'+File.lineEnding;
			c+= '\t<title font="'+_app.titleFont.selectedItem+'" color="'+RGB.parseRGB(_app.titleColor.selectedColor).hex+'" size="'+_app.titleSize.value+'"   />'+File.lineEnding;
			c+= '\t<artist font="'+_app.artistFont.selectedItem+'" color="'+RGB.parseRGB(_app.artistColor.selectedColor).hex+'" size="'+_app.artistSize.value+'"   />'+File.lineEnding;
			c+= '\t<number font="'+_app.numberFont.selectedItem+'" color="'+RGB.parseRGB(_app.numberColor.selectedColor).hex+'" size="'+_app.numberSize.value+'"   />'+File.lineEnding;
			c+= '\t<footer textLeft="'+_app.footerLeftText.text+'" textRight="'+_app.footerRightText.text+'" font="'+_app.footerFont.selectedItem+'" color="'+RGB.parseRGB(_app.footerColor.selectedColor).hex+'" size="'+_app.footerSize.value+'" height="'+_app.footerHeight.text+'"   />'+File.lineEnding;
			c+= '\t<save dpi="'+_app.saveDPI.value+'" quality="'+_app.saveQuality.value+'" speed="'+_app.saveSpeed.value+'" />'+File.lineEnding;			
			c+= '</config>'+File.lineEnding;
			return c;
		}
		
		private function getDefaultConfig():String
		{
			var c:String = '<?xml version="1.0" encoding="utf-8"?>'+File.lineEnding;
			c+= '<config>'+File.lineEnding;
			c+= '\t<book sort="false" alphabet="false" grid="true" gridColor="0x000000" />'+File.lineEnding;
			c+= '\t<layout numRows="30" numColumns="2" marginLeft=".2" marginRight=".15" marginTop=".2" marginBottom=".15" />'+File.lineEnding;
			c+= '\t<heading font="Arial" color="0x000000" size="22" height="1.2" />'+File.lineEnding;
			c+= '\t<by font="Arial" color="0x000000" size="15"   />'+File.lineEnding;
			c+= '\t<tan desc="title,number,artist" font="Arial" color="0x000000" size="10"   />'+File.lineEnding;
			c+= '\t<title font="Arial" color="0x000000" size="10"   />'+File.lineEnding;
			c+= '\t<artist font="Arial" color="0x000000" size="10"   />'+File.lineEnding;
			c+= '\t<number font="Arial Black" color="0x000000" size="10"   />'+File.lineEnding;
			c+= '\t<footer textLeft="8.2011" textRight="www.singsingmedia.com" font="Arial" color="0x000000" size="7" height=".25"   />'+File.lineEnding;
			c+= '\t<save dpi="200" quality="60" speed="100" />'+File.lineEnding;			
			c+= '</config>'+File.lineEnding;
			return c;
		}
		
		
	}
}