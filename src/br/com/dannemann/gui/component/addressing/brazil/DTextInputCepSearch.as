package br.com.dannemann.gui.component.addressing.brazil
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import spark.components.Group;
	import spark.layouts.VerticalAlign;
	
	import br.com.dannemann.gui.component.input.DInput;
	import br.com.dannemann.gui.component.DBitmapImage;
	import br.com.dannemann.gui.component.DNotificator;
	import br.com.dannemann.gui.component.container.DHGroup;
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.library.DIconLibrary;

	public class DTextInputCepSearch extends DHGroup implements DInput//, DIValidatableComponent
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Properties:
		
		// -------------------------------------------------------------------------
		// Features:

		/**
		 * @default true
		 */
		public var _enableSearchWhen8CharsTyped:Boolean;
		
		public var _onBeforeSearch:Function;
		public var _onSearchCanceled:Function;
		public var _onSearchSuccess:Function;
		public var _onSearchFail:Function;
		
		// -------------------------------------------------------------------------
		// Components:

		protected static const _SEARCH_URL_DOMAIN:String = "https://viacep.com.br/ws/";
		protected static const _SEARCH_URL_RETURN_TYPE:String = "/json";
		
		public const _cepInput:DTextInputCep = new DTextInputCep();
		public const _searchButton:Group = new Group();
		public const _searchImg:DBitmapImage = new DBitmapImage(DIconLibrary.GOOGLE);
		public const _cancelSearchImg:DBitmapImage = new DBitmapImage(DIconLibrary.REMOVE);
		
		protected var _urlLoader:URLLoader;
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Constructor:
		
		public function DTextInputCepSearch()
		{
			verticalAlign = VerticalAlign.MIDDLE;
			
			_enableSearchWhen8CharsTyped = true;

			_searchImg.addEventListener(MouseEvent.CLICK, findAddressByCep, false, 0, true);
			_cancelSearchImg.addEventListener(MouseEvent.CLICK, cancelSearch, false, 0, true);
			
			_searchButton.buttonMode = true;
			_searchButton.addElement(_searchImg); // Adding this element in the constructor because it's initialization only.
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// UIComponent overrides:
		
		override public function initialize():void
		{
			if (_enableSearchWhen8CharsTyped)
				_cepInput.addEventListener(KeyboardEvent.KEY_UP, listen8CepChars, false, 0, true);
			
			super.initialize();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			addElement(_cepInput);
			addElement(_searchButton);
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// DIGUIInput implementations:
		
		public function get text():String
		{
			return _cepInput.text;
		}
		
		public function set text(value:String):void
		{
			_cepInput.text = value;
		}
		
		public function clean():void
		{
			finalizeSearch();
			_cepInput.clean();
		}
		
		public function dispose():void
		{
			_searchImg.removeEventListener(MouseEvent.CLICK, findAddressByCep);
			_cancelSearchImg.removeEventListener(MouseEvent.CLICK, cancelSearch);
			_cepInput.removeEventListener(KeyboardEvent.KEY_UP, listen8CepChars);
			
			disposeUrlLoader();
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// CEP search:
	
		// -------------------------------------------------------------------------
		// Public:
		
		public function findAddress(addressVo:AddressVo):void
		{
			enableSearchMode();
			
			if (_onBeforeSearch != null)
				_onBeforeSearch(addressVo);
			
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onSearchSuccess, false, 0, true);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onSearchFail, false, 0, true);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSearchFail, false, 0, true);
			_urlLoader.load(new URLRequest(buildSearchURL(addressVo)));
		}
		
		public function cancelSearch(event:Event=null):void
		{
			finalizeSearch();
			
			if (_onSearchCanceled != null)
				_onSearchCanceled();
		}
		
		// -------------------------------------------------------------------------
		// Protected:
		
		protected function listen8CepChars(event:KeyboardEvent):void
		{
			if (_cepInput.text.length == 8)
				findAddressByCep(event);
		}
		
		protected function findAddressByCep(event:Event):void
		{
			const addressVo:AddressVo = new AddressVo();
			addressVo.cep = _cepInput.text;
			
			findAddress(addressVo);
		}
		
		protected function onSearchSuccess(event:Event):void 
		{
			finalizeSearch();
			
			if (_onSearchSuccess != null)
				_onSearchSuccess(JSON.parse(event.target.data));
		}
		
		protected function onSearchFail(event:ErrorEvent):void
		{
			finalizeSearch();
			
			if (_onSearchFail != null)
				_onSearchFail(event);
		}
		
		protected function finalizeSearch():void
		{
			disposeUrlLoader();
			disableSearchMode();
		}
		
		protected function buildSearchURL(addressVo:AddressVo):String
		{
			var finalUrl:String = _SEARCH_URL_DOMAIN;
			
			if (addressVo.cep)
				finalUrl += addressVo.cep;
			else if (addressVo.uf && addressVo.localidade && addressVo.logradouro)
			{
				if (addressVo.uf.length != 2)
					DNotificator.show("MINIMO 2 CARACTERES BUSCA uf"); // TODO: WORK ON THIS.
				else if (addressVo.localidade.length < 3)
					DNotificator.show("MINIMO 3 CARACTERES BUSCA localidade"); // TODO: WORK ON THIS.
				else if (addressVo.logradouro.length < 3)
					DNotificator.show("MINIMO 3 CARACTERES BUSCA logradouro"); // TODO: WORK ON THIS.
				else
					finalUrl += addressVo.uf + StrConsts._CHAR_FORWARD_SLASH + addressVo.localidade + StrConsts._CHAR_FORWARD_SLASH + addressVo.logradouro;
			}
			
			return finalUrl + _SEARCH_URL_RETURN_TYPE;
		}
		
		protected function disposeUrlLoader():void
		{
			if (_urlLoader)
			{
				_urlLoader.removeEventListener(Event.COMPLETE, onSearchSuccess); // TODO: DO I NEED THIS (AS I AM CALLING CLOSE() RIGHT AFTER)?
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onSearchFail); // TODO: DO I NEED THIS (AS I AM CALLING CLOSE() RIGHT AFTER)?
				_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSearchFail); // TODO: DO I NEED THIS (AS I AM CALLING CLOSE() RIGHT AFTER)?
				_urlLoader.close();
				_urlLoader = null;
			}
		}
		
		protected function enableSearchMode():void
		{
			_cepInput.enabled = false;
			
			if (_searchImg.parent)
				_searchButton.removeElement(_searchImg);
			
			if (!_cancelSearchImg.parent)
				_searchButton.addElement(_cancelSearchImg);
			
//			_searchButton.setFocus(); // TODO: CALL LATER?
		}
		
		protected function disableSearchMode():void
		{
			if (_cancelSearchImg.parent)
				_searchButton.removeElement(_cancelSearchImg);
			
			if (!_searchImg.parent)
				_searchButton.addElement(_searchImg);
			
			_cepInput.enabled = true;
//			_cepInput.setFocus(); // TODO: CALL LATER?
		}
		
		// -------------------------------------------------------------------------
	}
}
