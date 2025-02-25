package br.com.dannemann.gui.component.input.complex
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.FontStyle;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.containers.Box;
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.containers.VBox;
	import mx.controls.TextArea;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.events.IndexChangedEvent;
	
	import spark.components.HGroup;
	import spark.components.TextArea;
	import spark.layouts.VerticalAlign;
	
	import br.com.dannemann.gui.bean.DBeanCRUDDescriptor;
	import br.com.dannemann.gui.bean.DBeanFileUploader;
	import br.com.dannemann.gui.bean.DBeanUsingAddressForm;
	import br.com.dannemann.gui.bean.FieldDescriptorBean;
	import br.com.dannemann.gui.component.DCrudToolbar;
	import br.com.dannemann.gui.component.DImage;
	import br.com.dannemann.gui.component.DImageViewerPanoramio;
	import br.com.dannemann.gui.component.DLabel;
	import br.com.dannemann.gui.component.DManyToManyForm;
	import br.com.dannemann.gui.component.DNotificator;
	import br.com.dannemann.gui.component.DRichTextEditor;
	import br.com.dannemann.gui.component.DTabNavigator;
	import br.com.dannemann.gui.component.addressing.brazil.DAddressFormBrazil2;
	import br.com.dannemann.gui.component.addressing.brazil.DTextInputCep;
	import br.com.dannemann.gui.component.adg.DADGColumn;
	import br.com.dannemann.gui.component.adg.DADGFull;
	import br.com.dannemann.gui.component.container.DGridItem4Label;
	import br.com.dannemann.gui.component.container.DVGroup;
	import br.com.dannemann.gui.component.container.mdi.containers.MDIWindow;
	import br.com.dannemann.gui.component.container.mdi.events.MDIWindowEvent;
	import br.com.dannemann.gui.component.input.DCheckBox;
	import br.com.dannemann.gui.component.input.DDateField;
	import br.com.dannemann.gui.component.input.DDropDownList;
	import br.com.dannemann.gui.component.input.DDropDownListBoolean;
	import br.com.dannemann.gui.component.input.DDropDownListGender;
	import br.com.dannemann.gui.component.input.DImageChooser;
	import br.com.dannemann.gui.component.input.DInput;
	import br.com.dannemann.gui.component.input.DSelectOneListing;
	import br.com.dannemann.gui.component.input.DTextInput;
	import br.com.dannemann.gui.component.input.DTextInputCnpj;
	import br.com.dannemann.gui.component.input.DTextInputCpf;
	import br.com.dannemann.gui.component.input.DTextInputID;
	import br.com.dannemann.gui.component.input.DTextInputPassword;
	import br.com.dannemann.gui.component.input.DTextInputPhoneNumber;
	import br.com.dannemann.gui.controller.BlazeDs;
	import br.com.dannemann.gui.controller.DSession;
	import br.com.dannemann.gui.controller.EntityDescriptor;
	import br.com.dannemann.gui.controller.ServerVarsDecoder;
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.event.DCRUDToolBarEvent;
	import br.com.dannemann.gui.event.DUploadDownloadEvent;
	import br.com.dannemann.gui.library.DIconLibrary;
	import br.com.dannemann.gui.util.DUtilComponent;
	import br.com.dannemann.gui.util.DUtilFocus;
	import br.com.dannemann.gui.util.DUtilStringTransformer;
	import br.com.dannemann.gui.util.DUtilTabNavigator;

	public class DCRUDForm extends DVGroup// implements DIGUIInput, DIValidatableInputsManager
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		public var _entityBeanDescriptorsHandler:EntityDescriptor;
		public var _associatedManyToManyProperty:String;
		public var _mdiWindowParent:MDIWindow;
		public var _blazeDS:BlazeDs = new BlazeDs(); // TODO: PQ NAO CRIAR UMA NOVA INSTANCIA ?? FICAR PASSANDO ESSA MESMA INSTANCIA TAH CERTO?

		public var _enableDCRUDToolBarFocus:Boolean = false;
		public var _useDCRUDToolBarSearchButton:Boolean = true;
		public var _useDCRUDToolBarSearchAllButton:Boolean = true;
		public var _useDCRUDToolBarNewButton:Boolean = true;
		public var _useDCRUDToolBarSaveButton:Boolean = true;
		public var _useDCRUDToolBarDeleteButton:Boolean = true;
		public var _useDADGToolBar:Boolean = true;
		public var _listen_ENTER_do_TAB:Boolean = true;

		// Auto filled.

		public const _dCRUDToolBar:DCrudToolbar = new DCrudToolbar();
		public const _dADGFull:DADGFull = new DADGFull();

		public var _dAdgColumns:ArrayCollection = new ArrayCollection();
		public var _formWrapper:UIComponent;
		public var _tabNavigator:DTabNavigator;
		public var _remarksRTE:DRichTextEditor;
		public var _dImageViewerPanoramio:DImageViewerPanoramio;
		public var _firstComponentsForFocus:Vector.<FieldDescriptorBean> = new Vector.<FieldDescriptorBean>();
		public var _visibleDManyToManyForm:DManyToManyForm;
		public var _dCRUDFormsTabs:Vector.<VBox>;
		public var _lastViewedAssocDCRUDForm:DCRUDForm;
		public var _associatedItemLabelIndicator:DLabel;

		public var _dAutoCompleteBugFlag:Boolean; // TODO: WHAT IS THIS???

		// Just for a faster creation.
		private var _currentRunningFieldDescriptor:FieldDescriptorBean;
		private var _currentRunningFieldDescriptorFieldNameFormatted:String;
		private var _currentRunningFieldDescriptorJavaField:String;
		private var _currentRunningFieldDescriptorJavaType:String;
		private var _currentRunningFieldDescriptorNotInsertable:Boolean;
		private var _currentRunningFieldDescriptorRequired:Boolean;
		private var _currentRunningFieldDescriptorRequiredForSearch:Boolean;
		private var _currentRunningFieldDescriptorIsPopulatedWithObjs:Boolean;
		private var _currentSkeletonGrid:Grid;
		private var _currentSkeletonGridRow:GridRow;
		private var _currentFirstComponentStillNotFound:Boolean = true;

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		//----------------------------------------------------------------------
		// Class Overrides:

		override public function set initialized(value:Boolean):void
		{
			super.initialized = value;

			if (value)
				toggleImageUploadTabsEnabled(false);
		}

		override protected function createChildren():void
		{
			super.createChildren();

			if (_entityBeanDescriptorsHandler)
			{
				const dBeanCRUDDescriptor:DBeanCRUDDescriptor = _entityBeanDescriptorsHandler._crudDescriptor;
				const numberOfFormColumns:int = dBeanCRUDDescriptor._numberOfGridColumnsOnForm;
				const tabsNames:Array = dBeanCRUDDescriptor._tabs ? dBeanCRUDDescriptor._tabs.split(",") : [ "NotTabbed" ];
				var isTabbed:Boolean = tabsNames[0] == "NotTabbed" ? false : true;

				// TODO: Finish the address form.
				var dDBeanUsingAddressForm:DBeanUsingAddressForm = null;
				if (dBeanCRUDDescriptor._usingAddressForm)
					dDBeanUsingAddressForm = new DBeanUsingAddressForm(dBeanCRUDDescriptor._usingAddressForm);

				var dataGridColumns:ArrayCollection = null;
				if (dBeanCRUDDescriptor._dataGridColumns != "*")
					dataGridColumns = new ArrayCollection(dBeanCRUDDescriptor._dataGridColumns.split(","));

				// Form creation controls:

				var i:int;
				var j:int;

				if (dBeanCRUDDescriptor)
				{
					_useDCRUDToolBarSearchButton = dBeanCRUDDescriptor._useButtonSearch;
					_useDCRUDToolBarSearchAllButton = dBeanCRUDDescriptor._useButtonSearchAll;
					_useDCRUDToolBarNewButton = dBeanCRUDDescriptor._useButtonInsertNewRow;
					_useDCRUDToolBarSaveButton = dBeanCRUDDescriptor._useButtonSaveOrUpdate;
					_useDCRUDToolBarDeleteButton = dBeanCRUDDescriptor._useButtonExclude;
				}

				

				_tabNavigator = new DTabNavigator();

				var executeOnlyOnFirstTab:Boolean = true;
				var dAddressInputsGrid:DAddressFormBrazil2;
				//var dAddressIndex:String;
				var v:VBox;
				var dVGroupWrapper:DVGroup;
				var counter4RowBreak:int;

				const tabsLength:int = tabsNames.length;
				const fieldsDescriptorsLength:int = _entityBeanDescriptorsHandler._fields.length;
				for (i = 0; i < tabsLength; i++)
				{
					_currentSkeletonGrid = new Grid();
					_currentSkeletonGrid.focusEnabled = false;
					_currentSkeletonGrid.percentWidth = 100;
					_currentSkeletonGridRow = new GridRow();
					_currentSkeletonGridRow.focusEnabled = false;
					_currentSkeletonGridRow.percentWidth = 100;
					descriptor = null;
					counter4RowBreak = 0;

					_dAutoCompleteBugFlag = i > 0 ? true : false;

					for (j = 0; j < fieldsDescriptorsLength; j++)
					{
						_currentRunningFieldDescriptor = _entityBeanDescriptorsHandler._fields[j];

						if (_currentRunningFieldDescriptor._fkHolderFor ||
							_currentRunningFieldDescriptor._searchFieldFor ||
							_currentRunningFieldDescriptor._isVersionField ||
							_currentRunningFieldDescriptor._isOneToMany ||
							_currentRunningFieldDescriptor._isManyToMany ||
							_currentRunningFieldDescriptor._isRemarksField ||
							(_currentRunningFieldDescriptor._javaField == _associatedManyToManyProperty) ||
							(_currentRunningFieldDescriptor._isMainID && dBeanCRUDDescriptor._manyToManyAssocTable))
							continue;

						_currentRunningFieldDescriptorFieldNameFormatted = ServerVarsDecoder.replaceAllMessageDVars(_currentRunningFieldDescriptor._fieldNameFormatted);
						_currentRunningFieldDescriptorJavaField = _currentRunningFieldDescriptor._javaField;
						_currentRunningFieldDescriptorJavaType = _currentRunningFieldDescriptor._javaType;
						_currentRunningFieldDescriptorNotInsertable = !_currentRunningFieldDescriptor._isInsertable;
						_currentRunningFieldDescriptorRequired = !_currentRunningFieldDescriptor._isNullable;
						_currentRunningFieldDescriptorRequiredForSearch = _currentRunningFieldDescriptor._requiredForSearch;
						_currentRunningFieldDescriptorIsPopulatedWithObjs = false;

						if (isTabbed)
						{
							if (_currentRunningFieldDescriptor._tabNavigatorIndex == i)
							{
								if (counter4RowBreak % numberOfFormColumns == 0)
									createNewGridRowInstanceAndAddLastOneToGrid();

								createGridRowLayoutANDCheckIfIsAFirstComponentForFocus();
								counter4RowBreak++;
							}
						}
						else
						{
							if (counter4RowBreak % numberOfFormColumns == 0)
								createNewGridRowInstanceAndAddLastOneToGrid();

							createGridRowLayoutANDCheckIfIsAFirstComponentForFocus();
							counter4RowBreak++;
						}

						// TODO: FINISH THIS (implement when using a "index")!
						if (dDBeanUsingAddressForm)
						{
							if (dDBeanUsingAddressForm._tabNavigatorIndex == i.toString())
							{
								dAddressInputsGrid = new DAddressFormBrazil2();

								/*if (dAddressIndex)
								{
								}
								else
								{*/
									_currentSkeletonGrid = dAddressInputsGrid;
									break;
								//}
							}
						}

						if (executeOnlyOnFirstTab)
						{
							if (dataGridColumns)
							{
								if (dataGridColumns.contains(_currentRunningFieldDescriptorJavaField))
									createDataGridColumn();
							}
							else
								createDataGridColumn(); // All columns.
						}
					} // End of: for (var j:int = 0; j < fieldsDescriptorsLength; j++).

					// Remaining ones...
					if (!dAddressInputsGrid)
						_currentSkeletonGrid.addElement(_currentSkeletonGridRow);

					dVGroupWrapper = new DVGroup();
					dVGroupWrapper.focusEnabled = false;
					dVGroupWrapper.gap = 0;
					dVGroupWrapper.paddingBottom = 7;
					dVGroupWrapper.paddingLeft = 7;
					dVGroupWrapper.paddingRight = 7;
					dVGroupWrapper.paddingTop = 7;
					dVGroupWrapper.percentWidth = 100;
					dVGroupWrapper.addElement(_currentSkeletonGrid);

					v = new VBox();
					v.addElement(dVGroupWrapper);
					v.percentWidth = 100;

					if (isTabbed)
					{
						v.label = ServerVarsDecoder.replaceAllMessageDVars(tabsNames[i]);
						_tabNavigator.addElement(v);
					}

					_currentFirstComponentStillNotFound = true;
					executeOnlyOnFirstTab = false;
				} // End of: for (var i:int = 0; i < tabsLength; i++).

				
				
				// CRUD toolbar.
				_dCRUDToolBar._entityDescriptor = _entityBeanDescriptorsHandler;
				_dCRUDToolBar._advancedDataGridToolBar = _dADGFull._dADGToolBar;
				_dCRUDToolBar._advancedDataGrid = _dADGFull._dADG;
				_dCRUDToolBar._blazeDS = _blazeDS;
				_dCRUDToolBar._useSearchButton = _useDCRUDToolBarSearchButton;
				_dCRUDToolBar._useSearchAllButton = _useDCRUDToolBarSearchAllButton;
				_dCRUDToolBar._useNewButton = _useDCRUDToolBarNewButton;
				_dCRUDToolBar._useSaveButton = _useDCRUDToolBarSaveButton;
				_dCRUDToolBar._useDeleteButton = _useDCRUDToolBarDeleteButton;
				_dCRUDToolBar.focusEnabled = _enableDCRUDToolBarFocus;
				_dCRUDToolBar.listen_CRUDShortcuts(this);
				_dCRUDToolBar.listen_MessageHelper_MaybeInTheIncorrectMode(this);
				
				if (_entityBeanDescriptorsHandler._fieldDescriptorVersion)
					_dCRUDToolBar.addInput(_entityBeanDescriptorsHandler._fieldDescriptorVersion._javaField, new DTextInput());
				
				if (_associatedManyToManyProperty)
					_dCRUDToolBar._associatedManyToManyProperty = _associatedManyToManyProperty;
				
				addElement(_dCRUDToolBar);
				
				_dCRUDToolBar.addEventListener(DCRUDToolBarEvent._ON_CHANGED_TO_INSERT_MODE, onCRUDToolBarChangesToInsertMode, false, 0, true);
				_dCRUDToolBar.addEventListener(DCRUDToolBarEvent._ON_CHANGED_TO_SEARCH_MODE, onCRUDToolBarChangesToSearchMode, false, 0, true);
				_dCRUDToolBar.addEventListener(DCRUDToolBarEvent._ON_CHANGED_TO_UPDATE_MODE, onCRUDToolBarChangesToUpdateMode, false, 0, true);
				_dCRUDToolBar.addEventListener(DCRUDToolBarEvent._ON_CHANGE_SELECTED_ITEM, onCRUDToolBarChangeSelectedItem, false, 0, true);
				
				
				
				
				// TODO: FINISH THIS!!!
				if (dDBeanUsingAddressForm)
				{
					if (dAddressInputsGrid)
					{
						dAddressInputsGrid.percentWidth = 100;
//						dAddressInputsGrid._blazeDS = _blazeDS;
//						dAddressInputsGrid.setValidationMode(dDBeanUsingAddressForm._validationMode);
//						dAddressInputsGrid.addInputsToDCRUDToolBarValidation(_dCRUDToolBar); // TODO: Not an elegant mode.

						const addressInputsDescriptor:FieldDescriptorBean = new FieldDescriptorBean();
						addressInputsDescriptor._javaField = StrConsts._STR_DAddressInput;
						_firstComponentsForFocus.push(addressInputsDescriptor);

						_dCRUDToolBar._objectBeanDictionary[addressInputsDescriptor._javaField] = dAddressInputsGrid; // TODO: Change this.
					}
					else
						throw new Error(" ### DCRUDForm.createChildren: Esta entidade possui dados de endereçamento e o sistema não conseguiu criar o formulário para a inserção destes dados (\"dDBeanUsingAddressForm\" está OK, porém, \"dAddressInputsGrid\" é nulo).");
				}

				// Many to many:

//				const manyToManyFDs:Vector.<DBeanFieldDescriptor> = _entityBeanDescriptorsHandler._manyToManyFieldDescriptors;
//				var mtmForm:DManyToManyForm;
//				if (manyToManyFDs)
//				{
//					const manyToManyFDsLenght:int = manyToManyFDs.length;
//					var mtmFd:DBeanFieldDescriptor;
//					for (i = 0; i < manyToManyFDsLenght; i++)
//					{
//						if (!isTabbed)
//						{
//							v.label = DFxGUIConstants.getRMString(57);
//							_tabNavigator.addElement(v);
//							isTabbed = true;
//						}
//
//						mtmFd = manyToManyFDs[i];
//
//						mtmForm = new DManyToManyForm();
//						mtmForm._description = mtmFd._fieldNameFormatted;
//						mtmForm._tableName = mtmFd._manyToManyTableName;
//						mtmForm._joinColumn = mtmFd._manyToManyJoinColumnName;
//						mtmForm._joinColumnJavaField = mtmFd._javaField;
//						mtmForm._inverseJoinColumn = mtmFd._manyToManyInverseJoinColumnName;
//						mtmForm._entityDescriptorJoinColumn = _entityBeanDescriptorsHandler;
//						mtmForm._entityDescriptorInverseJoinColumn = DSession._entitiesDescriptors[mtmFd._manyToManyTarget];
//						mtmForm.percentWidth = 100;
//
//						_dCRUDToolBar.addDManyToManyForm(mtmForm, mtmFd._javaField);
//
//						_firstComponentsForFocus.push(mtmFd);
//
//						dVGroupWrapper = new DVGroup();
//						dVGroupWrapper.focusEnabled = false;
//						dVGroupWrapper.gap = 0;
//						dVGroupWrapper.paddingBottom = 7;
//						dVGroupWrapper.paddingLeft = 7;
//						dVGroupWrapper.paddingRight = 7;
//						dVGroupWrapper.paddingTop = 7;
//						dVGroupWrapper.percentWidth = 100;
//						dVGroupWrapper.addElement(mtmForm);
//
//						v = new VBox();
//						v.focusEnabled = false;
//						v.label = mtmFd._fieldNameFormatted;
//						v.percentWidth = 100;
//						v.addElement(dVGroupWrapper);
//
//						_tabNavigator.addElement(v);
//					}
//				}

				// Remarks:

				const remarksFD:FieldDescriptorBean = _entityBeanDescriptorsHandler._fieldDescriptorRemarks;
				if (remarksFD)
				{
					if (!isTabbed)
					{
						v.label = StrConsts.getRMString(57);
						_tabNavigator.addElement(v);
						isTabbed = true;
					}

					const ta:DRichTextEditor = new DRichTextEditor();
					ta._description = remarksFD._fieldNameFormatted;
					ta._defaultValue = remarksFD._defaultValue;
					ta._required = !remarksFD._isNullable;
					ta.label = remarksFD._fieldNameFormatted;
					ta.title = remarksFD._fieldNameFormatted + ":";
					ta.percentWidth = 100;
					ta.percentHeight = 100;

					_remarksRTE = ta;

					_tabNavigator.addElement(ta);

					_firstComponentsForFocus.push(remarksFD);
					_dCRUDToolBar.addInput(remarksFD._javaField, ta, _currentRunningFieldDescriptorRequiredForSearch);
				}

				// One to many:

				const oneToManyFDs:Vector.<FieldDescriptorBean> = _entityBeanDescriptorsHandler._oneToManyFieldDescriptors;
				if (oneToManyFDs)
				{
					const oneToManyFDsLenght:int = oneToManyFDs.length;
					var otmFd:FieldDescriptorBean;
					var crudF:DCRUDForm;
					var dLabel1:DLabel;
					var dLabel2:DLabel;
					var labelsHBox:HGroup;
					for (i = 0; i < oneToManyFDsLenght; i++)
					{
						if (!isTabbed)
						{
							v.label = StrConsts.getRMString(57);
							_tabNavigator.addElement(v);
							isTabbed = true;
						}

						otmFd = oneToManyFDs[i];

						crudF = new DCRUDForm();
						crudF._entityBeanDescriptorsHandler = DSession.getEntityDescriptor(otmFd._oneToManyTarget);
						crudF._associatedManyToManyProperty = otmFd._oneToManyMappedBy;
						crudF._associatedItemLabelIndicator = new DLabel();
						crudF._associatedItemLabelIndicator.setStyle(StrConsts._FLEX_STYLE_PROPERTY_COLOR, StrConsts._COLOR_RED_FIREBRICK);
						crudF._associatedItemLabelIndicator.setStyle(StrConsts._FLEX_STYLE_PROPERTY_FONTWEIGHT, FontStyle.BOLD);
						crudF.percentWidth = 100;
						crudF.percentHeight = 100;

						addElement(crudF);
						removeElement(crudF);

						_dCRUDToolBar.addDCRUDForm(crudF, otmFd._javaField);
						_firstComponentsForFocus.push(otmFd);

						dLabel1 = new DLabel(ServerVarsDecoder.replaceAllMessageDVars(crudF._entityBeanDescriptorsHandler._crudDescriptor._classNameFormatted));
						dLabel1.setStyle(StrConsts._FLEX_STYLE_PROPERTY_FONTWEIGHT, FontStyle.BOLD);
						dLabel2 = new DLabel(StrConsts.getRMString(154));
						dLabel2.setStyle(StrConsts._FLEX_STYLE_PROPERTY_FONTWEIGHT, FontStyle.BOLD);

						labelsHBox = new HGroup();
						labelsHBox.paddingBottom = 0;
						labelsHBox.paddingLeft = 0;
						labelsHBox.paddingRight = 0;
						labelsHBox.paddingTop = 0;
						labelsHBox.percentWidth = 100;
						labelsHBox.percentHeight = 100;
						labelsHBox.addElement(dLabel1);
						labelsHBox.addElement(dLabel2);
						labelsHBox.addElement(crudF._associatedItemLabelIndicator);

						dVGroupWrapper = new DVGroup();
						dVGroupWrapper.focusEnabled = false;
						dVGroupWrapper.gap = 0;
						dVGroupWrapper.paddingBottom = 7;
						dVGroupWrapper.paddingLeft = 7;
						dVGroupWrapper.paddingRight = 7;
						dVGroupWrapper.paddingTop = 7;
						dVGroupWrapper.percentWidth = 100;
						dVGroupWrapper.percentHeight = 100;
						dVGroupWrapper.addElement(labelsHBox);

						v = new VBox();
						v.focusEnabled = false;
						v.label = otmFd._fieldNameFormatted;
						v.percentWidth = 100;
						v.percentHeight = 100;
						v.addElement(dVGroupWrapper);

						_tabNavigator.addElement(v);

						if (!_dCRUDFormsTabs)
							_dCRUDFormsTabs = new Vector.<VBox>();

						_dCRUDFormsTabs.push(v);
					}
				}

				// DFileUploaders:

				const fileUploaders:Array = dBeanCRUDDescriptor._fileUploaders;
				if (fileUploaders)
				{
					const fileUploadersLength:int = fileUploaders.length;
					var dBeanFileUploader:DBeanFileUploader;
					var dFileUploader:DFileUploader;
					var fileUploaderBeanDescriptor:FieldDescriptorBean;

					for (i = 0; i < fileUploadersLength; i++)
					{
						dBeanFileUploader = fileUploaders[i];

						dFileUploader = new DFileUploader();
						dFileUploader._destination = dBeanFileUploader._destination;
						dFileUploader.id = dBeanFileUploader._id ? dBeanFileUploader._id : "dFileUploader" + i;
						dFileUploader.percentWidth = 100;
						dFileUploader.removeCornersRadius();
						dFileUploader.addEventListener(DUploadDownloadEvent._ON_UPLOAD_COMPLETE, onFileUploadComplete, false, 0, true);

						if (ServerVarsDecoder.hasNamedDVarWithin(dFileUploader._destination, "this"))
							_dCRUDToolBar._useFileUploaderDynamicDestinationResolver = true;

						// TODO: Analyze this.
						fileUploaderBeanDescriptor = new FieldDescriptorBean();
						fileUploaderBeanDescriptor._javaField = dFileUploader.id;
						_firstComponentsForFocus.push(fileUploaderBeanDescriptor);

						_dCRUDToolBar.addDFileUploader(dFileUploader);

						if (!isTabbed)
						{
							v.label = StrConsts.getRMString(57);
							_tabNavigator.addElement(v);
							isTabbed = true;
						}

						dVGroupWrapper = new DVGroup();
						dVGroupWrapper.focusEnabled = false;
						dVGroupWrapper.gap = 0;
						dVGroupWrapper.percentWidth = 100;
						dVGroupWrapper.addElement(dFileUploader);

						v = new VBox();
						v.focusEnabled = false;
						v.label = dBeanFileUploader._title;
						v.percentWidth = 100;
						v.addElement(dVGroupWrapper);

						_tabNavigator.addElement(v);
					}
				}

				// Wrapping.

				if (isTabbed)
				{
					_tabNavigator.focusEnabled = false;
					_tabNavigator.resizeToContent = true;
					_tabNavigator.percentWidth = 100;
					_tabNavigator.setStyle(StrConsts._FLEX_STYLE_PROPERTY_BACKGROUND_ALPHA, .4);
					_tabNavigator.setStyle(StrConsts._FLEX_STYLE_PROPERTY_PADDING_TOP, 3);
					_tabNavigator.addEventListener(IndexChangedEvent.CHANGE, setFocusImpl, false, 0, true);

					_formWrapper = _tabNavigator;
				}
				else
				{
					_tabNavigator = null;
					_formWrapper = v;
				}

				addElement(_formWrapper);

				// DAdvancedDataGrid.

				_dADGFull._entityBeanDescriptorsHandler = _entityBeanDescriptorsHandler;
				_dADGFull._dCRUDToolBar = _dCRUDToolBar;
				_dADGFull._useToolBar = _useDADGToolBar;
				_dADGFull._dADG.allowMultipleSelection = true;
				_dADGFull.columns = _dAdgColumns.toArray();
				_dADGFull.percentWidth = 100;
				_dADGFull.percentHeight = 100;
				_dADGFull.add4ExcludeOnTableMode(_dCRUDToolBar);
				_dADGFull.add4ExcludeOnTableMode(_formWrapper);
				addElement(_dADGFull);

				// TODO: FINISH THIS!!!

				if (fileUploaders && fileUploaders.length > 0)
				{
					_dImageViewerPanoramio = new DImageViewerPanoramio();
					_dImageViewerPanoramio.percentWidth = 100;
					_dImageViewerPanoramio.percentHeight = 100;
					addElement(_dImageViewerPanoramio);
					removeElement(_dImageViewerPanoramio);
				}

				if (_mdiWindowParent && _useDADGToolBar)
				{
					_mdiWindowParent.addEventListener(MDIWindowEvent.MINIMIZE, minimizeAction, false, 0, true);
					_mdiWindowParent.addEventListener(MDIWindowEvent.RESTORE, restoreAction, false, 0, true);
				}

				focusEnabled = false;
				gap = 0;
				addEventListener(KeyboardEvent.KEY_DOWN, myKeyDownHandler, false, 0, true);

				_currentRunningFieldDescriptor = null;
				_currentRunningFieldDescriptorFieldNameFormatted = null;
				_currentRunningFieldDescriptorJavaField = null;
				_currentRunningFieldDescriptorJavaType = null;
				_currentRunningFieldDescriptorNotInsertable = false;
				_currentRunningFieldDescriptorRequired = false;
				_currentSkeletonGrid = null;
				_currentSkeletonGridRow = null;
			} // Fim de: "if (_entityBeanDescriptorsHandler)".
			else
				throw new Error(" ### DCRUDForm.createFormBean: _entityBeanDescriptorsHandler é nulo.");
		}

		override public function setFocus():void
		{
			setFocusImpl();
		}

		//----------------------------------------------------------------------
		// DIGUIInput implementation:

		public function dispose():void
		{
			if (DSession._dCRUDFormCache && DSession._dCRUDFormCache.hasOwnProperty(_entityBeanDescriptorsHandler._crudDescriptor._className))
			{
				_dCRUDToolBar.changeToInsertMode();
				_tabNavigator.selectedIndex = 0;
				return;
			}

			_dADGFull.dispose();

			removeEventListener(KeyboardEvent.KEY_DOWN, myKeyDownHandler);

			_dCRUDToolBar.listen_CRUDShortcuts_REMOVE(this);
			_dCRUDToolBar.listen_MessageHelper_MaybeInTheIncorrectMode_REMOVE(this);
			_dCRUDToolBar.dispose();

			removeMDIWindowParentListeners();
			removeCRUDToolBarListeners();
			removeTabNavigatorListeners();
			removeFileUploadersListeners();

			_mdiWindowParent = null;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Public interface:

		public function associateValue(value:Object, codeDescriptor:FieldDescriptorBean, descriptionDescriptor:FieldDescriptorBean):void
		{
			_dCRUDToolBar._associatedValue = value;
			enabled = value ? true : false;

			if (value)
				_associatedItemLabelIndicator.text =
					value[codeDescriptor._javaField] +
					" - " +
					value[descriptionDescriptor._javaField];
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Private interface:

		//----------------------------------------------------------------------
		// Creation methods:

		// Form grid creation:

		private function createNewGridRowInstanceAndAddLastOneToGrid():void
		{
			if (_currentSkeletonGridRow.numElements > 0)
				_currentSkeletonGrid.addElement(_currentSkeletonGridRow);

			_currentSkeletonGridRow = new GridRow();
			_currentSkeletonGridRow.focusEnabled = false;
			_currentSkeletonGridRow.percentWidth = 100;
		}

		private function createGridRowLayout():void
		{
			createLabelGridItem();
			createInputGridItem();
			createPostLabelGridItem();
			createUniqueImage();
		}

		private function createLabelGridItem():void
		{
			const dLabel:DLabel = new DLabel(_currentRunningFieldDescriptorFieldNameFormatted, true)
			if (_currentRunningFieldDescriptorNotInsertable)
				dLabel.setStyle(StrConsts._FLEX_STYLE_PROPERTY_COLOR, StrConsts._COLOR_GRAY48);
			if (_currentRunningFieldDescriptorRequired)
				dLabel.setStyle(StrConsts._FLEX_STYLE_PROPERTY_FONTWEIGHT, StrConsts._FLEX_STYLE_VALUE_BOLD);

			const labelGridItem:DGridItem4Label = new DGridItem4Label();
			labelGridItem.addElement(dLabel);

			_currentSkeletonGridRow.addElement(labelGridItem);
		}

		private function createInputGridItem():void
		{
			if (_currentRunningFieldDescriptor._acceptableValues)
				createAcceptableValuesList();
			else if (_currentRunningFieldDescriptor._isDateField)
				createDDateField();
			else if (_currentRunningFieldDescriptor._isGender)
				createGenderDropDownList();
			// TODO: Implementar. Por enquanto desativado.
			//else if (descriptor.javaType == DFxGUIConstants._JAVA_TYPE_DATE)
				//createDTextInputDateGridItem();
			// TODO: Verificar como vai ficar a situação deste no "framework".
			//else if (_currentRunningFieldDescriptor._isHourField)
				//createDHourFieldGridItem();
			else if (_currentRunningFieldDescriptor._imageField)
				createImageField();
			else if (_currentRunningFieldDescriptorJavaType == StrConsts._JAVA_TYPE_String)
				createDTextInputGridItem();
			else if (_currentRunningFieldDescriptorJavaType == StrConsts._JAVA_TYPE_Boolean)
			{
				//if (_currentRunningFieldDescriptor._isNullable)
					createBooleanDDropDownList();
				//else
					//createDCheckBox();
			}
			else if (_currentRunningFieldDescriptor._isManyToOne)
				createDSOLGridItem();
			else
				createDTextInputGridItem();
		}

		private function createPostLabelGridItem():void
		{
			if (_currentRunningFieldDescriptor._postLabel)
			{
				const lastEl:GridItem = _currentSkeletonGridRow.getElementAt(_currentSkeletonGridRow.numElements - 1) as GridItem;
				_currentSkeletonGridRow.removeElement(lastEl);
				lastEl.setStyle(StrConsts._FLEX_STYLE_PROPERTY_VERTICAL_ALIGN, VerticalAlign.BOTTOM);
				lastEl.addElement(new DLabel(ServerVarsDecoder.replaceAllMessageDVars(_currentRunningFieldDescriptor._postLabel)));
				_currentSkeletonGridRow.addElement(lastEl);
			}
		}

		private function createUniqueImage():void
		{
			if (_currentRunningFieldDescriptor._isUnique)
			{
				const uniqueImg:DImage = new DImage();
				uniqueImg.source = DIconLibrary.BULLET_STAR;
				uniqueImg.toolTip = StrConsts.getRMString(144);

				const lastEl:GridItem = _currentSkeletonGridRow.getElementAt(_currentSkeletonGridRow.numElements - 1) as GridItem;
				_currentSkeletonGridRow.removeElement(lastEl);
				lastEl.addElement(uniqueImg);
				_currentSkeletonGridRow.addElement(lastEl);
			}
		}

		private function createAcceptableValuesList():void
		{
			const dDropDownList:DDropDownList = new DDropDownList();
			dDropDownList._required = _currentRunningFieldDescriptorRequired;

			const dp:ArrayList = DUtilStringTransformer.transformation1IntoArrayList(_currentRunningFieldDescriptor._acceptableValues);

			if (dp)
			{
				const dpFirstValue:Object = dp.getItemAt(0);

				if (dpFirstValue)
				{
					if (!(dpFirstValue is String))
						if (dpFirstValue is Object)
							_currentRunningFieldDescriptorIsPopulatedWithObjs = true;

					dDropDownList.dataProvider = dp;
				}
			}

			dDropDownList.percentWidth = 100;

			_dCRUDToolBar.addInput(_currentRunningFieldDescriptorJavaField, dDropDownList, _currentRunningFieldDescriptorRequiredForSearch);

			_currentSkeletonGridRow.addElement(createGridItemInstance(dDropDownList));
		}

		private function createDCheckBox():void
		{
			const dCheckBox:DCheckBox = new DCheckBox();
			dCheckBox._description = _currentRunningFieldDescriptorFieldNameFormatted;

			_dCRUDToolBar.addInput(_currentRunningFieldDescriptorJavaField, dCheckBox, _currentRunningFieldDescriptorRequiredForSearch);

			_currentSkeletonGridRow.addElement(createGridItemInstance(dCheckBox));
		}

		// TODO: Implementar para quando for do tipo Date.
		private function createDDateField():void
		{
			const dDateField:DDateField = new DDateField();
//			dDateField._required = _currentRunningFieldDescriptorRequired;
			dDateField._description = _currentRunningFieldDescriptorFieldNameFormatted;
			dDateField._defaultValue = _currentRunningFieldDescriptor._defaultValue;
			dDateField._blazeDS = _blazeDS; // TODO: ADICIONAR NO "addInput" IGUAL FIZ COM O DIMAGECHOOSER.
			dDateField.percentWidth = 100;

			const myLen:int = _currentRunningFieldDescriptor._length;

			if (myLen == 12)
				dDateField._workingMode = DDateField._WORKING_MODE_NUMERIC_FORMAT_YYYYMMDDHHMM;
			else if (myLen == 8)
				dDateField._workingMode = DDateField._WORKING_MODE_NUMERIC_FORMAT_YYYYMMDD;

			_dCRUDToolBar.addInput(_currentRunningFieldDescriptorJavaField, dDateField, _currentRunningFieldDescriptorRequiredForSearch);

			_currentSkeletonGridRow.addElement(createGridItemInstance(dDateField));

			dDateField._defaultValue = _currentRunningFieldDescriptor._defaultValue;

			if (_currentRunningFieldDescriptorNotInsertable)
				dDateField.getTextInput().setStyle(StrConsts._FLEX_STYLE_PROPERTY_COLOR, StrConsts._COLOR_GRAY48);
		}

		private function createGenderDropDownList():void
		{
			const inputGender:DDropDownListGender = new DDropDownListGender();
//			inputGender._description = _currentRunningFieldDescriptorFieldNameFormatted;
			inputGender._required = _currentRunningFieldDescriptorRequired;
			inputGender.percentWidth = 100;

			_dCRUDToolBar.addInput(_currentRunningFieldDescriptorJavaField, inputGender, _currentRunningFieldDescriptorRequiredForSearch);

			_currentSkeletonGridRow.addElement(createGridItemInstance(inputGender));
		}

		/*private function createDHourFieldGridItem():void
		{
			const dHourField:DTextInputHour = new DTextInputHour();
			dHourField._description = _currentRunningFieldDescriptorFieldNameFormatted;
			dHourField._required = _currentRunningFieldDescriptorRequired;
			dHourField._percentWidth = 100;
			dHourField.enabled = _currentRunningFieldDescriptorReadOnly;

			// TODO: DTextInputHour using "now" method???
			//if (_currentRunningFieldDescriptor._defaultValue)
				//if (_currentRunningFieldDescriptor._defaultValue == DFxGUIConstants._STR_now)
					//dHourField.now();

			_dValidatorManager.addComponentToValidation(dHourField);
			_dCRUDToolBar._objectBeanDictionary[_currentRunningFieldDescriptorJavaField] = dHourField;

			_currentSkeletonGridRow.addElement(createGridItemInstance(dHourField));
		}*/

		private function createDTextInputGridItem():void
		{
			var input:DInput;

			if (_currentRunningFieldDescriptor._isCPF)
			{
				const dTextInputCpf:DTextInputCpf = new DTextInputCpf();
				dTextInputCpf._cpfMaskEnabled = Boolean(_currentRunningFieldDescriptor._mask);
				dTextInputCpf._required = _currentRunningFieldDescriptorRequired;
				dTextInputCpf._selfValidate = _currentRunningFieldDescriptor._validateCPFNumber;
				dTextInputCpf._percentWidth = 100;
				input = dTextInputCpf;
			}
			else if (_currentRunningFieldDescriptor._isCNPJ)
			{
				const dTextInputCNPJ:DTextInputCnpj = new DTextInputCnpj();
				dTextInputCNPJ._cnpjMaskEnabled = Boolean(_currentRunningFieldDescriptor._mask);
				dTextInputCNPJ._required = _currentRunningFieldDescriptorRequired;
				dTextInputCNPJ._selfValidate = _currentRunningFieldDescriptor._validateCNPJNumber;
				dTextInputCNPJ._percentWidth = 100;
				input = dTextInputCNPJ;
			}
			else if (_currentRunningFieldDescriptor._isPhoneNumber)
			{
				const dTextInputPhoneNumber:DTextInputPhoneNumber = new DTextInputPhoneNumber();
//				dTextInputPhoneNumber._usePhoneNumberMask = Boolean(_currentRunningFieldDescriptor._mask);
//				dTextInputPhoneNumber._required = _currentRunningFieldDescriptorRequired;
//				dTextInputPhoneNumber._validatePhoneNumberNumber = _currentRunningFieldDescriptor._validatePhoneNumber;
				dTextInputPhoneNumber._percentWidth = 100;
				input = dTextInputPhoneNumber;
			}
			else if (_currentRunningFieldDescriptor._isCEP)
			{
				const dTextInputCEP:DTextInputCep = new DTextInputCep();
				dTextInputCEP._useCEPMask = Boolean(_currentRunningFieldDescriptor._mask);
//				dTextInputCEP._required = _currentRunningFieldDescriptorRequired;
				dTextInputCEP._validateCEPNumber = _currentRunningFieldDescriptor._validatePhoneNumber;
				dTextInputCEP._percentWidth = 100;
				input = dTextInputCEP;
			}
			else if (_currentRunningFieldDescriptor._isMainID)
			{
				const dTextInputID:DTextInputID = new DTextInputID();
				dTextInputID.percentWidth = 100;
				input = dTextInputID;
			}
			else if (_currentRunningFieldDescriptor._isPasswordField)
			{
				const dTextInputPassword:DTextInputPassword = new DTextInputPassword();
				dTextInputPassword._encryptPasswordSha256 = _currentRunningFieldDescriptor._isPasswordEncrypted;
//				dTextInputPassword._required = _currentRunningFieldDescriptorRequired;
				dTextInputPassword.maxChars = _currentRunningFieldDescriptor._length;
				dTextInputPassword.percentWidth = 100;
				input = dTextInputPassword;
			}
			else
			{
				const dTextInput:DTextInput = new DTextInput();
//				dTextInput._required = _currentRunningFieldDescriptorRequired;
				dTextInput.maxChars = _currentRunningFieldDescriptor._length;
				dTextInput.percentWidth = 100;

				input = dTextInput;
			}

			if (_currentRunningFieldDescriptorNotInsertable)
				(input as UIComponent).setStyle(StrConsts._FLEX_STYLE_PROPERTY_COLOR, StrConsts._COLOR_GRAY48);

			_dCRUDToolBar.addInput(_currentRunningFieldDescriptorJavaField, input, _currentRunningFieldDescriptorRequiredForSearch);

			_currentSkeletonGridRow.addElement(createGridItemInstance(input as IVisualElement));
		}

		private function createBooleanDDropDownList():void
		{
			const ddropDownListBoolean:DDropDownListBoolean = new DDropDownListBoolean();
			ddropDownListBoolean._required = _currentRunningFieldDescriptorRequired;
			ddropDownListBoolean.percentWidth = 100;

			_dCRUDToolBar.addInput(_currentRunningFieldDescriptorJavaField, ddropDownListBoolean, _currentRunningFieldDescriptorRequiredForSearch);

			_currentSkeletonGridRow.addElement(createGridItemInstance(ddropDownListBoolean));
		}

		private function createDSOLGridItem():void
		{
			const dSelectOneListing:DSelectOneListing = new DSelectOneListing();
			dSelectOneListing._entityDescriptor = DSession.getEntityDescriptor(_currentRunningFieldDescriptorJavaType);
//			dSelectOneListing._descriptionField = _currentRunningFieldDescriptor._solDescriptonField;
//			dSelectOneListing._codeFieldJavaType = _entityBeanDescriptorsHandler._fieldDescriptorID._javaType;
//			dSelectOneListing._descriptionFieldJavaType = _currentRunningFieldDescriptor._javaType;
			dSelectOneListing._autoCompleteMode = _currentRunningFieldDescriptor._solAutoCompleteMode;
			dSelectOneListing._solDataGridColumnsCSV = _currentRunningFieldDescriptor._solDataGridColumnsCSV;
			dSelectOneListing._solDataGridColumnsToRemoveCSV = _currentRunningFieldDescriptor._solDataGridColumnsToRemoveCSV;
			dSelectOneListing._solDataGridColumnsManyToOneCSV = _currentRunningFieldDescriptor._solDataGridColumnsManyToOneCSV;
			dSelectOneListing._solLikeDefaults = _currentRunningFieldDescriptor._solLikeDefaults;
			dSelectOneListing._required = _currentRunningFieldDescriptorRequired;
//			dSelectOneListing._bugCorrector = true;
//			dSelectOneListing._dAutoCompleteBugFlag = _dAutoCompleteBugFlag;
			dSelectOneListing.percentWidth = 100;

			_dCRUDToolBar.addInput(_currentRunningFieldDescriptorJavaField, dSelectOneListing, _currentRunningFieldDescriptorRequiredForSearch);

			_currentSkeletonGridRow.addElement(createGridItemInstance(dSelectOneListing));
		}

		private function createImageField():void
		{
			const dImageChooser:DImageChooser = new DImageChooser();
			dImageChooser._description = _currentRunningFieldDescriptorFieldNameFormatted;
			dImageChooser._destination = _entityBeanDescriptorsHandler._crudDescriptor._fileUploadersMap[_currentRunningFieldDescriptor._imageField]._destination;
			DUtilComponent.widthHeightTo100Percent(dImageChooser);

			_dCRUDToolBar.addInput(_currentRunningFieldDescriptorJavaField, dImageChooser, _currentRunningFieldDescriptorRequiredForSearch);

			_currentSkeletonGridRow.addElement(createGridItemInstance(dImageChooser));
		}

		// DataGrid columns creation.

		private function createDataGridColumn():void
		{
			if (_associatedManyToManyProperty == _currentRunningFieldDescriptor._javaField)
				return;

			const advancedDataGridColumn:DADGColumn = createNewPreConfiguredADGC(_currentRunningFieldDescriptor);

			if (advancedDataGridColumn)
			{
				if (_entityBeanDescriptorsHandler._fieldDescriptorHierarchicalCode)
				{
					if (_currentRunningFieldDescriptor._isDescriptionField)
					{
						_dADGFull._dADG.treeColumn = advancedDataGridColumn;
						_dAdgColumns.addItemAt(advancedDataGridColumn, 0);
						return;
					}
				}

				_dAdgColumns.addItem(advancedDataGridColumn);
			}
		}

		//----------------------------------------------------------------------
		// DCRUDToolBar:

		private function onCRUDToolBarChangesToInsertMode(event:DCRUDToolBarEvent):void
		{
//			toggleManyToManyTabsEnabled(false);
			toggleImageUploadTabsEnabled(false);
			toggleAssocDCRUDFormsTabsEnabled(false);

			if (_remarksRTE)
				_remarksRTE.enabled = false;

			if (_dImageViewerPanoramio)
				_dImageViewerPanoramio.clear();

			setFocusImpl(event);
		}

		private function onCRUDToolBarChangesToSearchMode(event:DCRUDToolBarEvent):void
		{
//			toggleManyToManyTabsEnabled(false);
			toggleImageUploadTabsEnabled(false);
			toggleAssocDCRUDFormsTabsEnabled(false);

			if (_remarksRTE)
				_remarksRTE.enabled = false;

			if (_dImageViewerPanoramio)
				_dImageViewerPanoramio.clear();
		}

		private function onCRUDToolBarChangesToUpdateMode(event:DCRUDToolBarEvent):void
		{
//			toggleManyToManyTabsEnabled(true);
			toggleAssocDCRUDFormsTabsEnabled(true);

//			if (_dImageViewerPanoramio) // TODO: Remove this condition?
				toggleImageUploadTabsEnabled(true);

			if (_remarksRTE)
				_remarksRTE.enabled = true;
		}

		private function onCRUDToolBarChangeSelectedItem(event:DCRUDToolBarEvent):void
		{
			if (_visibleDManyToManyForm)
				_visibleDManyToManyForm.loadData();
		}

		//----------------------------------------------------------------------
		// Associacion DCRUDForms:

		private function toggleAssocDCRUDFormsTabsEnabled(enabled:Boolean):void
		{
			if (_dCRUDFormsTabs)
			{
				const dCRUDFormsLength:int = _dCRUDFormsTabs.length;
				for (var i:int = 0; i < dCRUDFormsLength; i++)
					_dCRUDFormsTabs[i].enabled = enabled;
			}
		}

		//----------------------------------------------------------------------
		// DManyToManyForms:

//		private function toggleManyToManyTabsEnabled(enabled:Boolean):void
//		{
//			const dManyToManyForms:Array = _dCRUDToolBar._dManyToManyForms;
//			if (dManyToManyForms)
//			{
//				const dManyToManyFormsLength:int = dManyToManyForms.length;
//				for (var i:int = 0; i < dManyToManyFormsLength; i++)
//					(dManyToManyForms[i].parent.parent as Box).enabled = enabled;
//			}
//		}

		//----------------------------------------------------------------------
		// DFileUploaders:

		private function onFileUploadComplete(event:Event):void
		{
			_dImageViewerPanoramio.loadDFileUploaderFiles(event.currentTarget as DFileUploader);
		}

		private function toggleImageUploadTabsEnabled(enabled:Boolean):void
		{
			const dFileUploaders:Array = _dCRUDToolBar._dFileUploadersDictionary;
			if (dFileUploaders)
			{
				const dFileUploadersLength:int = dFileUploaders.length;
				var dFileUploader:DFileUploader;
				for (var i:int = 0; i < dFileUploadersLength; i++)
				{
					dFileUploader = dFileUploaders[i];
					dFileUploader._relatedObject = _dCRUDToolBar._selectedItem;
					(dFileUploader.parent.parent as Box).enabled = enabled;
				}

				if (_dImageViewerPanoramio)
					_dImageViewerPanoramio.enabled = enabled;
			}
		}

		//----------------------------------------------------------------------
		// MDIWindow:

		private function minimizeAction(event:MDIWindowEvent):void
		{
			_dADGFull._dADGToolBar.actionHideGroupByPopUp();
		}

		private function restoreAction(event:MDIWindowEvent):void
		{
			callLater(_dADGFull._dADGToolBar.actionRestoreGroupByPopUp);
		}

		//----------------------------------------------------------------------
		// Private generic interface:

		// TODO: Remove calllaters?
		private function setFocusImpl(event:Event=null):void
		{
			_visibleDManyToManyForm = null

			var compForFocus:UIComponent = null;
			var firstComp4FocusJavaField:String = "";

			if (_tabNavigator)
			{
				if (event is IndexChangedEvent)
				{
					firstComp4FocusJavaField = _firstComponentsForFocus[(event as IndexChangedEvent).newIndex]._javaField;
					compForFocus = _dCRUDToolBar.getInput(firstComp4FocusJavaField) as UIComponent;
					if (!compForFocus)
						compForFocus = _dCRUDToolBar.getDFileUploader(firstComp4FocusJavaField);
					if (!compForFocus)
						compForFocus = _dCRUDToolBar.getDManyToManyForm(firstComp4FocusJavaField);
					if (!compForFocus)
						compForFocus = _dCRUDToolBar.getDCRUDForm(firstComp4FocusJavaField);

//					if (compForFocus is DManyToManyForm)
//					{
//						const mtmForm:DManyToManyForm = compForFocus as DManyToManyForm;
//
//						if ((!mtmForm._dataGrid.dataProvider) || mtmForm._dataGrid.dataProvider.length == 0)
//							mtmForm.loadData();
//
//						mtmForm.setFocus();
//
//						_visibleDManyToManyForm = mtmForm;
//					}

					if (compForFocus is DCRUDForm)
					{
						if (_dCRUDToolBar.stage)
							_dCRUDToolBar.enabled = false;
						if (_dADGFull.stage)
							removeElement(_dADGFull);
						if (_dImageViewerPanoramio && _dImageViewerPanoramio.stage)
							removeElement(_dImageViewerPanoramio);
						if (_lastViewedAssocDCRUDForm)
							removeElement(_lastViewedAssocDCRUDForm);

						addElement(compForFocus);

						const dcf:DCRUDForm = compForFocus as DCRUDForm;
						dcf._dCRUDToolBar.actionSearch();

						_lastViewedAssocDCRUDForm = dcf;
					}
					else if (compForFocus is DFileUploader)
					{
						_dImageViewerPanoramio.clear();

						const dFileUploader:DFileUploader = compForFocus as DFileUploader;

						if (!_dADGFull.selectedItem)
							DNotificator.showInfo(StrConsts.getRMString(37), focusManager);

						if (_dCRUDToolBar.stage)
							_dCRUDToolBar.enabled = false;
						if (_dADGFull.stage)
							removeElement(_dADGFull);
						if (_lastViewedAssocDCRUDForm)
						{
							removeElement(_lastViewedAssocDCRUDForm);
							_lastViewedAssocDCRUDForm = null;
						}

						if (!_dImageViewerPanoramio.stage)
							addElement(_dImageViewerPanoramio);

						_dImageViewerPanoramio.loadDFileUploaderFiles(dFileUploader);

						setFocusOnCorrectFileUploadInput(dFileUploader);
					}
					else
					{
						if (_dCRUDToolBar.stage)
							_dCRUDToolBar.enabled = true;
						if (!_dADGFull.stage)
							addElement(_dADGFull);

						if (_dImageViewerPanoramio && _dImageViewerPanoramio.stage)
							removeElement(_dImageViewerPanoramio);
						if (_lastViewedAssocDCRUDForm)
						{
							removeElement(_lastViewedAssocDCRUDForm);
							_lastViewedAssocDCRUDForm = null;
						}

						if (compForFocus.enabled)
							callLater(compForFocus.setFocus);
					}
				}
				else
				{
					firstComp4FocusJavaField = _firstComponentsForFocus[_tabNavigator.selectedIndex]._javaField;
					compForFocus = _dCRUDToolBar.getInput(firstComp4FocusJavaField) as UIComponent;
					if (!compForFocus)
						compForFocus = _dCRUDToolBar.getDFileUploader(firstComp4FocusJavaField);
					if (!compForFocus)
						compForFocus = _dCRUDToolBar.getDManyToManyForm(firstComp4FocusJavaField);

					if (compForFocus is DFileUploader)
						setFocusOnCorrectFileUploadInput(compForFocus as DFileUploader);
					else if (compForFocus)
						callLater(compForFocus.setFocus);
				}
			}
			else
			{
				compForFocus = _dCRUDToolBar.getInput(_firstComponentsForFocus[0]._javaField) as UIComponent;

				if (compForFocus.enabled)
					callLater(compForFocus.setFocus);
				else
				{
					var disposable:Object = compForFocus; // TODO: Cast to DIGUIInput?
					while (!((disposable = _dCRUDToolBar._disposables[_dCRUDToolBar._disposables.indexOf(disposable) + 1]).enabled))
						continue;

					DUtilFocus.setFocusForcingIndicator(disposable as UIComponent); // TODO: Cast disposable to DIGUIInput?
				}
			}
		}

		public function createNewPreConfiguredADGC(dBeanFieldDescriptor:FieldDescriptorBean):DADGColumn
		{
			if ((!dBeanFieldDescriptor._isPasswordField) && (!dBeanFieldDescriptor._imageField))
				return new DADGColumn(_dADGFull._dADG, dBeanFieldDescriptor);
			else
				return null;
		}

		private function createGridRowLayoutANDCheckIfIsAFirstComponentForFocus():void
		{
			createGridRowLayout();
			checkIfIsAFirstComponentForFocus();
		}

		private function checkIfIsAFirstComponentForFocus():void
		{
			if (_currentFirstComponentStillNotFound && !_currentRunningFieldDescriptorNotInsertable)
			{
				_firstComponentsForFocus.push(_currentRunningFieldDescriptor);
				_currentFirstComponentStillNotFound = false;
			}
		}

		private function createGridItemInstance(elementToAdd:IVisualElement=null):GridItem
		{
			const gridItem:GridItem = new GridItem();
			gridItem.focusEnabled = false;
			gridItem.percentWidth = 100;

			if (elementToAdd)
				gridItem.addElement(elementToAdd);

			return gridItem;
		}

		private function myKeyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				const eventTarget:* = event.target;

				if (eventTarget is UITextField)
					if (eventTarget.owner is spark.components.TextArea || eventTarget.owner is mx.controls.TextArea)
						return;

				if (_listen_ENTER_do_TAB)
					DUtilFocus.setFocusOnNextComponent((event.currentTarget as UIComponent).focusManager);
			}
			else if (event.ctrlKey)
			{
				if ((event.keyCode == 68) || (event.charCode == 100))
					toogleFocusOnGridAndForm();
				else if (_tabNavigator)
					DUtilTabNavigator.Ctrl_PLUS_Tab_changeTabNavIndex(_tabNavigator, event);
			}
		}

		// TODO: This is not working.
		private function toogleFocusOnGridAndForm():void
		{
			if (_dADGFull._dADG.stage)
			{
				if (getFocus() == _dADGFull._dADG)
					callLater(setFocusImpl);
				else
					callLater(DUtilFocus.setFocusForcingIndicator, [ _dADGFull._dADG ]);
			}
			else if (_dImageViewerPanoramio && _dImageViewerPanoramio.stage)
			{
				if (_dImageViewerPanoramio.focusManager.getFocus() == _dImageViewerPanoramio.thumbnails)
					callLater(setFocusImpl);
				else
					callLater(DUtilFocus.setFocusForcingIndicator, [ _dImageViewerPanoramio ]);
			}
		}

		private function setFocusOnCorrectFileUploadInput(dFileUploader:DFileUploader):void
		{
			if (_dImageViewerPanoramio.enabled && _dImageViewerPanoramio._imagesURLs && _dImageViewerPanoramio._imagesURLs.length > 0)
				callLater(_dImageViewerPanoramio.setFocus);
			else
				callLater(dFileUploader.setFocus);
		}

		private function isCurrentRunningDescriptorJavaTypeANumber():Boolean
		{
			return (
				(_currentRunningFieldDescriptorJavaType == StrConsts._JAVA_TYPE_Short) ||
				(_currentRunningFieldDescriptorJavaType == StrConsts._JAVA_TYPE_Integer) ||
				(_currentRunningFieldDescriptorJavaType == StrConsts._JAVA_TYPE_Long)
			);
		}

		//----------------------------------------------------------------------
		// Listener removers:

		private function removeMDIWindowParentListeners():void
		{
			if (_mdiWindowParent)
			{
				_mdiWindowParent.removeEventListener(MDIWindowEvent.MINIMIZE, minimizeAction);
				_mdiWindowParent.removeEventListener(MDIWindowEvent.RESTORE, restoreAction);
			}
		}

		private function removeCRUDToolBarListeners():void
		{
			_dCRUDToolBar.removeEventListener(DCRUDToolBarEvent._ON_CHANGED_TO_INSERT_MODE, onCRUDToolBarChangesToInsertMode);
			_dCRUDToolBar.removeEventListener(DCRUDToolBarEvent._ON_CHANGED_TO_SEARCH_MODE, onCRUDToolBarChangesToSearchMode);
			_dCRUDToolBar.removeEventListener(DCRUDToolBarEvent._ON_CHANGED_TO_UPDATE_MODE, onCRUDToolBarChangesToUpdateMode);
			_dCRUDToolBar.removeEventListener(DCRUDToolBarEvent._ON_CHANGE_SELECTED_ITEM, onCRUDToolBarChangeSelectedItem);
		}

		private function removeTabNavigatorListeners():void
		{
			if (_tabNavigator)
				_tabNavigator.removeEventListener(IndexChangedEvent.CHANGE, setFocusImpl);
		}

		private function removeFileUploadersListeners():void
		{
			const dFileUploaders:Array = _dCRUDToolBar._dFileUploadersDictionary;
			if (dFileUploaders)
			{
				const dFileUploadersLength:int = dFileUploaders.length;
				for (var i:int = 0; i < dFileUploadersLength; i++)
					(dFileUploaders[i] as DFileUploader).removeEventListener(DUploadDownloadEvent._ON_UPLOAD_COMPLETE, onFileUploadComplete);
			}
		}

		//----------------------------------------------------------------------
	}
}
