﻿package won.codec
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	import won.events.*;
	
	public class JPEGEncoder extends MovieClip
	{
		private var counter:int = 0;
		private var w:int;
		private var h:int;
		private var source:BitmapData;
		private var transparent:Boolean;
		private var DCY:Number;
		private var DCU:Number;
		private var DCV:Number;
		private var s:int = 1;
		private var t:Timer;
		private const std_dc_luminance_nrcodes:Array = [0, 0, 1, 5, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0];
		private const std_dc_luminance_values:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
		private const std_dc_chrominance_nrcodes:Array = [0, 0, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0];
		private const std_dc_chrominance_values:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
		private const std_ac_luminance_nrcodes:Array = [0, 0, 2, 1, 3, 3, 2, 4, 3, 5, 5, 4, 4, 0, 0, 1, 125];
		private const std_ac_luminance_values:Array = [1, 2, 3, 0, 4, 17, 5, 18, 33, 49, 65, 6, 19, 81, 97, 7, 34, 113, 20, 50, 129, 145, 161, 8, 35, 66, 177, 193, 21, 82, 209, 240, 36, 51, 98, 114, 130, 9, 10, 22, 23, 24, 25, 26, 37, 38, 39, 40, 41, 42, 52, 53, 54, 55, 56, 57, 58, 67, 68, 69, 70, 71, 72, 73, 74, 83, 84, 85, 86, 87, 88, 89, 90, 99, 100, 101, 102, 103, 104, 105, 106, 115, 116, 117, 118, 119, 120, 121, 122, 131, 132, 133, 134, 135, 136, 137, 138, 146, 147, 148, 149, 150, 151, 152, 153, 154, 162, 163, 164, 165, 166, 167, 168, 169, 170, 178, 179, 180, 181, 182, 183, 184, 185, 186, 194, 195, 196, 197, 198, 199, 200, 201, 202, 210, 211, 212, 213, 214, 215, 216, 217, 218, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250];
		private const std_ac_chrominance_nrcodes:Array = [0, 0, 2, 1, 2, 4, 4, 3, 4, 7, 5, 4, 4, 0, 1, 2, 119];
		private const std_ac_chrominance_values:Array = [0, 1, 2, 3, 17, 4, 5, 33, 49, 6, 18, 65, 81, 7, 97, 113, 19, 34, 50, 129, 8, 20, 66, 145, 161, 177, 193, 9, 35, 51, 82, 240, 21, 98, 114, 209, 10, 22, 36, 52, 225, 37, 241, 23, 24, 25, 26, 38, 39, 40, 41, 42, 53, 54, 55, 56, 57, 58, 67, 68, 69, 70, 71, 72, 73, 74, 83, 84, 85, 86, 87, 88, 89, 90, 99, 100, 101, 102, 103, 104, 105, 106, 115, 116, 117, 118, 119, 120, 121, 122, 130, 131, 132, 133, 134, 135, 136, 137, 138, 146, 147, 148, 149, 150, 151, 152, 153, 154, 162, 163, 164, 165, 166, 167, 168, 169, 170, 178, 179, 180, 181, 182, 183, 184, 185, 186, 194, 195, 196, 197, 198, 199, 200, 201, 202, 210, 211, 212, 213, 214, 215, 216, 217, 218, 226, 227, 228, 229, 230, 231, 232, 233, 234, 242, 243, 244, 245, 246, 247, 248, 249, 250];
		private const ZigZag:Array = [0, 1, 5, 6, 14, 15, 27, 28, 2, 4, 7, 13, 16, 26, 29, 42, 3, 8, 12, 17, 25, 30, 41, 43, 9, 11, 18, 24, 31, 40, 44, 53, 10, 19, 23, 32, 39, 45, 52, 54, 20, 22, 33, 38, 46, 51, 55, 60, 21, 34, 37, 47, 50, 56, 59, 61, 35, 36, 48, 49, 57, 58, 62, 63];		
		private var YDC_HT:Array;
		private var UVDC_HT:Array;
		private var YAC_HT:Array;
		private var UVAC_HT:Array;
		private var category:Array = new Array(65535);
		private var bitcode:Array = new Array(65535);
		private var YTable:Array = new Array(64);
		private var UVTable:Array = new Array(64);
		private var fdtbl_Y:Array = new Array(64);
		private var fdtbl_UV:Array = new Array(64);
		private var byteout:ByteArray;
		private var bytenew:int = 0;
		private var bytepos:int = 7;
		private var DU:Array = new Array(64);
		private var YDU:Array = new Array(64);
		private var UDU:Array = new Array(64);
		private var VDU:Array = new Array(64);
		
		public function JPEGEncoder(param1:Number = 50)
		{
			t = new Timer(100);
			t.start();
			if (param1 <= 0)
			{
				param1 = 1;
			}
			if (param1 > 100)
			{
				param1 = 100;
			}
			var _loc_2:int = 0;
			if (param1 < 50)
			{
				_loc_2 = int(5000 / param1);
			}
			else
			{
				_loc_2 = int(200 - param1 * 2);
			}
			initHuffmanTbl();
			initCategoryNumber();
			initQuantTables(_loc_2);
			return;
		}// end function
		
		public function get data() : ByteArray
		{
			return byteout;
		}// end function
		
		public function set speed(param1:int) : void
		{
			s = param1;
			return;
		}// end function
		
		override public function stop() : void
		{
			if (t)
			{
				t.reset();
			}
			t = null;
			return;
		}// end function
		
		public function encode(param1:BitmapData) : void
		{
			source = param1;
			w = param1.width;
			h = param1.height;
			transparent = param1.transparent;
			dispatchEvent(new LoadingEvent(LoadingEvent.PROGRESS, "Encoding", 0, 1));
			t.addEventListener(TimerEvent.TIMER, getHeader);
			return;
		}// end function
		
		private function getHeader(event:TimerEvent) : void
		{
			if (counter == 1)
			{
				t.removeEventListener(TimerEvent.TIMER, getHeader);
				DCY = 0;
				DCU = 0;
				DCV = 0;
				bytenew = 0;
				bytepos = 7;
				counter = 0;
				t.addEventListener(TimerEvent.TIMER, getData);
				return;
			}
			byteout = new ByteArray();
			bytenew = 0;
			bytepos = 7;
			writeWord(65496);
			writeAPP0();
			writeDQT();
			writeSOF0(w, h);
			writeDHT();
			writeSOS();
			counter++;
			return;
		}// end function
		
		private function getData(event:TimerEvent) : void
		{
			var _loc_5:int = 0;
			var _loc_6:int = 0;
			var _loc_2:* = counter + s;
			while (counter < _loc_2)
			{
				
				if (counter >= h)
				{
					t.removeEventListener(TimerEvent.TIMER, getData);
					counter = 0;
					t.addEventListener(TimerEvent.TIMER, getEnd);
					return;
				}
				_loc_5 = counter;
				_loc_6 = 0;
				while (_loc_6 < w)
				{
					
					RGB2YUV(source, _loc_6, _loc_5, w, h);
					DCY = processDU(YDU, fdtbl_Y, DCY, YDC_HT, YAC_HT);
					DCU = processDU(UDU, fdtbl_UV, DCU, UVDC_HT, UVAC_HT);
					DCV = processDU(VDU, fdtbl_UV, DCV, UVDC_HT, UVAC_HT);
					_loc_6 = _loc_6 + 8;
				}
				counter = counter + 8;
			}
			var _loc_3:* = counter >= h ? (h) : (counter);
			var _loc_4:* = h;
			dispatchEvent(new LoadingEvent(LoadingEvent.PROGRESS, "Encoding", _loc_3, _loc_4));
			return;
		}// end function
		
		private function getEnd(event:TimerEvent) : void
		{
			var _loc_2:BitString = null;
			if (counter == 1)
			{
				t.removeEventListener(TimerEvent.TIMER, getEnd);
				dispatchEvent(new LoadingEvent(LoadingEvent.COMPLETE, "Encoding"));
				dispatchEvent(new Event(Event.COMPLETE));
				t.reset();
				t = null;
				return;
			}
			if (bytepos >= 0)
			{
				_loc_2 = new BitString();
				_loc_2.len = bytepos + 1;
				_loc_2.val = (1 << (bytepos + 1)) - 1;
				writeBits(_loc_2);
			}
			writeWord(65497);
			counter++;
			return;
		}// end function
		
		private function initHuffmanTbl() : void
		{
			YDC_HT = computeHuffmanTbl(std_dc_luminance_nrcodes, std_dc_luminance_values);
			UVDC_HT = computeHuffmanTbl(std_dc_chrominance_nrcodes, std_dc_chrominance_values);
			YAC_HT = computeHuffmanTbl(std_ac_luminance_nrcodes, std_ac_luminance_values);
			UVAC_HT = computeHuffmanTbl(std_ac_chrominance_nrcodes, std_ac_chrominance_values);
			return;
		}// end function
		
		private function computeHuffmanTbl(param1:Array, param2:Array) : Array
		{
			var _loc_7:int = 0;
			var _loc_3:int = 0;
			var _loc_4:int = 0;
			var _loc_5:Array = [];
			var _loc_6:int = 1;
			while (_loc_6 <= 16)
			{
				
				_loc_7 = 1;
				while (_loc_7 <= param1[_loc_6])
				{
					
					_loc_5[param2[_loc_4]] = new BitString();
					_loc_5[param2[_loc_4]].val = _loc_3;
					_loc_5[param2[_loc_4]].len = _loc_6;
					_loc_4++;
					_loc_3++;
					_loc_7++;
				}
				_loc_3 = _loc_3 * 2;
				_loc_6++;
			}
			return _loc_5;
		}// end function
		
		private function initCategoryNumber() : void
		{
			var _loc_1:int = 0;
			var _loc_2:int = 1;
			var _loc_3:int = 2;
			var _loc_4:int = 1;
			while (_loc_4 <= 15)
			{
				
				_loc_1 = _loc_2;
				while (_loc_1 < _loc_3)
				{
					
					category[32767 + _loc_1] = _loc_4;
					bitcode[32767 + _loc_1] = new BitString();
					bitcode[32767 + _loc_1].len = _loc_4;
					bitcode[32767 + _loc_1].val = _loc_1;
					_loc_1++;
				}
				_loc_1 = -(_loc_3 - 1);
				while (_loc_1 <= -_loc_2)
				{
					
					category[32767 + _loc_1] = _loc_4;
					bitcode[32767 + _loc_1] = new BitString();
					bitcode[32767 + _loc_1].len = _loc_4;
					bitcode[32767 + _loc_1].val = (_loc_3 - 1) + _loc_1;
					_loc_1++;
				}
				_loc_2 = _loc_2 << 1;
				_loc_3 = _loc_3 << 1;
				_loc_4++;
			}
			return;
		}// end function
		
		private function initQuantTables(param1:int) : void
		{
			var _loc_3:Number = NaN;
			var _loc_8:int = 0;
			var _loc_2:int = 0;
			var _loc_4:Array = [16, 11, 10, 16, 24, 40, 51, 61, 12, 12, 14, 19, 26, 58, 60, 55, 14, 13, 16, 24, 40, 57, 69, 56, 14, 17, 22, 29, 51, 87, 80, 62, 18, 22, 37, 56, 68, 109, 103, 77, 24, 35, 55, 64, 81, 104, 113, 92, 49, 64, 78, 87, 103, 121, 120, 101, 72, 92, 95, 98, 112, 100, 103, 99];
			_loc_2 = 0;
			while (_loc_2 < 64)
			{
				
				_loc_3 = Math.floor((_loc_4[_loc_2] * param1 + 50) / 100);
				if (_loc_3 < 1)
				{
					_loc_3 = 1;
				}
				else if (_loc_3 > 255)
				{
					_loc_3 = 255;
				}
				YTable[ZigZag[_loc_2]] = _loc_3;
				_loc_2++;
			}
			var _loc_5:Array = [17, 18, 24, 47, 99, 99, 99, 99, 18, 21, 26, 66, 99, 99, 99, 99, 24, 26, 56, 99, 99, 99, 99, 99, 47, 66, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99];
			_loc_2 = 0;
			while (_loc_2 < 64)
			{
				
				_loc_3 = Math.floor((_loc_5[_loc_2] * param1 + 50) / 100);
				if (_loc_3 < 1)
				{
					_loc_3 = 1;
				}
				else if (_loc_3 > 255)
				{
					_loc_3 = 255;
				}
				UVTable[ZigZag[_loc_2]] = _loc_3;
				_loc_2++;
			}
			var _loc_6:Array = [1, 1.38704, 1.30656, 1.17588, 1, 0.785695, 0.541196, 0.275899];
			_loc_2 = 0;
			var _loc_7:int = 0;
			while (_loc_7 < 8)
			{
				
				_loc_8 = 0;
				while (_loc_8 < 8)
				{
					
					fdtbl_Y[_loc_2] = 1 / (YTable[ZigZag[_loc_2]] * _loc_6[_loc_7] * _loc_6[_loc_8] * 8);
					fdtbl_UV[_loc_2] = 1 / (UVTable[ZigZag[_loc_2]] * _loc_6[_loc_7] * _loc_6[_loc_8] * 8);
					_loc_2++;
					_loc_8++;
				}
				_loc_7++;
			}
			return;
		}// end function
		
		private function RGB2YUV(param1:BitmapData, param2:int, param3:int, param4:int, param5:int) : void
		{
			var _loc_8:int = 0;
			var _loc_9:int = 0;
			var _loc_10:int = 0;
			var _loc_11:uint = 0;
			var _loc_12:Number = NaN;
			var _loc_13:Number = NaN;
			var _loc_14:Number = NaN;
			var _loc_6:int = 0;
			var _loc_7:int = 0;
			while (_loc_7 < 8)
			{
				
				_loc_8 = param3 + _loc_7;
				if (_loc_8 >= param5)
				{
					_loc_8 = param5 - 1;
				}
				_loc_9 = 0;
				while (_loc_9 < 8)
				{
					
					_loc_10 = param2 + _loc_9;
					if (_loc_10 >= param4)
					{
						_loc_10 = param4 - 1;
					}
					_loc_11 = param1.getPixel32(_loc_10, _loc_8);
					_loc_12 = Number(_loc_11 >> 16 & 255);
					_loc_13 = Number(_loc_11 >> 8 & 255);
					_loc_14 = Number(_loc_11 & 255);
					YDU[_loc_6] = 0.299 * _loc_12 + 0.587 * _loc_13 + 0.114 * _loc_14 - 128;
					UDU[_loc_6] = -0.16874 * _loc_12 - 0.33126 * _loc_13 + 0.5 * _loc_14;
					VDU[_loc_6] = 0.5 * _loc_12 - 0.41869 * _loc_13 - 0.08131 * _loc_14;
					_loc_6++;
					_loc_9++;
				}
				_loc_7++;
			}
			return;
		}// end function
		
		private function processDU(param1:Array, param2:Array, param3:Number, param4:Array, param5:Array) : Number
		{
			var _loc_8:int = 0;
			var _loc_12:int = 0;
			var _loc_13:int = 0;
			var _loc_14:int = 0;
			var _loc_6:* = param5[0];
			var _loc_7:* = param5[240];
			var _loc_9:* = fDCTQuant(param1, param2);
			_loc_8 = 0;
			while (_loc_8 < 64)
			{
				
				DU[ZigZag[_loc_8]] = _loc_9[_loc_8];
				_loc_8++;
			}
			var _loc_10:* = DU[0] - param3;
			param3 = DU[0];
			if (_loc_10 == 0)
			{
				writeBits(param4[0]);
			}
			else
			{
				writeBits(param4[category[32767 + _loc_10]]);
				writeBits(bitcode[32767 + _loc_10]);
			}
			var _loc_11:int = 63;
			while (_loc_11 > 0 && DU[_loc_11] == 0)
			{
				
				_loc_11 = _loc_11 - 1;
			}
			if (_loc_11 == 0)
			{
				writeBits(_loc_6);
				return param3;
			}
			_loc_8 = 1;
			while (_loc_8 <= _loc_11)
			{
				
				_loc_12 = _loc_8;
				while (DU[_loc_8] == 0 && _loc_8 <= _loc_11)
				{
					
					_loc_8++;
				}
				_loc_13 = _loc_8 - _loc_12;
				if (_loc_13 >= 16)
				{
					_loc_14 = 1;
					while (_loc_14 <= _loc_13 / 16)
					{
						
						writeBits(_loc_7);
						_loc_14++;
					}
					_loc_13 = int(_loc_13 & 15);
				}
				writeBits(param5[_loc_13 * 16 + category[32767 + DU[_loc_8]]]);
				writeBits(bitcode[32767 + DU[_loc_8]]);
				_loc_8++;
			}
			if (_loc_11 != 63)
			{
				writeBits(_loc_6);
			}
			return param3;
		}// end function
		
		private function fDCTQuant(param1:Array, param2:Array) : Array
		{
			var _loc_4:int = 0;
			var _loc_5:Number = NaN;
			var _loc_6:Number = NaN;
			var _loc_7:Number = NaN;
			var _loc_8:Number = NaN;
			var _loc_9:Number = NaN;
			var _loc_10:Number = NaN;
			var _loc_11:Number = NaN;
			var _loc_12:Number = NaN;
			var _loc_13:Number = NaN;
			var _loc_14:Number = NaN;
			var _loc_15:Number = NaN;
			var _loc_16:Number = NaN;
			var _loc_17:Number = NaN;
			var _loc_18:Number = NaN;
			var _loc_19:Number = NaN;
			var _loc_20:Number = NaN;
			var _loc_21:Number = NaN;
			var _loc_22:Number = NaN;
			var _loc_23:Number = NaN;
			var _loc_3:int = 0;
			_loc_4 = 0;
			while (_loc_4 < 8)
			{
				
				_loc_5 = param1[_loc_3 + 0] + param1[_loc_3 + 7];
				_loc_6 = param1[_loc_3 + 0] - param1[_loc_3 + 7];
				_loc_7 = param1[(_loc_3 + 1)] + param1[_loc_3 + 6];
				_loc_8 = param1[(_loc_3 + 1)] - param1[_loc_3 + 6];
				_loc_9 = param1[_loc_3 + 2] + param1[_loc_3 + 5];
				_loc_10 = param1[_loc_3 + 2] - param1[_loc_3 + 5];
				_loc_11 = param1[_loc_3 + 3] + param1[_loc_3 + 4];
				_loc_12 = param1[_loc_3 + 3] - param1[_loc_3 + 4];
				_loc_13 = _loc_5 + _loc_11;
				_loc_14 = _loc_5 - _loc_11;
				_loc_15 = _loc_7 + _loc_9;
				_loc_16 = _loc_7 - _loc_9;
				param1[_loc_3 + 0] = _loc_13 + _loc_15;
				param1[_loc_3 + 4] = _loc_13 - _loc_15;
				_loc_17 = (_loc_16 + _loc_14) * 0.707107;
				param1[_loc_3 + 2] = _loc_14 + _loc_17;
				param1[_loc_3 + 6] = _loc_14 - _loc_17;
				_loc_13 = _loc_12 + _loc_10;
				_loc_15 = _loc_10 + _loc_8;
				_loc_16 = _loc_8 + _loc_6;
				_loc_18 = (_loc_13 - _loc_16) * 0.382683;
				_loc_19 = 0.541196 * _loc_13 + _loc_18;
				_loc_20 = 1.30656 * _loc_16 + _loc_18;
				_loc_21 = _loc_15 * 0.707107;
				_loc_22 = _loc_6 + _loc_21;
				_loc_23 = _loc_6 - _loc_21;
				param1[_loc_3 + 5] = _loc_23 + _loc_19;
				param1[_loc_3 + 3] = _loc_23 - _loc_19;
				param1[(_loc_3 + 1)] = _loc_22 + _loc_20;
				param1[_loc_3 + 7] = _loc_22 - _loc_20;
				_loc_3 = _loc_3 + 8;
				_loc_4++;
			}
			_loc_3 = 0;
			_loc_4 = 0;
			while (_loc_4 < 8)
			{
				
				_loc_5 = param1[_loc_3 + 0] + param1[_loc_3 + 56];
				_loc_6 = param1[_loc_3 + 0] - param1[_loc_3 + 56];
				_loc_7 = param1[_loc_3 + 8] + param1[_loc_3 + 48];
				_loc_8 = param1[_loc_3 + 8] - param1[_loc_3 + 48];
				_loc_9 = param1[_loc_3 + 16] + param1[_loc_3 + 40];
				_loc_10 = param1[_loc_3 + 16] - param1[_loc_3 + 40];
				_loc_11 = param1[_loc_3 + 24] + param1[_loc_3 + 32];
				_loc_12 = param1[_loc_3 + 24] - param1[_loc_3 + 32];
				_loc_13 = _loc_5 + _loc_11;
				_loc_14 = _loc_5 - _loc_11;
				_loc_15 = _loc_7 + _loc_9;
				_loc_16 = _loc_7 - _loc_9;
				param1[_loc_3 + 0] = _loc_13 + _loc_15;
				param1[_loc_3 + 32] = _loc_13 - _loc_15;
				_loc_17 = (_loc_16 + _loc_14) * 0.707107;
				param1[_loc_3 + 16] = _loc_14 + _loc_17;
				param1[_loc_3 + 48] = _loc_14 - _loc_17;
				_loc_13 = _loc_12 + _loc_10;
				_loc_15 = _loc_10 + _loc_8;
				_loc_16 = _loc_8 + _loc_6;
				_loc_18 = (_loc_13 - _loc_16) * 0.382683;
				_loc_19 = 0.541196 * _loc_13 + _loc_18;
				_loc_20 = 1.30656 * _loc_16 + _loc_18;
				_loc_21 = _loc_15 * 0.707107;
				_loc_22 = _loc_6 + _loc_21;
				_loc_23 = _loc_6 - _loc_21;
				param1[_loc_3 + 40] = _loc_23 + _loc_19;
				param1[_loc_3 + 24] = _loc_23 - _loc_19;
				param1[_loc_3 + 8] = _loc_22 + _loc_20;
				param1[_loc_3 + 56] = _loc_22 - _loc_20;
				_loc_3++;
				_loc_4++;
			}
			_loc_4 = 0;
			while (_loc_4 < 64)
			{
				
				param1[_loc_4] = Math.round(param1[_loc_4] * param2[_loc_4]);
				_loc_4++;
			}
			return param1;
		}// end function
		
		private function writeBits(bs:BitString) : void
		{
			var value:* = bs.val;
			var posval:* = bs.len - 1;
			while (posval >= 0)
			{				
				if (value & uint(1 << posval))
				{
					bytenew = bytenew | uint(1 << bytepos);
				}
				posval--;
				bytepos--;
				if (bytepos < 0)
				{
					if (bytenew == 255)
					{
						writeByte(255);
						writeByte(0);
					}
					else
					{
						writeByte(bytenew);
					}
					bytepos = 7;
					bytenew = 0;
				}
			}
			return;
		}// end function
		
		private function writeByte(param1:int) : void
		{
			byteout.writeByte(param1);
			return;
		}// end function
		
		private function writeWord(param1:int) : void
		{
			writeByte(param1 >> 8 & 255);
			writeByte(param1 & 255);
			return;
		}// end function
		
		private function writeAPP0() : void
		{
			writeWord(65504);
			writeWord(16);
			writeByte(74);
			writeByte(70);
			writeByte(73);
			writeByte(70);
			writeByte(0);
			writeByte(1);
			writeByte(1);
			writeByte(0);
			writeWord(1);
			writeWord(1);
			writeByte(0);
			writeByte(0);
			return;
		}// end function
		
		private function writeDQT() : void
		{
			var _loc_1:int = 0;
			writeWord(65499);
			writeWord(132);
			writeByte(0);
			_loc_1 = 0;
			while (_loc_1 < 64)
			{
				
				writeByte(YTable[_loc_1]);
				_loc_1++;
			}
			writeByte(1);
			_loc_1 = 0;
			while (_loc_1 < 64)
			{
				
				writeByte(UVTable[_loc_1]);
				_loc_1++;
			}
			return;
		}// end function
		
		private function writeSOF0(param1:int, param2:int) : void
		{
			writeWord(65472);
			writeWord(17);
			writeByte(8);
			writeWord(param2);
			writeWord(param1);
			writeByte(3);
			writeByte(1);
			writeByte(17);
			writeByte(0);
			writeByte(2);
			writeByte(17);
			writeByte(1);
			writeByte(3);
			writeByte(17);
			writeByte(1);
			return;
		}// end function
		
		private function writeDHT() : void
		{
			var _loc_1:int = 0;
			writeWord(65476);
			writeWord(418);
			writeByte(0);
			_loc_1 = 0;
			while (_loc_1 < 16)
			{
				
				writeByte(std_dc_luminance_nrcodes[(_loc_1 + 1)]);
				_loc_1++;
			}
			_loc_1 = 0;
			while (_loc_1 <= 11)
			{
				
				writeByte(std_dc_luminance_values[_loc_1]);
				_loc_1++;
			}
			writeByte(16);
			_loc_1 = 0;
			while (_loc_1 < 16)
			{
				
				writeByte(std_ac_luminance_nrcodes[(_loc_1 + 1)]);
				_loc_1++;
			}
			_loc_1 = 0;
			while (_loc_1 <= 161)
			{
				
				writeByte(std_ac_luminance_values[_loc_1]);
				_loc_1++;
			}
			writeByte(1);
			_loc_1 = 0;
			while (_loc_1 < 16)
			{
				
				writeByte(std_dc_chrominance_nrcodes[(_loc_1 + 1)]);
				_loc_1++;
			}
			_loc_1 = 0;
			while (_loc_1 <= 11)
			{
				
				writeByte(std_dc_chrominance_values[_loc_1]);
				_loc_1++;
			}
			writeByte(17);
			_loc_1 = 0;
			while (_loc_1 < 16)
			{
				
				writeByte(std_ac_chrominance_nrcodes[(_loc_1 + 1)]);
				_loc_1++;
			}
			_loc_1 = 0;
			while (_loc_1 <= 161)
			{
				
				writeByte(std_ac_chrominance_values[_loc_1]);
				_loc_1++;
			}
			return;
		}// end function
		
		private function writeSOS() : void
		{
			writeWord(65498);
			writeWord(12);
			writeByte(3);
			writeByte(1);
			writeByte(0);
			writeByte(2);
			writeByte(17);
			writeByte(3);
			writeByte(17);
			writeByte(0);
			writeByte(63);
			writeByte(0);
			return;
		}// end function
		
	}
}

class BitString extends Object
{
	public var len:int = 0;
	public var val:int = 0;
	
	function BitString()
	{
		return;
	}// end function
	
}

