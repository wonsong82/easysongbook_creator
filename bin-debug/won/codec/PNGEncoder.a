package won.codec
{

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.*;
import flash.utils.ByteArray;
import flash.utils.Timer;

import won.paper.Paper;

public class PNGEncoder extends MovieClip
{  	
    public function get data():ByteArray { return _png; }    
    public function set speed(higherTheFaster:int):void { _speed = higherTheFaster; }

    public function PNGEncoder()
    {    	
    }
    
    public function encode(source:DisplayObject, paper:Paper, transparent:Boolean=true):void
    {
    	// set the source's size for final paper's size (after DPI calculation)
    	source.width = paper.width;
    	source.height = paper.height;
    	
    	_transparent = transparent;
    	_width = source.width;
    	_height = source.height;
    	    	
    	_source = getBitmapData(source); 
    	
    	
    	/*
    	
    	// valid PNG image must contain an IHDR chunk, one or more IDAT chunks, and an IEND chunk
        // Create output byte array
        _png = new ByteArray();
        _source = source;
        _width = width;
        _height = height;
        _transparent = transparent;

        // Write PNG signature
        _png.writeUnsignedInt(0x89504e47);
        _png.writeUnsignedInt(0x0D0A1A0A);

        // Build IHDR chunk
        IHDR = new ByteArray();
        IHDR.writeInt(width); // 4bytes width
        IHDR.writeInt(height); // 4bytes height
        IHDR.writeUnsignedInt(0x08060000); // 32bit RGBA  08=bitdepth, 06=colorType, 00=compression, 00=filter
        IHDR.writeByte(0); //interlace
        writeChunk(_png, 0x49484452, IHDR);
        
        // Build IDAT chunk
       	IDAT = new ByteArray();
        
        addEventListener(Event.ENTER_FRAME, onFrame);
        */
    }
    
    // this function reads the displayObject and returns the array containing BitmapData
    // if displayObject is bigger than 2880px which is the limit in as3, then make multiple BitmapData and return the array containing BitmapDatas
    private function getBitmapData(src:DisplayObject):Array
    {
    	var bitmapDataArray:Array = [];
    	// create an empty container and put the src into it, 
    	// so that if the size is bigger than 2880, src's position will be changed to take a snapshot
    	var camera:Sprite = new Sprite();
    	camera.addChild(src);
    	
    	
    	
    	for (var j:int = 0; j < src.height; j += 2880)
    	{
    		for (var i:int = 0; i < src.width; i += 2880)
    		{
    			src.x = -i;
    			src.y = -j;
    			
    			var width:Number = src.width - i;
    			var height:Number = src.height - j;
    			
    			var bitmapData:BitmapData = new BitmapData(width, height, _transparent);
    			bitmapData.draw(camera);
    			
    			//bitmapDataArray.push([bitmapData,	
    		}
    	}
    	
    	
    	return [];
    }
    
    
    private function onFrame(e:Event):void
    {    	
    	writeIDAT(_speed);       
        
               
        if (_y <= _height)
        	dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _y, _height));
        
        if (_y >= _height) // if writing IDAT is done, write IEND
        {
        	dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _height, _height));
        	this.removeEventListener(Event.ENTER_FRAME, onFrame);
        	writeEnd();
        }         
    }  
    
    private function writeIDAT(howMany:int):void
    {
    	for (var i:int=0; i<howMany; i++)
    	{
    		if (_y > _height) return;
    		
    		var x:int;    		   		

        // no filter
			IDAT.writeByte(0);        
	
	        var p:uint; //pixel
	        if (!_transparent)
	        {
	            for (x = 0; x < _width; x++)
	            {
	                p = getPixel(_source, x, _y, _width, _height);
	                IDAT.writeUnsignedInt(uint(((p&0xFFFFFF) << 8) | 0xFF));
	            }
	        }
	        else
	        {
	            for (x = 0; x < _width; x++)
	            {
	                p = getPixel32(_source, x, _y, _width, _height);
	                IDAT.writeUnsignedInt(uint(((p&0xFFFFFF) << 8) | (p >>> 24)));
	            }
	        } 
	        _y++;	               
    	}
    	 
    }
    
    private function writeEnd():void
    {
    	IDAT.compress(); 
    	writeChunk(_png, 0x49444154, IDAT); 
    	
    	// Build IEND chunk
        writeChunk(_png, 0x49454E44, null);

        // return PNG
        _png.position = 0;
        
        dispatchEvent(new Event(Event.COMPLETE));        
    }
      

    

    private function writeChunk(png:ByteArray, type:uint, data:ByteArray):void
    {
        var c:uint;

        if (!crcTableComputed)
        {
            crcTableComputed = true;
            crcTable = [];
            for (var n:uint = 0; n < 256; n++)
            {
                c = n;
                for (var k:uint = 0; k < 8; k++)
                {
                    if (c & 1)
                    {
                        c = uint(uint(0xedb88320) ^ uint(c >>> 1));
                    }
                    else
                    {
                        c = uint(c >>> 1);
                    }
                }
                crcTable[n] = c;
            }
        }

        var len:uint = 0;
        if (data != null)
        {
            len = data.length;
        }

        png.writeUnsignedInt(len);
        var p:uint = png.position;
        png.writeUnsignedInt(type);
        if (data != null)
        {
            png.writeBytes(data);
        }

        var e:uint = png.position;
        png.position = p;
        c = 0xffffffff;
        for (var i:int = 0; i < (e - p); i++)
        {
            c = uint(crcTable[(c ^ png.readUnsignedByte()) & uint(0xff)] ^ uint(c >>> 8));
        }
        c = uint(c ^ uint(0xffffffff));
        png.position = e;
        png.writeUnsignedInt(c);
    }

    /**
     * Gets an unmultiplied pixel RGB value as an unsigned integer. No alpha
     * transparency information is included.
     */
    private function getPixel(source:Object, x:int, y:int, width:int=0, height:int=0):uint
    {
        if (source is BitmapData)
        {
            var bitmap:BitmapData = source as BitmapData;
            return bitmap.getPixel(x, y);
        }
        else if (source is ByteArray)
        {
            var byteArray:ByteArray = source as ByteArray;
            byteArray.position = ((y * width) * 4) + (x * 4);
            return byteArray.readUnsignedInt();
        }
        else
        {
            throw new ArgumentError("The source argument must be an instance of flash.display.BitmapData or flash.utils.ByteArray.");
        }
    }

    /**
     * Returns an unmultiplied ARGB color value (that contains alpha channel
     * data and RGB data) as an unsigned integer.
     */
    private function getPixel32(source:Object, x:int, y:int, width:int=0, height:int=0):uint
    {
        if (source is BitmapData)
        {
            var bitmap:BitmapData = source as BitmapData;
            return bitmap.getPixel32(x, y);
        }
        else if (source is ByteArray)
        {
            var byteArray:ByteArray = source as ByteArray;
            byteArray.position = ((y * width) * 4) + (x * 4);
            return byteArray.readUnsignedInt();
        }
        else
        {
            throw new ArgumentError("The source argument must be an instance of flash.display.BitmapData or flash.utils.ByteArray.");
        }
    }

    private var crcTable:Array;
    private var crcTableComputed:Boolean = false;    
    private var IHDR:ByteArray;
    private var IDAT:ByteArray;
    
   	private var _timer:Timer;    
    private var _png:ByteArray;
    private var _transparent:Boolean = true;
    private var _width:int;
    private var _height:int;
    private var _source:Array;
    private var _speed:int = 1;
    
    private var _y:int=0;
    
}

}