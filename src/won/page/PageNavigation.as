package won.page
{
	import flash.events.Event;

	public class PageNavigation
	{
		private var _app:Object;
		
		public function PageNavigation(application:Object)
		{
			// set up the application where this pageNavigation is belong to
			_app = application;			
		}
		
		public function enable(e:Event = null):void
		{			
			_app.curPageInput.text = _app.pageNum.toString();
			_app.totalPages = _app.page.totalPages;
			_app.totalPagesLbl.text = _app.totalPages.toString();
			
			if (_app.pageNum > _app.totalPages)
			{
				_app.curPageInput.text = _app.totalPages.toString();
				_app.pageNum = _app.totalPages;
			}
			
			_app.firstPageBtn.enabled = 
			_app.prevPageBtn.enabled = 
			_app.curPageInput.enabled = 
			_app.nextPageBtn.enabled = 
			_app.lastPageBtn.enabled = true;
			
			if (!_app.nextBtn.enabled)
				_app.nextBtn.enabled = true;			
		}
		
		
		public function disable(e:Event = null) : void
		{			
			_app.totalPages = 0;
			_app.totalPagesLbl.text = "0";
			
			_app.pageNum = 1;
			_app.curPageInput.text = "0";
			
			_app.firstPageBtn.enabled = 
			_app.prevPageBtn.enabled = 
			_app.curPageInput.enabled = 
			_app.nextPageBtn.enabled = 
			_app.lastPageBtn.enabled = false;
			
			if (_app.nextBtn.enabled)
				_app.nextBtn.enabled = false;				
		}
		
		public function navigate(e:Event = null) : void
		{
			switch (e.target.id)
			{
				case 'firstPageBtn' :
					_app.pageNum = 1;
					break;
				
				case 'lastPageBtn' :
					_app.pageNum = _app.totalPages;
					break;
				
				case 'prevPageBtn' :
					var prevNum:int = _app.pageNum - 1;
					_app.pageNum = (prevNum > 0) ? prevNum : 1;
					break;
				
				case 'nextPageBtn' :
					var nextNum:int = _app.pageNum + 1;
					_app.pageNum = (nextNum > _app.totalPages) ? _app.totalPages : nextNum;
					break;
				
				case 'curPageInput' :
					if ( (int(e.target.text) > 0 && int(e.target.text) <= _app.page.totalPages) && (String(e.target.text).indexOf(".") == -1) )
						_app.pageNum = int(e.target.text);
					else 
					{
						_app.curPageInput.text = '';
						return; // break out of the function
					}
					break;
				
				default :
					return;
					break;
			}			
			_app.curPageInput.text = _app.pageNum.toString();
			_app.drawPreview();
			
		}
					
	}
}