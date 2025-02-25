package br.com.dannemann.gui.component.adg
{
	import br.com.dannemann.gui.component.DCrudToolbar;
	import br.com.dannemann.gui.component.adg.plugin.DADGToolBar;
	import br.com.dannemann.gui.component.container.DVGroup;
	import br.com.dannemann.gui.controller.EntityDescriptor;

	import mx.core.UIComponent;

	public final class DADGFull extends DVGroup
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		public var _entityBeanDescriptorsHandler:EntityDescriptor;
		public var _dCRUDToolBar:DCrudToolbar;
		public var _useToolBar:Boolean = true;
		//public var _useFilters:Boolean = true;

		// Auto populated.
		public var _dADGToolBar:DADGToolBar;
		public var _dADG:DADG;

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Constructor:

		public function DADGFull()
		{
			_dADGToolBar = new DADGToolBar();
			_dADG = new DADG();

			_dADGToolBar._dADG = _dADG;
			_dADG._dADGToolBar = _dADGToolBar;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		//----------------------------------------------------------------------
		// Class Overrides:

		override protected function createChildren():void
		{
			super.createChildren();

			gap = 0;
			paddingBottom = 0;
			paddingLeft = 0;
			paddingRight = 0;
			paddingTop = 0;

			if (_useToolBar)
			{
				_dADGToolBar._entityBeanDescriptorsHandler = _entityBeanDescriptorsHandler;
				_dADGToolBar._dCRUDToolBar = _dCRUDToolBar;
				_dADGToolBar.percentWidth = 100;
				addElement(_dADGToolBar);
			}

			_dADG.percentWidth = 100;
			_dADG.percentHeight = 100;

			addElement(_dADG);
		}

		//----------------------------------------------------------------------
		// DIGUI implementation:

		public function dispose():void
		{
			_dADGToolBar.dispose();
			_dADG.dispose();
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Public interface:

		public function add4ExcludeOnTableMode(component:UIComponent):void
		{
			if (!_dADGToolBar._excludeFromTableMode)
				_dADGToolBar._excludeFromTableMode = new Vector.<UIComponent>();

			_dADGToolBar._excludeFromTableMode.push(component);
		}

		public function add4DisableOnTableMode(component:UIComponent):void
		{
			if (!_dADGToolBar._disableFromTableMode)
				_dADGToolBar._disableFromTableMode = new Vector.<UIComponent>();

			_dADGToolBar._disableFromTableMode.push(component);
		}

		//----------------------------------------------------------------------
		// _dADG Wrappers:

		// Wrapper - Public interface:

		public function cleanFilters():void
		{
			_dADG.cleanFilters();
		}

		public function updateDADGToolBarNumberOfEntriesLabelToLoading():void
		{
			_dADG.updateDADGToolBarNumberOfEntriesLabelToLoading();
		}

		public function updateDADGToolBarNumberOfEntriesLabel(dataProviderLength:int):void
		{
			_dADG.updateDADGToolBarNumberOfEntriesLabel(dataProviderLength);
		}

		public function setNewTempDataProviderAndCleanFilters():void
		{
			_dADG.setNewTempDataProviderAndCleanFilters();
		}

		// Wrapper - Getters and setters:

		public function get columns():Array
		{
			return _dADG.columns;
		}

		public function set columns(value:Array):void
		{
			_dADG.columns = value;
		}

		public function get groupedColumns():Array
		{
			return _dADG.groupedColumns;
		}

		public function set groupedColumns(value:Array):void
		{
			_dADG.groupedColumns = value;
		}

		public function get dataProvider():Object
		{
			return _dADG.dataProvider;
		}

		public function set dataProvider(value:Object):void
		{
			_dADG.dataProvider = value;
		}

		public function get selectedItem():Object
		{
			return _dADG.selectedItem;
		}

		public function set selectedItem(data:Object):void
		{
			_dADG.selectedItem = data;
		}

		//----------------------------------------------------------------------
	}
}
