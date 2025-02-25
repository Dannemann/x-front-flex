package br.com.dannemann.gui.component.addressing.brazil
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	
	import spark.components.Group;
	
	import br.com.dannemann.gui.component.input.DInput;
	import br.com.dannemann.gui.component.DBitmapImage;
	import br.com.dannemann.gui.component.DLabel;
	import br.com.dannemann.gui.component.DNotificator;
	import br.com.dannemann.gui.component.container.DGridItem;
	import br.com.dannemann.gui.component.input.DTextInput;
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.library.DIconLibrary;

	public class DAddressFormBrazil2 extends Grid implements DInput
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Properties:
		
		// -------------------------------------------------------------------------
		// Features:
		
		// -------------------------------------------------------------------------
		// Components:
		
		// Inputs:
		public const _cepInput:DTextInputCepSearch = new DTextInputCepSearch();
		public const _ufInput:DDropDownListUf = new DDropDownListUf();
		public const _localidadeInput:DTextInput = new DTextInput();
		public const _bairroInput:DTextInput = new DTextInput();
		public const _logradouroInput:DTextInput = new DTextInput();
		public const _numeroInput:DTextInput = new DTextInput();
		public const _complementoInput:DTextInput = new DTextInput();
		
		public const _searchButton:Group = new Group();
		public const _searchImg:DBitmapImage = new DBitmapImage(DIconLibrary.GOOGLE);
		public const _cancelSearchImg:DBitmapImage = new DBitmapImage(DIconLibrary.REMOVE);
		
		// Labels:
		public const _cepLabel:DLabel = new DLabel(StrConsts._STR_CEP, true);
		public const _ufLabel:DLabel = new DLabel(StrConsts._STR_UF, true);
		public const _localidadeLabel:DLabel = new DLabel(StrConsts.getRMString(81), true);
		public const _bairroLabel:DLabel = new DLabel(StrConsts.getRMString(83), true);
		public const _logradouroLabel:DLabel = new DLabel(StrConsts.getRMString(82), true);
		public const _numeroLabel:DLabel = new DLabel(StrConsts.getRMString(86), true);
		public const _complementoLabel:DLabel = new DLabel(StrConsts.getRMString(84), true);
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Constructor:
		
		public function DAddressFormBrazil2()
		{
			_cepInput._onBeforeSearch = onBeforeSearch;
			_cepInput._onSearchSuccess = onSearchSuccess;
			_cepInput._onSearchCanceled = onSearchCanceled;
			_cepInput._onSearchFail = onSearchFail;
			
			_searchButton.buttonMode = true;
			_searchButton.addElement(_searchImg); // Adding this element in the constructor because it's initialization only.
			_searchButton.addEventListener(MouseEvent.CLICK, onSearchButtonClick, false, 0, true);
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// UIComponent overrides:
		
		override public function initialize():void
		{
			super.initialize();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			buildLayout1();
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// DIGUIInput implementations:
		
		public function get text():String
		{
			return ""; // TODO: IMPLEMENT THIS.
		}
		
		public function set text(value:String):void
		{
			// TODO: IMPLEMENT THIS.
		}
		
		public function clean():void
		{
			_cepInput.clean();
			_ufInput.clean();
			_localidadeInput.clean();
			_bairroInput.clean();
			_logradouroInput.clean();
			_numeroInput.clean();
			_complementoInput.clean();
		}
		
		public function dispose():void
		{
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Layout builders:
		
		// Layout 1:
		
		protected function buildLayout1():void
		{
			configLayout1Components();
			
			// Row 1:
			
			const cepLabelGi:DGridItem = new DGridItem();
			setHorizontalAlignRight(cepLabelGi);
			cepLabelGi.addElement(_cepLabel);
			
			const row1Gi:DGridItem = new DGridItem();
			row1Gi.percentWidth = 100;
			row1Gi.addElement(_cepInput);
			row1Gi.addElement(_ufLabel);
			row1Gi.addElement(_ufInput);
			row1Gi.addElement(_localidadeLabel);
			row1Gi.addElement(_localidadeInput);
			
			// The row.
			const row1:GridRow = new GridRow();
			row1.percentWidth = 100;
			row1.addElement(cepLabelGi);
			row1.addElement(row1Gi);
			
			addElement(row1);
			
			// Row 2:
			
			const logradouroLabelGi:DGridItem = new DGridItem();
			setHorizontalAlignRight(logradouroLabelGi);
			logradouroLabelGi.addElement(_logradouroLabel);
			
			const row2Gi:DGridItem = new DGridItem();
			row2Gi.percentWidth = 100;
			row2Gi.addElement(_logradouroInput);
			row2Gi.addElement(_searchButton);
			row2Gi.addElement(_bairroLabel);
			row2Gi.addElement(_bairroInput);
			
			// The row.
			const row2:GridRow = new GridRow();
			row2.percentWidth = 100;
			row2.addElement(logradouroLabelGi);
			row2.addElement(row2Gi);
			
			addElement(row2);
			
			// Row 3:
			
			const numberoLabelGi:DGridItem = new DGridItem();
			setHorizontalAlignRight(numberoLabelGi);
			numberoLabelGi.addElement(_numeroLabel);
			
			const row3Gi:DGridItem = new DGridItem();
			row3Gi.percentWidth = 100;
			row3Gi.addElement(_numeroInput);
			row3Gi.addElement(_complementoLabel);
			row3Gi.addElement(_complementoInput);
			
			// The row.
			const row3:GridRow = new GridRow();
			row3.percentWidth = 100;
			row3.addElement(numberoLabelGi);
			row3.addElement(row3Gi);
			
			addElement(row3);
		}
		
		protected function configLayout1Components():void
		{
			_ufInput.abbreviatedLabels = true;
			_ufInput.percentWidth = 30;
			
			_localidadeInput.maxChars = 70;
			_localidadeInput.percentWidth = 70;
			
			_logradouroInput.maxChars = 70;
			_logradouroInput.percentWidth = 60;
			
			_bairroInput.maxChars = 50;
			_bairroInput.percentWidth = 40;
			
			_numeroInput.maxChars = 10;
			_numeroInput.width = 60;
			
			_complementoInput.maxChars = 50;
			_complementoInput.percentWidth = 100;
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// CEP search:
		
		// -------------------------------------------------------------------------
		// Public:
		
		public function findAddress(addressVo:AddressVo):void
		{
			_cepInput.findAddress(addressVo);
		}
		
		public function cancelSearch(event:Event=null):void
		{
			_cepInput.cancelSearch(event);
		}
		
		// -------------------------------------------------------------------------
		// Protected:
		
		protected function onSearchButtonClick(event:Event):void
		{
			if (_searchImg.parent)
				onFindAddress(event);
			else if (_cancelSearchImg)
				cancelSearch(event);
		}
		
		protected function onFindAddress(event:Event):void
		{
			_cepInput.clean();
			
			const addressVo:AddressVo = new AddressVo();
			addressVo.uf = _ufInput.text;
			addressVo.localidade = _localidadeInput.text;
			addressVo.logradouro = _logradouroInput.text;
			
			validateLogradouroSearchObj(addressVo);
			
			findAddress(addressVo);
		}
		
		protected function onBeforeSearch(addressVo:AddressVo):void
		{
			enableSearchMode();
		}
		
		protected function onSearchSuccess(addressVo:Object):void
		{
			handleSearchResult(addressVo);
			disableSearchMode();
		}
		
		protected function onSearchCanceled():void
		{
			disableSearchMode();
		}
		
		protected function onSearchFail(event:ErrorEvent):void
		{
			disableSearchMode();
		}
		
		protected function enableSearchMode():void
		{
			_ufInput.enabled = false;
			_localidadeInput.enabled = false;
			_bairroInput.enabled = false;
			_logradouroInput.enabled = false;
			
			if (_searchImg.parent)
				_searchButton.removeElement(_searchImg);
			
			if (!_cancelSearchImg.parent)
				_searchButton.addElement(_cancelSearchImg);
			
//			_searchButton.setFocus(); // TODO: CALL LATER?
		}
		
		protected function disableSearchMode():void
		{
			_ufInput.enabled = true;
			_localidadeInput.enabled = true;
			_bairroInput.enabled = true;
			_logradouroInput.enabled = true;
			
			if (_cancelSearchImg.parent)
				_searchButton.removeElement(_cancelSearchImg);
			
			if (!_searchImg.parent)
				_searchButton.addElement(_searchImg);
			
//			_cepInput.setFocus(); // TODO: CALL LATER?
		}
		
		protected function validateLogradouroSearchObj(addressVo:AddressVo):void
		{
			
		}
		
		/**
		 * <p>Currently implementing ViaCEP web service.</p>
		 * @see https://viacep.com.br
		 */
		protected function handleSearchResult(addressVo:Object):void
		{
			if (addressVo.erro)
				DNotificator.show("CEP INEXISTENTE!!");
			else
			{
				_cepInput.text = addressVo.cep;
				_logradouroInput.text = addressVo.logradouro;
//				_complementoInput.text = addressVo.complemento; // Brings information like "de 240/241 ao fim".
				_bairroInput.text = addressVo.bairro;
				_localidadeInput.text = addressVo.localidade;
				_ufInput.text = addressVo.uf;
//				= addressVo.unidade;
//				= addressVo.ibge;
//				= addressVo.gia;
				
			}
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Private:
		
		// TODO: ADD THIS TO A STYLE UTIL CLASS.
		private function setHorizontalAlignRight(gridItem:GridItem):void
		{
			gridItem.setStyle(StrConsts._FLEX_STYLE_PROPERTY_HORIZONTAL_ALIGN, StrConsts._FLEX_STYLE_VALUE_RIGHT);
		}
		
		// -------------------------------------------------------------------------
	}
}