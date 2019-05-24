import flash.display.*;
import flash.events.*;
import flash.filesystem.*;
import flash.filters.*;
import flash.system.System;
import flash.utils.*;

import mx.binding.*;
import mx.containers.*;
import mx.controls.*;
import mx.core.*;
import mx.events.*;
import mx.styles.*;

import spark.components.*;
import spark.events.*;

import won.config.Config;
import won.events.*;
import won.font.*;
import won.page.*;

public var page:Page;
public var pagesCache:Array = [];
public var preview:Preview;
public var pageNum:int = 1;
public var totalPages:int;
public var saveCount:int;
public var saveFolder:File;
public var nav:PageNavigation;
public var saveControl:PageSaveControllerPDF;
public var config:Config;
public var data:Array;
//private var encoder:JPEGEncoder;


private function init():void
{	
	// set up the loading bar
	loadingBar.visible = false;
	loadingBar.filters = [new DropShadowFilter(4, 45, 34, 0.7, 6, 6)];
	
	// set up the xml choose button
	dataController.addEventListener(LoadingEvent.PROGRESS, loadingHandler);
	dataController.addEventListener(LoadingEvent.COMPLETE, loadingCompleteHandler);
	dataController.addEventListener(ErrorEvent.ERROR, errorHandler);
	dataController.addEventListener(ProcessEvent.COMPLETE, drawPreview);
	
	// setup the skin choose button
	skinController.addEventListener(LoadingEvent.PROGRESS, loadingHandler);
	skinController.addEventListener(LoadingEvent.COMPLETE, loadingCompleteHandler);
	skinController.addEventListener(ErrorEvent.ERROR, errorHandler);
	skinController.addEventListener(ProcessEvent.COMPLETE, drawPreview);
	
	// preview setup
	preview = new Preview();				
	canvas.rawChildren.addChild(preview);
	
	nav = new PageNavigation(this);
	saveControl = new PageSaveControllerPDF(this);
	config = new Config(this);
	config.loadDefault();
}


public function drawPreview (e:ProcessEvent = null):void
{
	preview.clear();
	nextBtn.enabled = false;
	
	// if data is valid, generate preview
	if (dataController.isDataProvided && skinController.isSkinSelected && typeController.selectedIndex != 0)
	{
		// if the page is already exist, nullify
		if (page != null)
			page.stop();
		
		var sortBy:String = '';
		if (typeController.selectedIndex == 1)					
			sortBy = 'title';
		
		else if (typeController.selectedIndex == 2)					
			sortBy = 'artist';		
				
		var doSort:Boolean = (sort.selected)? true : false;
		var songData:Array = dataController.getSongData(doSort, sortBy);
		data = songData; // need this to be global for later writing to a file
		
		
		page = new Page(50, pageNum);
		page.addEventListener(ProcessEvent.INIT, displayMsg);
		page.addEventListener(LoadingEvent.PROGRESS, loadingHandler);
		page.addEventListener(LoadingEvent.COMPLETE, loadingCompleteHandler);
		page.addEventListener(ErrorEvent.ERROR, errorHandler);
		page.addEventListener(ProcessEvent.COMPLETE, nav.enable);
		page.addEventListener(PageEvent.COMPLETE, pagesParsed);
		draw();
		
		preview.addChild(page);
	}
}

public function draw():void
{
	var sortBy:String = '';
	if (typeController.selectedIndex == 1)					
		sortBy = 'title';
		
	else if (typeController.selectedIndex == 2)					
		sortBy = 'artist';	
	
	page.draw(data, dataController.titleIndex, dataController.numberIndex, dataController.artistIndex, skinController.url, sortBy, alphabet.selected ,grid.selected, gridColor.selectedColor, 
	numRows.value, numColumns.value, Number(headingHeight.text), Number(footerHeight.text) ,
	Number(marginTop.text) , Number(marginBottom.text), Number(marginLeft.text), Number(marginRight.text),
	headingText.text, headingFont.selectedItem.toString(), headingColor.selectedColor, headingSize.value,
	tanFont.selectedItem.toString(), tanColor.selectedColor, tanSize.value, titleFont.selectedItem.toString(), titleColor.selectedColor, titleSize.value,
	artistFont.selectedItem.toString(), artistColor.selectedColor, artistSize.value, numberFont.selectedItem.toString(), numberColor.selectedColor, numberSize.value,
	footerLeftText.text, footerFont.selectedItem.toString(), footerColor.selectedColor, footerSize.value,
	footerRightText.text, footerFont.selectedItem.toString(), footerColor.selectedColor, footerSize.value,
	byFont.selectedItem.toString(), byColor.selectedColor, bySize.value, pagesCache);
}



private function reset() : void
{
	dataController.reset();
	skinController.reset();
	typeController.selectedIndex = 0;
	
	pagesCache = null;
	config.loadDefault();
		
	enableControls();
	drawPreview();
	nav.disable();
	
	saveControl.reset();	
}

public function enableControls(e:Event=null):void
{
	dataController.enabled=skinController.enabled=typeController.enabled=sort.enabled=alphabet.enabled=grid.enabled=gridColor.enabled=
	numRows.enabled=numColumns.enabled=marginTop.enabled=marginBottom.enabled=marginLeft.enabled=marginRight.enabled=headingText.enabled=
	headingFont.enabled=headingColor.enabled=headingSize.enabled=headingHeight.enabled=byFont.enabled=byColor.enabled=bySize.enabled=
	tanFont.enabled=tanColor.enabled=tanSize.enabled=titleFont.enabled=titleColor.enabled=titleSize.enabled=artistFont.enabled=
	artistColor.enabled=artistSize.enabled=numberFont.enabled=numberColor.enabled=numberSize.enabled=footerLeftText.enabled=
	footerRightText.enabled=footerFont.enabled=footerColor.enabled=footerSize.enabled=footerHeight.enabled=loadConfigBtn.enabled=
	saveConfigBtn.enabled=resetBtn.enabled=nextBtn.enabled=canvas.enabled=firstPageBtn.enabled=prevPageBtn.enabled=curPageInput.enabled=
	nextPageBtn.enabled=lastPageBtn.enabled = true;
}


public function disableControls(e:Event=null):void
{
	dataController.enabled=skinController.enabled=typeController.enabled=sort.enabled=alphabet.enabled=grid.enabled=gridColor.enabled=
	numRows.enabled=numColumns.enabled=marginTop.enabled=marginBottom.enabled=marginLeft.enabled=marginRight.enabled=headingText.enabled=
	headingFont.enabled=headingColor.enabled=headingSize.enabled=headingHeight.enabled=byFont.enabled=byColor.enabled=bySize.enabled=
	tanFont.enabled=tanColor.enabled=tanSize.enabled=titleFont.enabled=titleColor.enabled=titleSize.enabled=artistFont.enabled=
	artistColor.enabled=artistSize.enabled=numberFont.enabled=numberColor.enabled=numberSize.enabled=footerLeftText.enabled=
	footerRightText.enabled=footerFont.enabled=footerColor.enabled=footerSize.enabled=footerHeight.enabled=loadConfigBtn.enabled=
	saveConfigBtn.enabled=resetBtn.enabled=nextBtn.enabled=canvas.enabled=firstPageBtn.enabled=prevPageBtn.enabled=curPageInput.enabled=
	nextPageBtn.enabled=lastPageBtn.enabled = false;
}



private function pagesParsed(event:PageEvent) : void
{
	pagesCache = event.target.pages;	
}



public function errorMsg(t:String):void
{
	msgBox.setStyle("color", "0xFF0000");
	msgBox.text = t;
}

public function errorHandler(event:ErrorEvent) : void
{
	msgBox.setStyle("color", "0xFF0000");
	msgBox.text = event.text;				
}

private function loadingHandler(e:LoadingEvent) : void
{
	loadingBar.visible = true;
	var percent:String = Math.round(e.bytesLoaded / e.bytesTotal * 100).toString()
	loadingBar.setProgress(e.bytesLoaded, e.bytesTotal);
	var t:String = e.text + " : " + percent + "%";
	loadingBar.label = e.text + " : " + percent + "%";
	message(t);				
}

private function loadingCompleteHandler(event:LoadingEvent) : void
{
	loadingBar.visible = false;
	message(event.text);				
}


private function displayMsg(e:*):void
{
	msgBox.setStyle("color", "0x000066");
	msgBox.text = e.text;
}


public function message(t:String) : void
{
	msgBox.setStyle("color", "0x000066");
	msgBox.text = t;				
}




