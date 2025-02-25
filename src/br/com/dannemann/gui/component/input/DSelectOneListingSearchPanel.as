package br.com.dannemann.gui.component.input
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.containers.ControlBar;
	import mx.containers.TitleWindow;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.VGroup;
	
	import br.com.dannemann.gui.XFrontConfigurator;
	import br.com.dannemann.gui.bean.DSolSearchPanelBean;
	import br.com.dannemann.gui.bean.FieldDescriptorBean;
	import br.com.dannemann.gui.component.DConditionalForm;
	import br.com.dannemann.gui.component.DCrudToolbar;
	import br.com.dannemann.gui.component.DFastSearcher;
	import br.com.dannemann.gui.component.DLinkButtonSave;
	import br.com.dannemann.gui.component.DLinkButtonSearch;
	import br.com.dannemann.gui.component.DNotificator;
	import br.com.dannemann.gui.component.adg.DADGColumn;
	import br.com.dannemann.gui.component.adg.DADGFull;
	import br.com.dannemann.gui.component.container.DHGroup;
	import br.com.dannemann.gui.controller.DSession;
	import br.com.dannemann.gui.controller.EntityDescriptor;
	import br.com.dannemann.gui.controller.ServerVarsDecoder;
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.dto.persistence.Request;
	import br.com.dannemann.gui.event.DADGToolBarEvent;
	import br.com.dannemann.gui.library.DIconLibrary;
	import br.com.dannemann.gui.util.DUtilDataProvider;
	import br.com.dannemann.gui.util.DUtilDescriptor;
	import br.com.dannemann.gui.util.DUtilStringTransformer;

	// TODO: REMOVER TODOS OS "EVENT LISTENERS" NA MÃO!!!
	// CREATE A DISPOSE METHOD.
	internal final class DSelectOneListingSearchPanel
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:
		
		// -------------------------------------------------------------------------
		// Features:
		
		// Back-end services:
		public var _serverDestination:String = XFrontConfigurator._crudServiceDestination;
		public var _executeMethod:String = XFrontConfigurator._executeMethod;
		public var _eagerDataProvider:Array;
		
		
		
		
		
		
		
		
		

		internal var _dBeanSOLSearchPanel:DSolSearchPanelBean = new DSolSearchPanelBean();
		

		
		
		private var _solDataGridColumnsCSV:String;
		private var _solDataGridColumnsCSVIndex:ArrayList;

		private const _crudParameters:Request = new Request();

		// Components:

		internal const _mainSearchPanel:TitleWindow = new TitleWindow();
		internal const _dConditionalForm:DConditionalForm = new DConditionalForm();

		private const _dvGroupMain:VGroup = new VGroup();

		public const _dADGFull:DADGFull = new DADGFull();

		private const _controlBarSearch:ControlBar = new ControlBar();
		private const _dHGroupButtons:DHGroup = new DHGroup();
		private const _dHGroupButtonsLeft:DHGroup = new DHGroup();
		private const _buttonSearchAll:DLinkButtonSearch = new DLinkButtonSearch();
		private const _buttonExecute:DLinkButtonSearch = new DLinkButtonSearch();
		private const _buttonSelect:DLinkButtonSave = new DLinkButtonSave();

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Component creation:
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Constructor:

		public function DSelectOneListingSearchPanel(dBeanDSelectOneListingSearchPanel:DSolSearchPanelBean)
		{
			_dBeanSOLSearchPanel = dBeanDSelectOneListingSearchPanel; // TODO: Use public parameters instead.
		}

		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// UIComponent:

		public function createSearchPanel():TitleWindow
		{
			const descriptorsHandler:EntityDescriptor = _dBeanSOLSearchPanel._entityBeanDescriptorsHandler;

			_dConditionalForm._entityBeanDescriptorsHandler = descriptorsHandler;
			_dConditionalForm._likeDefaults = DUtilStringTransformer.transformation3IntoObject(_dBeanSOLSearchPanel._solLikeDefaults)
			_dConditionalForm.percentWidth = 100;

			if (_dBeanSOLSearchPanel._solDataGridColumnsCSV)
			{
				_solDataGridColumnsCSV = _dBeanSOLSearchPanel._solDataGridColumnsCSV;
				_solDataGridColumnsCSVIndex = DUtilStringTransformer.transformation2IntoArrayList(_dBeanSOLSearchPanel._solDataGridColumnsCSV);

				_dConditionalForm._columnsToSelect = _solDataGridColumnsCSV;
			}

			const fieldDescriptors4QueryCreators:Vector.<FieldDescriptorBean> = descriptorsHandler._domainFields;
			const fieldDesQueryCreatorLength:int = fieldDescriptors4QueryCreators.length;
			const dataGridColumns:Array = new Array();
			for (var i:int = 0; i < fieldDesQueryCreatorLength; i++)
				createDataGridColumn(fieldDescriptors4QueryCreators[i], dataGridColumns);

			// Configurations.

			configureDHGroupButtons();
			configureSelectButton();
			
			configureDHGroupButtonsLeft();
			configureSearchAllButton();
			configureExecuteSearchButton();
			
			configureControlBarSearch();

			configureDADGFull(dataGridColumns);

			configureDVGroupMain();
			configureSearchPanel();
			if (_eagerDataProvider)
				setDataProvider(_eagerDataProvider);
			
			// CRUD params.
			_crudParameters.tenant = DSession._tenant;
			_crudParameters.objectType = descriptorsHandler._crudDescriptor._className;
			_crudParameters._idJavaType = DUtilDescriptor.findIDFieldDescriptor(_dBeanSOLSearchPanel._entityBeanDescriptorsHandler)._javaType;
			_crudParameters._columnsForHibernateSelectCSV = _dBeanSOLSearchPanel._columnsForHibernateSelectCSV;
			_crudParameters._manyToOneEagerColumnsCSV = descriptorsHandler.getManyToOneJavaFieldsOnCSVStr();
			_crudParameters._orderBy = StrConsts._STR_idDesc;
			return _mainSearchPanel;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Private interface:

		//----------------------------------------------------------------------
		// Creation methods:

		private function configureSearchPanel():void
		{
			_mainSearchPanel.title = StrConsts.getRMString(18) + StrConsts._CHAR_COLON_SPACE + ServerVarsDecoder.replaceAllMessageDVars(_dBeanSOLSearchPanel._entityBeanDescriptorsHandler._crudDescriptor._classNameFormatted);
			_mainSearchPanel.titleIcon = DIconLibrary[_dBeanSOLSearchPanel._entityBeanDescriptorsHandler._crudDescriptor._menuIcon];
			_mainSearchPanel.showCloseButton = true;
			_mainSearchPanel.width = 800;
			_mainSearchPanel.height = 500;
			_mainSearchPanel.addElement(_dvGroupMain);
			_mainSearchPanel.addEventListener(FlexEvent.CREATION_COMPLETE, mainSearchPanelCreationCompleted, false, 0, true);
			_mainSearchPanel.addEventListener(Event.ADDED_TO_STAGE, mainSearchPanelAddedToStage, false, 0, true);
			_mainSearchPanel.addEventListener(KeyboardEvent.KEY_DOWN, mainSearchPanelEscPressed, false, 0, true);
		}

		private function configureDVGroupMain():void
		{
			_dvGroupMain.paddingBottom = 5;
			_dvGroupMain.paddingLeft = 5;
			_dvGroupMain.paddingRight = 5;
			_dvGroupMain.paddingTop = 5;
			_dvGroupMain.percentWidth = 100;
			_dvGroupMain.percentHeight = 100;
			_dvGroupMain.addElement(_dConditionalForm);
			_dvGroupMain.addElement(_dADGFull);
			_dvGroupMain.addElement(_controlBarSearch);
		}

		// DADGFull:

		private function configureDADGFull(columns:Array):void
		{
			const dCRUDToolBar:DCrudToolbar = new DCrudToolbar();
			dCRUDToolBar._entityDescriptor = _dBeanSOLSearchPanel._entityBeanDescriptorsHandler;
			dCRUDToolBar._advancedDataGridToolBar = _dADGFull._dADGToolBar;
			dCRUDToolBar._advancedDataGrid = _dADGFull._dADG;
			dCRUDToolBar._isThisInstanceAddedToStage = false;

			_dADGFull._dADGToolBar.addEventListener(DADGToolBarEvent._ON_CHANGING_TO_TREE_MODE, onToolBarChangeToTreeMode, false, 0, true);
			_dADGFull._dADGToolBar.addEventListener(DADGToolBarEvent._ON_EXIT_TREE_MODE, onExitTreeMode, false, 0, true);

			_dADGFull._entityBeanDescriptorsHandler = _dBeanSOLSearchPanel._entityBeanDescriptorsHandler;
			_dADGFull._dCRUDToolBar = dCRUDToolBar;
			_dADGFull._useToolBar = true;
			_dADGFull.columns = columns;
			_dADGFull.percentWidth = 100;
			_dADGFull.percentHeight = 100;
			_dADGFull.add4DisableOnTableMode(_buttonExecute);
			_dADGFull.add4ExcludeOnTableMode(_dConditionalForm);

			_dADGFull._dADG.doubleClickEnabled = true;
			_dADGFull._dADG.addEventListener(MouseEvent.DOUBLE_CLICK, itemDoubleClicked, false, 0, true);
		}

		// ControlBar:

		private function configureControlBarSearch():void
		{
			_controlBarSearch.percentWidth = 100;
			_controlBarSearch.addElement(_dHGroupButtonsLeft);
		}

		private function configureDHGroupButtonsLeft():void
		{
			_dHGroupButtonsLeft.percentWidth = 100;
			_dHGroupButtonsLeft.horizontalAlign = StrConsts._FLEX_STYLE_VALUE_LEFT;
			_dHGroupButtonsLeft.addElement(_dHGroupButtons);
		}

		private function configureSearchAllButton():void
		{
			_buttonSearchAll.label = StrConsts.getRMString(34);

			const imgSearchAllWrapper:DHGroup = new DHGroup();
			imgSearchAllWrapper.buttonMode = true;
			imgSearchAllWrapper.addElement(_buttonSearchAll);
			imgSearchAllWrapper.addEventListener(MouseEvent.CLICK, actionSearchAll, false, 0, true);

			_dHGroupButtonsLeft.addElement(imgSearchAllWrapper);
		}

		private function configureExecuteSearchButton():void
		{
			const imgExecuteWrapper:DHGroup = new DHGroup();
			imgExecuteWrapper.buttonMode = true;
			imgExecuteWrapper.addElement(_buttonExecute);
			imgExecuteWrapper.addEventListener(MouseEvent.CLICK, actionSearch, false, 0, true);

			_dHGroupButtonsLeft.addElement(imgExecuteWrapper);
		}

		private function configureDHGroupButtons():void
		{
			_dHGroupButtons.percentWidth = 100;
			_dHGroupButtons.horizontalAlign = StrConsts._FLEX_STYLE_VALUE_LEFT;
		}

		private function configureSelectButton():void
		{
			_buttonSelect.label = StrConsts.getRMString(36);

			const imgSelectWrapper:DHGroup = new DHGroup();
			imgSelectWrapper.buttonMode = true;
			imgSelectWrapper.addElement(_buttonSelect);
			imgSelectWrapper.addEventListener(MouseEvent.CLICK, onSelectButtonClicked, false, 0, true);

			_dHGroupButtons.addElement(imgSelectWrapper);
		}

		//----------------------------------------------------------------------
		// Event listeners:

		private function mainSearchPanelCreationCompleted(event:FlexEvent):void
		{
			_mainSearchPanel.removeEventListener(FlexEvent.CREATION_COMPLETE, mainSearchPanelCreationCompleted);
			_mainSearchPanel.mx_internal::closeButton.addEventListener(MouseEvent.CLICK, close, false, 0, true);
		}

		private function mainSearchPanelAddedToStage(event:Event):void
		{
			_dADGFull.cleanFilters();
			_dConditionalForm.reset();
			_mainSearchPanel.callLater(_dConditionalForm.setFocus);
		}

		private function mainSearchPanelEscPressed(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ESCAPE)
				close(event);
		}


		
		
		
		
		
		
		
		
		
		
		
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Search:

		private function actionSearch(event:MouseEvent):void
		{
			_crudParameters.query = _dConditionalForm.mountHQLQuery();

			if (_crudParameters.query)
			{
				_dADGFull.setNewTempDataProviderAndCleanFilters();

				_dBeanSOLSearchPanel._blazeDS.invoke3(_serverDestination, _executeMethod, _crudParameters, setDataProvider);
			}
		}

		private function actionSearchAll(event:MouseEvent):void
		{
			_dHGroupButtonsLeft.enabled = false;

			_crudParameters.query = _dConditionalForm.mountHQLQuery(true);

			if (_eagerDataProvider)
				setDataProvider(_eagerDataProvider);
			else (_crudParameters.query)
			{
				_dADGFull.setNewTempDataProviderAndCleanFilters();
				
				_dBeanSOLSearchPanel._blazeDS.invoke3(_serverDestination, _executeMethod, _crudParameters, setDataProvider);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

		// Advanced data grid:

		private function onToolBarChangeToTreeMode(event:DADGToolBarEvent):void
		{
			_buttonExecute.enabled = false;
		}

		private function onExitTreeMode(event:DADGToolBarEvent):void
		{
			_buttonExecute.enabled = true;
		}

		private function itemDoubleClicked(event:MouseEvent):void
		{
			const target:Object = event.target;

			if (target.hasOwnProperty(StrConsts._STR_data))
			{
				if (target.data)
					setSOLValue(target.data);
				else
					DNotificator.showError2(StrConsts.getRMErrorString("500130"));
			}
		}

		private function onSelectButtonClicked(event:MouseEvent):void
		{
			const selectedItem:Object = _dADGFull.selectedItem;

			if (selectedItem)
				setSOLValue(selectedItem);
			else
				if (_dADGFull.dataProvider)
				{
					if ((_dADGFull.dataProvider as ArrayCollection).length > 0)
						DNotificator.showInfo(StrConsts.getRMString(37));
					else
						DNotificator.showInfo(StrConsts.getRMString(38));
				}
				else
					DNotificator.showInfo(StrConsts.getRMString(38));
		}

		private function setSOLValue(selectedItem:Object):void
		{
			const myOwner:DSelectOneListing = _dBeanSOLSearchPanel._dSelectOneListingParent;
			myOwner.clean();
			myOwner._selectedItem = selectedItem;
			close();
		}

		//----------------------------------------------------------------------
		// Private generic interface:

		private function setDataProvider(response:Object):void
		{
			const returnObj:Array = response.result;
			
			if (returnObj && returnObj.length > 0)
			{
				if (_dADGFull._dADGToolBar.currentState == _dADGFull._dADGToolBar.stateTree.name)
					new DUtilDataProvider(
						_dADGFull._dADG,
						_dBeanSOLSearchPanel._entityBeanDescriptorsHandler._fieldDescriptorFKHolderFor._javaField,
						function ():void
						{
							_dHGroupButtonsLeft.enabled = true;
						}
					).flat2HierarchicalData(returnObj);
				else
				{
					_dADGFull.dataProvider = new ArrayCollection(returnObj);
					_dHGroupButtonsLeft.enabled = true;
				}
			}
			else
			{
				_dADGFull.dataProvider = new ArrayCollection();
				DNotificator.showInfo(StrConsts.getRMString(35));
				_dHGroupButtonsLeft.enabled = true;
			}
		}

		private function createDataGridColumn(descriptor:FieldDescriptorBean, dataGridColumns:Array):void
		{
			const javaField:String = descriptor._dataGridColumn;
			const fieldNameFormatted:String = descriptor._fieldNameFormatted;

			if (_solDataGridColumnsCSV)
			{
				if (_solDataGridColumnsCSV.indexOf(javaField) != -1)
					if (!((_solDataGridColumnsCSV.indexOf("." + javaField)) != -1) || (_solDataGridColumnsCSV.indexOf(javaField + ".") != -1))
						dataGridColumns[_solDataGridColumnsCSVIndex.getItemIndex(javaField)] = createNewPreConfiguredADGC(descriptor);
			}
			else if (_dBeanSOLSearchPanel._solDataGridColumnsToRemoveCSV)
			{
				if (_dBeanSOLSearchPanel._solDataGridColumnsToRemoveCSV.indexOf(javaField) == -1)
					dataGridColumns.push(createNewPreConfiguredADGC(descriptor));
			}
			else
				dataGridColumns.push(createNewPreConfiguredADGC(descriptor));
		}

		public function createNewPreConfiguredADGC(dBeanFieldDescriptor:FieldDescriptorBean):DADGColumn
		{
			if (!dBeanFieldDescriptor._isPasswordField)
				return new DADGColumn(_dADGFull._dADG, dBeanFieldDescriptor);
			else
				return null;
		}

		private function close(event:Event=null):void
		{
			// Workaround for this: http://forums.adobe.com/thread/608212?decorator=print&displayFullThread=true
			_mainSearchPanel.focusManager.mx_internal::lastFocus = null;

			_dADGFull._dADGToolBar.actionCloseGroupByPopUp(); // TODO: DISPOSE THIS WHOLE CLASS!!!

			PopUpManager.removePopUp(_mainSearchPanel);

			if (event)
			{
				event.stopImmediatePropagation();
				event.preventDefault();
			}

			DFastSearcher._locked = false;
		}

		//----------------------------------------------------------------------
	}
}
