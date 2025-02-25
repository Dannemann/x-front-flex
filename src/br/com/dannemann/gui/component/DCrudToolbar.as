package br.com.dannemann.gui.component
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.utils.ObjectProxy;
	
	import br.com.dannemann.gui.XFrontConfigurator;
	import br.com.dannemann.gui.bean.FieldDescriptorBean;
	import br.com.dannemann.gui.component.adg.DADG;
	import br.com.dannemann.gui.component.adg.plugin.DADGToolBar;
	import br.com.dannemann.gui.component.bean.RequiredFieldForSearchBean;
	import br.com.dannemann.gui.component.container.DHGroup;
	import br.com.dannemann.gui.component.container.mdi.containers.MDIWindow;
	import br.com.dannemann.gui.component.input.DDateField;
	import br.com.dannemann.gui.component.input.DImageChooser;
	import br.com.dannemann.gui.component.input.DInput;
	import br.com.dannemann.gui.component.input.DSelectOneListing;
	import br.com.dannemann.gui.component.input.DTextInput;
	import br.com.dannemann.gui.component.input.DTextInputID;
	import br.com.dannemann.gui.component.input.DTextInputPassword;
	import br.com.dannemann.gui.component.input.complex.DCRUDForm;
	import br.com.dannemann.gui.component.input.complex.DFileUploader;
	import br.com.dannemann.gui.component.validation.ValidatableComponent;
	import br.com.dannemann.gui.controller.BlazeDs;
	import br.com.dannemann.gui.controller.DSession;
	import br.com.dannemann.gui.controller.EntityDescriptor;
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.dto.persistence.Request;
	import br.com.dannemann.gui.event.DCRUDToolBarEvent;
	import br.com.dannemann.gui.event.DLoadEvent;
	import br.com.dannemann.gui.event.DUploadDownloadEvent;
	import br.com.dannemann.gui.util.DUtilComponent;
	import br.com.dannemann.gui.util.DUtilDataProvider;
	import br.com.dannemann.gui.util.DUtilString;
	import br.com.dannemann.gui.validator.DValidatorManager;
	
	[Event(name="onAfterChangedToModeInsert", type="br.com.dannemann.gui.event.DCRUDToolBarEvent")]
	[Event(name="onBeforeSearch", type="br.com.dannemann.gui.event.DCRUDToolBarEvent")]
	[Event(name="onAfterSearch", type="br.com.dannemann.gui.event.DCRUDToolBarEvent")]
	[Event(name="onBeforeSearchAll", type="br.com.dannemann.gui.event.DCRUDToolBarEvent")]
	[Event(name="onAfterSearchAll", type="br.com.dannemann.gui.event.DCRUDToolBarEvent")]
	[Event(name="onBeforeSave", type="br.com.dannemann.gui.event.DCRUDToolBarEvent")]
	[Event(name="onAfterSave", type="br.com.dannemann.gui.event.DCRUDToolBarEvent")]
	[Event(name="onBeforeDelete", type="br.com.dannemann.gui.event.DCRUDToolBarEvent")]
	[Event(name="onAfterDelete", type="br.com.dannemann.gui.event.DCRUDToolBarEvent")]
	[Event(name="onChangedToSearchMode", type="br.com.dannemann.gui.event.DCRUDToolBarEvent")]
	[Event(name="onChangedToInsertMode", type="br.com.dannemann.gui.event.DCRUDToolBarEvent")]
	[Event(name="onChangedToUpdateMode", type="br.com.dannemann.gui.event.DCRUDToolBarEvent")]
	[Event(name="onChangeSelectedItem", type="br.com.dannemann.gui.event.DCRUDToolBarEvent")]
	
	public class DCrudToolbar extends DHGroup implements DComponent
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Fields:
		
		/**
		 * <p>The property that will be retrieved from all inputs managed by this toolbar.</p>
		 * @default text
		 */
		public var _contentProperty:String = "text";
		
		public var requiredFieldsForSearch:Vector.<RequiredFieldForSearchBean>;
		
		public var _entityDescriptor:EntityDescriptor;
		
		// CRUD methods.
		public var _findByIdMethod:String = XFrontConfigurator._findByIdMethod;
		public var _findByExampleMethod:String = XFrontConfigurator._findByExampleMethod;
		public var _findAllMethod:String = XFrontConfigurator._findAllMethod;
		public var _saveMethod:String = XFrontConfigurator._saveMethod;
		public var _deleteMethod:String = XFrontConfigurator._deleteMethod;
		

		
		
		
		
		
		
		
		
		
		public var _columnsForHibernateSelectCSV:String = StrConsts._CHAR_ASTERISK;
		public var _advancedDataGridToolBar:DADGToolBar;
		public var _advancedDataGrid:DADG;
		public var _isThisInstanceAddedToStage:Boolean = true;
		public var _blazeDS:BlazeDs = new BlazeDs();
		public var _associatedManyToManyProperty:String;
		public var _associatedValue:Object;
		
		// Control buttons:
		public var _useSearchButton:Boolean = true;
		public var _useSearchAllButton:Boolean = true;
		public var _useNewButton:Boolean = true;
		public var _useSaveButton:Boolean = true;
		public var _useDeleteButton:Boolean = true;
		// References:
		public var _dLinkButtonSearch:DLinkButtonSearch;
		public var _dLinkButtonSearchAll:DLinkButtonSearch;
		public var _dLinkButtonNew:DLinkButtonNew;
		public var _dLinkButtonSave:DLinkButtonSave;
		public var _dLinkButtonDelete:DLinkButtonDelete;
		
		public var _useFileUploaderDynamicDestinationResolver:Boolean;
		
		// Sync listeners:
		public var _executeSearch:Function;
		public var _executeSearchAll:Function;
		public var _executeAfterSave:Object;
		public var _executeSave:Function;
		public var _executeDelete:Function;
		public var _executeAfterChangedToModeInsert:Function;
		public var _executeBeforeSearch:Function;
		public var _executeBeforeSearchAll:Function;
		public var _executeAfterSearchAll:Function;
		public var _executeBeforeSaveMustReturnTRUE:Function;
		public var _executeBeforeSave:Function;
		public var _executeBeforeDelete:Function;
		
		public static const _CRUD_MODE_INSERT:int = 1;
		public static const _CRUD_MODE_UPDATE:int = 2;
		public static const _CRUD_MODE_SEARCH:int = 3;
		
		private var crudMode:int;
		public function get _crudMode():int
		{
			return crudMode;
		}
		
		private var selectedItem:Object;
		public function get _selectedItem():Object
		{
			return selectedItem;
		}
		
		private const dValidatorManager:DValidatorManager = new DValidatorManager();
		public function get _dValidatorManager():DValidatorManager
		{
			return dValidatorManager;
		}
		
		// TODO: Should this to be private?
		public const _objectBeanDictionary:Dictionary = new Dictionary();
		// TODO: public const _disposables:Vector.<DIGUI> = new Vector.<DIGUI>;
		public var _disposables:Vector.<Object> = new Vector.<Object>;
		public var _dFileUploadersDictionary:Array; //TODO: Iterate over this for dispose.
		public var _dManyToManyForms:Array; //TODO: Iterate over this for dispose.
		public var _dCRUDForms:Array; //TODO: Iterate over this for dispose.
		public var _idInput:DTextInputID;
		
		private var _uploadCount:uint;
		
		// Message helper:
		private var _keyUpNumberOfTimesPressed:int;
		private var showModeWarning:Boolean = true;
		public function get _showModeWarning():Boolean
		{
			return showModeWarning;
		}
		public function set _showModeWarning(showModeWarning:Boolean):void
		{
			this.showModeWarning = showModeWarning;
			_keyUpNumberOfTimesPressed = 0;
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Overrides:
		
		// -------------------------------------------------------------------------
		// Class Overrides:
		
		override public function set initialized(value:Boolean):void
		{
			super.initialized = value;
			
			if (value)
			{
				if (_entityDescriptor._crudDescriptor._searchAllOnOpen)
					actionSearchAll();
				else
					changeToSearchMode();
			}
		}
		
		override protected function createChildren():void
		{
			if (_entityDescriptor)
			{
				super.createChildren();
				
				_blazeDS._mainCaller = this;
				
				if (_associatedManyToManyProperty)
				{
					if (_useSaveButton)
						createDLinkButtonSave();
					if (_useDeleteButton)
						createDLinkButtonDelete();
					if (_useSearchButton)
						createDLinkButtonSearch(StrConsts.getRMString(156));
					
					changeToInsertMode();
				}
				else
				{
					if (_useSearchButton)
						createDLinkButtonSearch();
					if (_useSearchAllButton)
						createDLinkButtonSearchAll();
					if (_useNewButton)
						createDLinkButtonNew();
					if (_useSaveButton)
						createDLinkButtonSave();
					if (_useDeleteButton)
						createDLinkButtonDelete();
					
					if (_advancedDataGrid)
						_advancedDataGrid.addEventListener(ListEvent.CHANGE, onSelectItem, false, 0, true);
				}
				
				if (!_columnsForHibernateSelectCSV)
					_columnsForHibernateSelectCSV = StrConsts._CHAR_ASTERISK;
			}
			else
				throw new Error(" ### DCRUDToolBar.createChildren: _entityBeanDescriptorsHandler é nulo.");
		}
		
		// -------------------------------------------------------------------------
		// DIGUIInput implementation:
		
		public function dispose():void
		{
			if (_dLinkButtonSearch)
				_dLinkButtonSearch.removeEventListener(MouseEvent.CLICK, actionSearch);
			if (_dLinkButtonSearchAll)
				_dLinkButtonSearchAll.removeEventListener(MouseEvent.CLICK, actionSearchAll);
			if (_dLinkButtonNew)
				_dLinkButtonNew.removeEventListener(MouseEvent.CLICK, actionNew);
			if (_dLinkButtonSave)
				_dLinkButtonSave.removeEventListener(MouseEvent.CLICK, actionSave);
			if (_dLinkButtonDelete)
				_dLinkButtonDelete.removeEventListener(MouseEvent.CLICK, actionDelete);
			
			removeImageChoosersListeners();
			
			if (_advancedDataGrid)
				_advancedDataGrid.removeEventListener(ListEvent.CHANGE, onSelectItem);
			
			const disposablesLength:int = _disposables.length;
			var disposable:Object;
			for (var i:int = 0; i < disposablesLength; i++)
			{
				disposable = _disposables[i];
				
				if (disposable.hasOwnProperty("dispose"))
					disposable.dispose();
				
				_disposables[i] = null;
			}
			
			_disposables = null;
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Public interface:
		
		// -------------------------------------------------------------------------
		// Main behavior:
		
		public function addInput(javaField:String, input:DInput, requiredInSearchs:Boolean=false):void
		{
			if (input is DImageChooser)
			{
				const imageChooser:DImageChooser = input as DImageChooser;
				imageChooser._blazeDS = _blazeDS;
				imageChooser.addEventListener(DLoadEvent._ON_EXCLUDED, onDImageChooserExcludingImage, false, 0, true);
			}
			else if (input is DTextInputID)
				_idInput = input as DTextInputID;
			
			if (input is ValidatableComponent)
				_dValidatorManager.addComponentToValidation(input as ValidatableComponent);
			
			_objectBeanDictionary[javaField] = input;
			_disposables.push(input);
		}
		
		public function getInput(javaField:String):DInput
		{
			return _objectBeanDictionary[javaField];
		}
		
		public function addDFileUploader(input:DFileUploader):void
		{
			if (!_dFileUploadersDictionary)
				_dFileUploadersDictionary = [];
			
			_dFileUploadersDictionary.push(input);
			_dFileUploadersDictionary[input.id] = input;
			
			_disposables.push(input);
		}
		
		public function getDFileUploader(id:String):DFileUploader
		{
			if (_dFileUploadersDictionary)
				return _dFileUploadersDictionary[id] as DFileUploader;
			else
				return null;
		}
		
		public function addDManyToManyForm(manyToManyForm:DManyToManyForm, keyStr:String):void
		{
			if (!_dManyToManyForms)
				_dManyToManyForms = [];
			
			_dManyToManyForms.push(manyToManyForm);
			_dManyToManyForms[keyStr] = manyToManyForm;
			
			_disposables.push(manyToManyForm);
		}
		
		public function getDManyToManyForm(id:String):DManyToManyForm
		{
			if (_dManyToManyForms)
				return _dManyToManyForms[id] as DManyToManyForm;
			else
				return null;
		}
		
		public function addDCRUDForm(dCRUDForm:DCRUDForm, keyStr:String):void
		{
			if (!_dCRUDForms)
				_dCRUDForms = [];
			
			_dCRUDForms.push(dCRUDForm);
			_dCRUDForms[keyStr] = dCRUDForm;
			
			_disposables.push(dCRUDForm);
		}
		
		public function getDCRUDForm(id:String):DCRUDForm
		{
			if (_dCRUDForms)
				return _dCRUDForms[id] as DCRUDForm;
			else
				return null;
		}
		
		// -------------------------------------------------------------------------
		// Listeners:
		
		public function listen_CRUDShortcuts(listenerContainer:UIComponent):void
		{
			listenerContainer.addEventListener(KeyboardEvent.KEY_UP, crudShortcutAction, false, 0, true);
		}
		
		public function listen_CRUDShortcuts_REMOVE(listenerContainer:UIComponent):void
		{
			listenerContainer.removeEventListener(KeyboardEvent.KEY_UP, crudShortcutAction);
		}
		
		public function listen_MessageHelper_MaybeInTheIncorrectMode(listenerContainer:UIComponent):void
		{
			listenerContainer.addEventListener(KeyboardEvent.KEY_UP, showMaybeInIncorrectModeMsg, false, 0, true);
		}
		
		public function listen_MessageHelper_MaybeInTheIncorrectMode_REMOVE(listenerContainer:UIComponent):void
		{
			listenerContainer.removeEventListener(KeyboardEvent.KEY_UP, showMaybeInIncorrectModeMsg);
		}
		
		// -------------------------------------------------------------------------
		// Actions:
		
		// Search.
		
		public function actionSearch(event:Event=null):void
		{
			if (canIExecuteSearch())
			{
				enabled = false;
				
				removeImageChoosersRelatedObjects();
				changeToSearchMode();
				
				
				
				
				
				
//				const requiredResult:String = validateRequiredFieldsForSearch();
//				const ignoredResult:String = validateBypassRequiredFieldsForSearch();
//				
//				if (requiredResult)
//				{
//					if (ignoredResult == "true")
//					{
//					}
//					else if (requiredResult == "false")
//					{
//						var errorStr:String = "";
//						
//						const requiredArr:Array  =_entityDescriptor.getRequiredInputsForSearchNotificationString();
//						if (requiredArr && requiredArr.length > 0)
//							errorStr +=  StrConsts.getRMString(146) + "<BR /><BR /><B>" + requiredArr.join("<BR />") + "</B>";
//						
//						if (errorStr)
//						{
//							const notifications:Array = _entityDescriptor.getIgnoreRequiredInputsForSearchNotificationString();
//							if (notifications)
//							{
//								if (notifications.length == 1)
//									errorStr += "<BR /><BR /><B>" + StrConsts.getRMString(111).toUpperCase() + "</B>, " + StrConsts.getRMString(147) + " <B>" + notifications[0] + "</B>";
//								else if (notifications.length > 1)
//									errorStr += "<BR /><BR /><B>" + StrConsts.getRMString(111).toUpperCase() + "</B>, " + StrConsts.getRMString(148) + ":<BR /><BR /><B>" + notifications.join("<BR />") + "</B>";
//							}
//						}
//						
//						DNotificator.showInfo(errorStr);
//						enabled = true;
//						return;
//					}
//				}
				
				// Validating the required fields for executing the search.
				if (!validateRequiredFieldsForSearch())
				{
					DNotificator.showInfo(generateReqFieldsForSearchNotificationStr());
					enabled = true;
					return;
				}
				
				if ((!_associatedManyToManyProperty) && isAllInputsEmpty())
				{
					//					if (lastMode == _CRUD_MODE_SEARCH)
					//					{
					const mdiWin:MDIWindow = DUtilComponent.findMyParentMDIWindow(this)
					DNotificator._notStacked = true;
					if (mdiWin)
						DNotificator.showWarning(StrConsts.getRMString(92), focusManager, DNotificator._NOTIFICATION_POSITION_TOP_RIGHT, mdiWin as Sprite, 2000);
					else
						DNotificator.showWarning(StrConsts.getRMString(92), focusManager);
					//					}
					
					enabled = true;
					return;
				}
				
				if (_advancedDataGrid)
					_advancedDataGrid.setNewTempDataProviderAndCleanFilters();
				
				const request:Request = new Request();
				request.tenant = DSession._tenant;
				request.object = createEntityObject();
				request.objectType = _entityDescriptor._crudDescriptor._className;
				request._columnsForHibernateSelectCSV = _columnsForHibernateSelectCSV;
				request._manyToOneEagerColumnsCSV = _entityDescriptor.getManyToOneJavaFieldsOnCSVStr();
				request._orderBy = StrConsts._STR_idDesc;
				
				if (_executeBeforeSearch != null)
					_executeBeforeSearch(request);
				
				dispatchEvent(new DCRUDToolBarEvent(DCRUDToolBarEvent._ON_BEFORE_SEARCH));
				
				if (_executeSearch != null)
					_executeSearch(request);
				else {
					_blazeDS.invoke3(
						XFrontConfigurator._crudServiceDestination,
						_findByExampleMethod,
						request,
						function (returnObj:Object):void
						{
							onSearchResultSuccess(returnObj.result);
							dispatchEvent(new DCRUDToolBarEvent(DCRUDToolBarEvent._ON_AFTER_SEARCH));
						}
					);
				}
			}
			else
				DNotificator.showInfo(StrConsts.getRMString(87), focusManager);
		}
		
		// Search all.
		
		public function actionSearchAll(event:Event=null):void
		{
			if (canIExecuteSearchAll())
			{
				enabled = false;
				
				cleanAllInputs();
				changeToSearchMode();
				
				if (_advancedDataGrid)
					_advancedDataGrid.setNewTempDataProviderAndCleanFilters();
				
				const dBeanCRUDParam:Request = new Request();
				dBeanCRUDParam.tenant = DSession._tenant;
				dBeanCRUDParam.objectType = _entityDescriptor._crudDescriptor._className;
				dBeanCRUDParam._columnsForHibernateSelectCSV = _columnsForHibernateSelectCSV;
				dBeanCRUDParam._manyToOneEagerColumnsCSV = _entityDescriptor.getManyToOneJavaFieldsOnCSVStr();
				dBeanCRUDParam._orderBy = StrConsts._STR_idDesc;
				
				if (_executeBeforeSearchAll != null)
					_executeBeforeSearchAll(dBeanCRUDParam);
				
				dispatchEvent(new DCRUDToolBarEvent(DCRUDToolBarEvent._ON_BEFORE_SEARCH_ALL));
				
				if (_executeSearchAll != null)
					_executeSearchAll(dBeanCRUDParam);
				else {
					_blazeDS.invoke3(
						XFrontConfigurator._crudServiceDestination,
						_findAllMethod,
						dBeanCRUDParam,
						function (returnObj:Object):void
						{
							onSearchResultSuccess(returnObj.result);
							dispatchEvent(new DCRUDToolBarEvent(DCRUDToolBarEvent._ON_AFTER_SEARCH_ALL));
							
							if (_executeAfterSearchAll != null)
								_executeAfterSearchAll(returnObj);
						});
				}
			}
			else
				DNotificator.showInfo(StrConsts.getRMString(87), focusManager);
		}
		
		// New.
		
		public function actionNew(event:Event=null):void
		{
			if (canIExecuteNew())
			{
				enabled = false;
				
				changeToInsertMode();
				
				if (_executeAfterChangedToModeInsert != null)
					_executeAfterChangedToModeInsert();
				
				dispatchEvent(new DCRUDToolBarEvent(DCRUDToolBarEvent._ON_AFTER_CHANGED_TO_MODE_INSERT));
				
				enabled = true;
			}
			else
				DNotificator.showInfo(StrConsts.getRMString(87), focusManager);
		}
		
		// Save.
		
		public function actionSave(event:Event=null):void
		{
			if (canIExecuteSave())
			{
				enabled = false;
				_advancedDataGrid.enabled = false;
				_advancedDataGridToolBar.enabled = false;
				
				var canIExecute:Boolean = false;
				
				if (_dValidatorManager.doValidation())
					canIExecute = true;
				
				if (_executeBeforeSaveMustReturnTRUE != null)
				{
					if (_executeBeforeSaveMustReturnTRUE(dBeanCRUDParam))
						canIExecute = true;
					else
						canIExecute = false;
				}
				
				if (canIExecute)
				{
					// TODO: dBeanCRUDParam can be an instance variable? There are generic properties on it?
					const dBeanCRUDParam:Request = new Request();
					dBeanCRUDParam._applicationName = XFrontConfigurator._applicationName;
					dBeanCRUDParam.tenant = DSession._tenant;
					dBeanCRUDParam.localeTag = DSession._localeTag;
					dBeanCRUDParam.objectType = _entityDescriptor._crudDescriptor._className;
					dBeanCRUDParam._executeAfterSave = _entityDescriptor._crudDescriptor._executeAfterSave;
					
					if (_executeAfterSave is String && _executeAfterSave)
						dBeanCRUDParam._executeAfterSave = dBeanCRUDParam._executeAfterSave ? dBeanCRUDParam._executeAfterSave + ", " + String(_executeAfterSave) : String(_executeAfterSave);
					
					if (_crudMode == _CRUD_MODE_INSERT && _useFileUploaderDynamicDestinationResolver)
					{
						dBeanCRUDParam._executeAfterSave += dBeanCRUDParam._executeAfterSave ? ", " + StrConsts._SERVICE_FileUploaderDynamicDestinationResolver : StrConsts._SERVICE_FileUploaderDynamicDestinationResolver;
						dBeanCRUDParam._fileUploaders = _entityDescriptor._crudDescriptor._fileUploaders;
					}
					
					// Entity object.
					dBeanCRUDParam.object = createEntityObject(_entityDescriptor._fieldDescriptorHierarchicalCode);
					registerSelectedItem(createEntityObject(null, false));
					
					if (_entityDescriptor._fieldDescriptorHierarchicalCode)
					{
						dBeanCRUDParam._hierarchicalCodeIdField = _entityDescriptor._fieldDescriptorHierarchicalCode._hierarchicalCodeIdField;
						dBeanCRUDParam._hierarchicalCodeLineageField = _entityDescriptor._fieldDescriptorHierarchicalCode._javaField;
						
						if (!dBeanCRUDParam.object[_entityDescriptor._fieldDescriptorHierarchicalCode._hierarchicalCodeParentField])
							dBeanCRUDParam._hierarchicalRootNode = true;
					}
					
					if (_executeBeforeSave != null)
						_executeBeforeSave(dBeanCRUDParam);
					
					dispatchEvent(new DCRUDToolBarEvent(DCRUDToolBarEvent._ON_BEFORE_SAVE));
					
					if (_executeSave != null)
						_executeSave(dBeanCRUDParam);
					else
						_blazeDS.invoke3(
							XFrontConfigurator._crudServiceDestination,
							_saveMethod,
							dBeanCRUDParam,
							function (returnObj:ObjectProxy):void
							{
								//								const returnedEntity:Object = returnObj.valueOf();
								const returnedEntity:Object = returnObj.result;
								const manyToOneFieldsDescriptors:Vector.<FieldDescriptorBean> = _entityDescriptor._manyToOneFieldDescriptors;
								
								var i:int;
								
								if (manyToOneFieldsDescriptors)
								{
									const manyToOneFieldsDescriptorsLength:int = manyToOneFieldsDescriptors.length;
									var fieldDescriptor:FieldDescriptorBean;
									var sol:DSelectOneListing;
									for (i = 0; i < manyToOneFieldsDescriptorsLength; i++)
									{
										fieldDescriptor = manyToOneFieldsDescriptors[i];
										sol = getInput(fieldDescriptor._javaField) as DSelectOneListing;
										
										if ((!sol) && _associatedManyToManyProperty)
											returnedEntity[fieldDescriptor._javaField] = _associatedValue;
										else
											returnedEntity[fieldDescriptor._javaField] = (getInput(fieldDescriptor._javaField) as DSelectOneListing)._selectedItem;
									}
								}
								
								registerSelectedItem(returnedEntity);
								
								_uploadCount = 0;
								
								const imageFields:Vector.<FieldDescriptorBean> = _entityDescriptor._imageFields;
								if (imageFields)
								{
									const imageFieldsLength:int = imageFields.length;
									var imageField:DImageChooser;
									for (i = 0; i < imageFieldsLength; i++)
									{
										imageField = _objectBeanDictionary[imageFields[i]._javaField];
										imageField._relatedObject = returnedEntity;
										imageField.removeEventListener(DUploadDownloadEvent._ON_UPLOAD_COMPLETE, afterSaveControlledExecution);
										imageField.addEventListener(DUploadDownloadEvent._ON_UPLOAD_COMPLETE, afterSaveControlledExecution, false, 0, true);
										
										if (imageField.startUpload())
											_uploadCount++
										else
										imageField.removeEventListener(DUploadDownloadEvent._ON_UPLOAD_COMPLETE, afterSaveControlledExecution);
									}
									
									if (_uploadCount == 0)
										afterSaveControlledExecution();
								}
								else
									afterSaveControlledExecution();
							},
							null,
							function (error:Object):void
							{
								if (error && error.rootException && error.rootException.SQLState == "23505")
									DNotificator.showError2(StrConsts.getRMString2("23505"));
								else
								{
									_uploadCount = 0;
									enabled = true;
									actionSearchAll(); // TODO: Temp solution. After an exception, the object do not update and it's version becomes old. This why I'm doing this.
									DNotificator.showError2(StrConsts.getRMString(152));
								}
								
								_advancedDataGrid.enabled = true;
								_advancedDataGridToolBar.enabled = true;
							}
						);
				}
				else
				{
					enabled = true;
					_advancedDataGrid.enabled = true;
					_advancedDataGridToolBar.enabled = true;
				}
			}
			else
				DNotificator.showInfo(StrConsts.getRMString(87), focusManager);
		}
		
		private function afterSaveControlledExecution(event:Event=null):void
		{
			if (event)
				(event.currentTarget as DImageChooser).removeEventListener(DUploadDownloadEvent._ON_UPLOAD_COMPLETE, afterSaveControlledExecution);
			
			if (_uploadCount > 0)
				_uploadCount--;
			
			if (_uploadCount == 0)
			{
				if (_advancedDataGridToolBar)
				{
					if (_advancedDataGridToolBar.currentState == _advancedDataGridToolBar.stateNormal.name)
					{
						const adgDpAc:ArrayCollection = _advancedDataGrid.dataProvider as ArrayCollection;
						
						if (_crudMode == _CRUD_MODE_UPDATE)
						{
							adgDpAc.setItemAt(_selectedItem, _advancedDataGrid.selectedIndex);
							DNotificator.showInfo(StrConsts.getRMString(46), focusManager);
						}
						else if (_crudMode == _CRUD_MODE_INSERT || _associatedManyToManyProperty)
						{
							(_advancedDataGrid.dataProvider as ArrayCollection).addItemAt(_selectedItem, 0);
							_advancedDataGrid.selectedIndex = 0;
							DNotificator.showInfo(StrConsts.getRMString(45), focusManager);
						}
						else
							throw new Error(" ### DCRUDToolBar.actionSave: Modo de persistência inesperado. Contate o suporte técnico!");
						
						if (_associatedManyToManyProperty)
							changeToInsertMode();
						else
							onSelectItem();
					}
					else if (_advancedDataGridToolBar.currentState == _advancedDataGridToolBar.stateTree.name)
					{
						actionSearchAll();
						changeToInsertMode(); // TODO: Ao invés disso, ir para o item selecionado como no modo não árvore.
					}
				}
				
				_advancedDataGrid.enabled = true;
				_advancedDataGridToolBar.enabled = true;
				
				dispatchEvent(new DCRUDToolBarEvent(DCRUDToolBarEvent._ON_AFTER_SAVE));
			}
		}
		
		// Delete.
		
		public function actionDelete(event:Event=null):void
		{
			if (canIExecuteDelete())
			{
				enabled = false;
				
				DConfirmActionAlert.show(
					StrConsts.getRMString(49),
					function (event:CloseEvent):void
					{
						if (event.detail == Alert.YES)
						{
							const dBeanCRUDParam:Request = new Request();
							dBeanCRUDParam.tenant = DSession._tenant;
							dBeanCRUDParam.objectType = _entityDescriptor._crudDescriptor._className;
							dBeanCRUDParam._sql = "";
							
							var i:int = 0;
							const selItems:Array = _advancedDataGrid.selectedItems;
							if (selItems && selItems.length > 0)
							{
								var sql:String = "";
								var sel:Object;
								const sil:int = selItems.length;
								for (i = 0; i < sil; i++)
									//									if (_associatedManyToManyProperty)
									//									{
									//
									//									}
									
									dBeanCRUDParam._sql += "delete from " +
									_entityDescriptor._crudDescriptor._tableName +
									" where " +
									_entityDescriptor._fieldDescriptorID._javaField +
									" = " +
									selItems[i][_entityDescriptor._fieldDescriptorID._javaField] +
									";";
							}
							
							if (i > 0)
							{
								if (_executeBeforeDelete != null)
									_executeBeforeDelete(dBeanCRUDParam);
								
								dispatchEvent(new DCRUDToolBarEvent(DCRUDToolBarEvent._ON_BEFORE_DELETE));
								
								cleanAllInputs();
								
								if (_executeDelete != null)
									_executeDelete(dBeanCRUDParam);
								else
									_blazeDS.invokeOld(
										XFrontConfigurator._crudServiceDestination + StrConsts._METHOD_DOTdelete,
										dBeanCRUDParam,
										function (returnObj:Object=null):void
										{
											const removeItems:Function = function ():void
											{
												const dp:ArrayCollection = _advancedDataGrid.dataProvider as ArrayCollection;
												const selItems:Array = _advancedDataGrid.selectedItems;
												const selItemsLength:int = selItems.length;
												for (var j:int = 0; j < selItemsLength; j++)
													dp.removeItemAt(dp.getItemIndex(selItems[j]));
											};
											
											if (_advancedDataGridToolBar)
											{
												const advancedDataGrid:AdvancedDataGrid = _advancedDataGrid;
												
												if (_advancedDataGridToolBar.currentState == _advancedDataGridToolBar.stateNormal.name)
													removeItems();
												else if (_advancedDataGridToolBar.currentState == _advancedDataGridToolBar.stateTree.name)
													actionSearchAll();
											}
											else
												removeItems();
											
											//											actionADGListChanged();
											//											changeToSearchMode();
											
											changeToInsertMode();
											
											DNotificator.showInfo(StrConsts.getRMString(43), focusManager);
											
											dispatchEvent(new DCRUDToolBarEvent(DCRUDToolBarEvent._ON_AFTER_DELETE));
										}
									);
							}
							else
								DNotificator.showHelp(StrConsts.getRMString(41), focusManager);
						}
						else
							enabled = true;
					}
				);
			}
			else
				DNotificator.showInfo(StrConsts.getRMString(87));
		}
		
		// -------------------------------------------------------------------------
		// Verifications:
		
		public function canIExecuteSearch():Boolean
		{
			return stage && enabled && _dLinkButtonSearch && _dLinkButtonSearch.enabled;
		}
		
		public function canIExecuteSearchAll():Boolean
		{
			return (!_isThisInstanceAddedToStage) || (stage && enabled && _dLinkButtonSearchAll && _dLinkButtonSearchAll.enabled);
		}
		
		public function canIExecuteNew():Boolean
		{
			return stage && enabled && _dLinkButtonNew && _dLinkButtonNew.enabled
		}
		
		public function canIExecuteSave():Boolean
		{
			return stage && enabled && _dLinkButtonSave && _dLinkButtonSave.enabled;
		}
		
		public function canIExecuteDelete():Boolean
		{
			return stage && enabled && _dLinkButtonDelete && _dLinkButtonDelete.enabled;
		}
		
		// -------------------------------------------------------------------------
		// Inputs and object management:
		
		public function isAllInputsEmpty():Boolean
		{
			// TODO: USE FOR EACH TO ACCESS THE PROPERTY DIRECTLY?
			for (var key:Object in _objectBeanDictionary)
				if (_objectBeanDictionary[key][_contentProperty])
					return false;
			
			return true;
		}
		
		public function cleanAllInputs():void
		{
			for (var key:Object in _objectBeanDictionary)
				(_objectBeanDictionary[key] as DInput).clean();
			
			removeImageChoosersRelatedObjects();
		}
		
		
		
		
		
		
		

		
		
		
		
		
		
		
		
		
		
		
		public function createEntityObject(lineageDescriptor:FieldDescriptorBean=null, stringValuesOnly:Boolean=true):Object
		{
			const saveObj:Object = new Object();
			
//			if (_associatedManyToManyProperty)
//			{
//				saveObj[_associatedManyToManyProperty] = _associatedValue["id"]; // TODO: HARD CODED!!!
//
//				if (_crudMode == _CRUD_MODE_SEARCH && !_associatedManyToManyProperty)
//					return saveObj;
//			}

			const fieldsDescriptors:Object = _entityDescriptor._fields;
			const searchFieldsDescriptors:Object = _entityDescriptor._searchFieldsFieldDescriptors;
			const isOnSearchMode:Boolean = _crudMode == _CRUD_MODE_SEARCH;
			const isOnInsertMode:Boolean = _crudMode == _CRUD_MODE_INSERT;
			const isOnUpdateMode:Boolean = _crudMode == _CRUD_MODE_UPDATE;
			
			var fd:FieldDescriptorBean;
			var input:Object = null;
			var value:Object = null;
			var df:DDateField = null;
			var sol:DSelectOneListing = null;
			var ignoreIfNotInsertable:Boolean = false;
			
//			if (isOnSearchMode && _associatedManyToManyProperty)
//				saveObj[_associatedManyToManyProperty] = _associatedValue["id"]; // TODO: HARD CODED!!!
//			else
			for (var key:String in _objectBeanDictionary)
			{
				fd = fieldsDescriptors[key];
				input = _objectBeanDictionary[key];
				value = input[_contentProperty];
				
				if (input is DDateField)
				{
					if (!isOnSearchMode)
					{
						df = input as DDateField;
						
						if (df._defaultValue == DDateField._NOW)
						{
							if (isOnInsertMode)
							{
								if (!fd._isInsertable)
								{
									value = DDateField._NOW;
									ignoreIfNotInsertable = true;
								}
								else if (!value)
									value = DDateField._NOW;
							}
							else if (isOnUpdateMode)
							{
								if (fd._isUpdatable)
								{
									if (!value)
										value = DDateField._NOW;
								}
							}
						}
					}
				}
				else if (input is DSelectOneListing)
				{
					sol = input as DSelectOneListing;
					
					if (!isOnSearchMode)
					{
						if ((_entityDescriptor._fieldDescriptorFKHolderFor) && (_entityDescriptor._fieldDescriptorFKHolderFor._fkHolderFor == key))
							if (value)
								saveObj[_entityDescriptor._fieldDescriptorFKHolderFor._javaField] = value;
						
						if (lineageDescriptor)
							if (lineageDescriptor._hierarchicalCodeParentField == key)
							{
								const lineageField:String = lineageDescriptor._javaField;
								const solSelectedItem:Object = sol._selectedItem;
								
								if (solSelectedItem)
								{
									const parentLineageValue:String = solSelectedItem[lineageField];
									if (parentLineageValue)
										saveObj[lineageField] = parentLineageValue;
									else
										saveObj[lineageField] = value;
								}
							}
					}
					
					if (!stringValuesOnly)
						value = sol._selectedItem;
					
					sol = null;
				}
				
				if (isOnSearchMode)
				{
					if (input is DTextInputPassword)
						continue;
				}
				
				if (isOnInsertMode || _associatedManyToManyProperty)
				{
					if (fd && (!fd._isInsertable) && (!ignoreIfNotInsertable))
						continue;
					
					if (!value)
						if ((input as Object).hasOwnProperty("_defaultValue") && (input as Object)._defaultValue) // TODO: _defaultValue must be in DIGUIInput interface.
							value = (input as Object)._defaultValue;
				}
				
				if (value)
					saveObj[key] = value;
				
				if (searchFieldsDescriptors && searchFieldsDescriptors[key])
				{
					saveObj[searchFieldsDescriptors[key]._javaField] = DUtilString.removeSpecialCharsAndUpperCase(value.toString());
					
					if (isOnSearchMode)
						saveObj[key] = null;
				}
			}
			
			if (_associatedManyToManyProperty)
				saveObj[_associatedManyToManyProperty] = _associatedValue["id"]; // TODO: HARD CODED!!!
			
			return saveObj;
		}
		
		public function updateObjectBeanDictionaryInputs(data:Object):void
		{
			cleanAllInputs();
			addImageChoosersRelatedObjects(data);
			addDFileUploadersRelatedObjects(data);
			
			var input:Object;
			var value:Object;
			
			for (var key:Object in _objectBeanDictionary)
				if ((data) && (data.hasOwnProperty(key)))
				{
					input = _objectBeanDictionary[key];
					value = data[key];
					
					if (value != null)
					{
						if (input is DSelectOneListing)
							(input as DSelectOneListing)._selectedItem = value;
						else
							input[_contentProperty] = value.toString();
					}
					else
						input[_contentProperty] = StrConsts._CHAR_EMPTY_STRING;
				}
			
			changeToUpdateMode(null, data);
		}
		
		// -------------------------------------------------------------------------
		// CRUD modes changing:
		
		public function changeToSearchMode(event:MouseEvent=null):void
		{
			toggleNotUpdatableInputs(true);
			
			if (_dLinkButtonDelete)
				_dLinkButtonDelete.enabled = false;
			
			if (_dLinkButtonSave)
			{
				if (_associatedManyToManyProperty)
					_dLinkButtonSave.enabled = true;
				else
					_dLinkButtonSave.enabled = false;
				
				_dLinkButtonSave.toogleSaveUpdateLabels(false, _associatedManyToManyProperty ? StrConsts.getRMString(155) : null);
			}
			
			const idField:DTextInput = _objectBeanDictionary[StrConsts._STR_id] as DTextInputID;
			if (idField)
				idField.enabled = true;
			
			registerSelectedItem(null);
			
//			adjustAllManyToManyFormsSelectedItemLocked1(null);
			adjustAllDCRUDFormsLockedItems(null);
			
			_showModeWarning = true;
			
//			if (!_associatedManyToManyProperty)
//			{
//				_dValidatorManager.toggleRequiredValidationsEnabled(false);
//				_dValidatorManager.doValidation(false, false);
//			}
//			_dValidatorManager.cleanErrorStrings();
			_dValidatorManager.toggleRequiredValidationsEnabled(false);
			
			
			// TODO TEMPORARIO
//			var o:Object;
//			for each (o in _objectBeanDictionary)
//			{
//				if (o.hasOwnProperty("errorString"))
//					o.errorString = "";
//			}
			
			crudMode = _CRUD_MODE_SEARCH;
			dispatchEvent(new DCRUDToolBarEvent(DCRUDToolBarEvent._ON_CHANGED_TO_SEARCH_MODE));
		}
		
		public function changeToInsertMode(event:MouseEvent=null, setSelectedIndexToMinus1:Boolean=true):void
		{
			cleanAllInputs();
			//call_NOW_onAllDateFields();
			toggleNotUpdatableInputs(true);
			
			if (_dLinkButtonDelete)
				_dLinkButtonDelete.enabled = false;
			
			_dLinkButtonSave.enabled = true;
			_dLinkButtonSave.toogleSaveUpdateLabels(false, _associatedManyToManyProperty ? StrConsts.getRMString(155) : null);
			
			const idField:DTextInput = _objectBeanDictionary[StrConsts._STR_id] as DTextInputID;
			if (idField)
				idField.enabled = true;
			
			if (setSelectedIndexToMinus1 && _advancedDataGrid)
				_advancedDataGrid.selectedIndex = -1;
			
			registerSelectedItem(null);
			
			//			adjustAllManyToManyFormsSelectedItemLocked1(null);
			adjustAllDCRUDFormsLockedItems(null);
			
			_dValidatorManager.toggleRequiredValidationsEnabled(true);
			_dValidatorManager.doValidation(false, false);
			
			crudMode = _CRUD_MODE_INSERT;
			dispatchEvent(new DCRUDToolBarEvent(DCRUDToolBarEvent._ON_CHANGED_TO_INSERT_MODE));
		}
		
		public function changeToUpdateMode(event:MouseEvent=null, selectedItem:Object=null):void
		{
			toggleNotUpdatableInputs(false);
			
			if (_dLinkButtonDelete)
				_dLinkButtonDelete.enabled = true;
			_dLinkButtonSave.enabled = true;
			_dLinkButtonSave.toogleSaveUpdateLabels(true);
			
			const idField:DTextInput = _objectBeanDictionary[StrConsts._STR_id] as DTextInputID;
			if (idField)
				idField.enabled = false;
			
			if (selectedItem)
				registerSelectedItem(selectedItem);
			
			//			adjustAllManyToManyFormsSelectedItemLocked1(_selectedItem);
			adjustAllDCRUDFormsLockedItems(_selectedItem);
			
			_dValidatorManager.toggleRequiredValidationsEnabled(true);
			_dValidatorManager.doValidation(false, false);
			
			crudMode = _CRUD_MODE_UPDATE;
			dispatchEvent(new DCRUDToolBarEvent(DCRUDToolBarEvent._ON_CHANGED_TO_UPDATE_MODE));
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Private interface:
		
		// -------------------------------------------------------------------------
		// Listeners:
		
		private function crudShortcutAction(event:KeyboardEvent):void
		{
			if (event.ctrlKey)
				switch (event.keyCode)
				{
					case 84:
					case 116:
						actionSearchAll(event);
						break;
					case 80:
					case 112:
						actionSearch(event);
						break;
					case 78:
					case 110:
						actionNew(event);
						break;
					case 83:
					case 115:
						actionSave(event);
						break;
					case 69:
					case 101:
						actionDelete(event);
						break;
				}
		}
		
		// DImageChoosers:
		
		private function onDImageChooserExcludingImage(event:DLoadEvent):void
		{
			actionSave();
		}
		
		// DADG:
		
		private function onSelectItem(event:ListEvent=null):void
		{
			if (_uploadCount > 0)
			{
				event.preventDefault();
				event.stopImmediatePropagation();
				return;
			}
			
			if (_advancedDataGrid.selectedItems && _advancedDataGrid.selectedItems.length > 1)
			{
				changeToInsertMode(null, false);
				_dLinkButtonDelete.enabled = true;
				return;
			}
			
			const selectedItem:Object = _advancedDataGrid.selectedItem;
			
			if (selectedItem)
				updateObjectBeanDictionaryInputs(selectedItem);
			
			//			if (_advancedDataGridToolBar)
			//			{
			//				if (_advancedDataGrid && _advancedDataGrid.dataProvider)
			//					_advancedDataGridToolBar.updateNumberOfEntriesLabel(_advancedDataGrid.dataProvider.length);
			//				else
			//					_advancedDataGridToolBar.updateNumberOfEntriesLabel(0);
			//			}
			
			dispatchEvent(new DCRUDToolBarEvent(DCRUDToolBarEvent._ON_CHANGE_SELECTED_ITEM));
		}
		
		// Message helper:
		
		private function showMaybeInIncorrectModeMsg(event:KeyboardEvent):void
		{
			if (_crudMode == _CRUD_MODE_SEARCH)
				if (new RegExp(StrConsts._REGEXP_RESTRICT_TO_ANYLETTER_NUMBER_SPACE).test(String.fromCharCode(event.charCode)))
				{
					_keyUpNumberOfTimesPressed++;
					
					if (_keyUpNumberOfTimesPressed > 9)
						if (_showModeWarning)
						{
							DNotificator._notStacked = true;
							DNotificator.showWarning(StrConsts.getRMString(79), focusManager, DNotificator._NOTIFICATION_POSITION_TOP_RIGHT, event.currentTarget as Sprite);
							_showModeWarning = false;
						}
				}
		}
		
		// -------------------------------------------------------------------------
		// Creation methods:
		
		private function createDLinkButtonSearch(label:String=null):void
		{
			_dLinkButtonSearch = new DLinkButtonSearch();
			_dLinkButtonSearch.focusEnabled = false;
			_dLinkButtonSearch.toolTip = StrConsts.getRMString(131);
			_dLinkButtonSearch.addEventListener(MouseEvent.CLICK, actionSearch, false, 0, true);
			
			if (label)
				_dLinkButtonSearch.label = label;
			
			addElement(_dLinkButtonSearch);
		}
		
		private function createDLinkButtonSearchAll():void
		{
			_dLinkButtonSearchAll = new DLinkButtonSearch();
			_dLinkButtonSearchAll.focusEnabled = false;
			_dLinkButtonSearchAll.toolTip = StrConsts.getRMString(132);
			_dLinkButtonSearchAll.label = StrConsts.getRMString(17);
			_dLinkButtonSearchAll.addEventListener(MouseEvent.CLICK, actionSearchAll, false, 0, true);
			addElement(_dLinkButtonSearchAll);
		}
		
		private function createDLinkButtonNew():void
		{
			_dLinkButtonNew = new DLinkButtonNew();
			_dLinkButtonNew.focusEnabled = false;
			_dLinkButtonNew.toolTip = StrConsts.getRMString(133);
			_dLinkButtonNew.addEventListener(MouseEvent.CLICK, actionNew, false, 0, true);
			addElement(_dLinkButtonNew);
		}
		
		private function createDLinkButtonSave():void
		{
			_dLinkButtonSave = new DLinkButtonSave();
			_dLinkButtonSave.focusEnabled = false;
			_dLinkButtonSave.toolTip = StrConsts.getRMString(134);
			_dLinkButtonSave.addEventListener(MouseEvent.CLICK, actionSave, false, 0, true);
			
			if (_associatedManyToManyProperty)
				_dLinkButtonSave.label = StrConsts.getRMString(155);
			
			addElement(_dLinkButtonSave);
		}
		
		private function createDLinkButtonDelete():void
		{
			_dLinkButtonDelete = new DLinkButtonDelete();
			_dLinkButtonDelete.enabled = false;
			_dLinkButtonDelete.focusEnabled = false;
			_dLinkButtonDelete.toolTip = StrConsts.getRMString(135);
			_dLinkButtonDelete.addEventListener(MouseEvent.CLICK, actionDelete, false, 0, true);
			addElement(_dLinkButtonDelete);
		}
		
		// -------------------------------------------------------------------------
		// Generic DCRUDToolBar private methods:
		
		private function registerSelectedItem(selectedItem:Object):void
		{
			this.selectedItem = selectedItem;
		}
		
		private function onSearchResultSuccess(returnObj:Array):void
		{
			if (returnObj && returnObj.length > 0)
			{
				if (_advancedDataGridToolBar) // TODO: What if the _advancedDataGridToolBar is null?
				{
					if (_advancedDataGridToolBar.currentState == _advancedDataGridToolBar.stateTree.name)
					{
						new DUtilDataProvider(
							_advancedDataGrid,
							_entityDescriptor._fieldDescriptorFKHolderFor._javaField,
							enableMe
						).flat2HierarchicalData(returnObj);
						return;
					}
				}
				
				_advancedDataGrid.dataProvider = new ArrayCollection(returnObj);
			}
			else
			{
				_advancedDataGrid.dataProvider = new ArrayCollection();
				
				var theOwner:Sprite = null;
				
				if (owner)
				{
					if (owner.parent)
						theOwner = owner.parent as Sprite;
					else
						theOwner = owner as Sprite;
				}
				
				if (!_associatedManyToManyProperty)
					DNotificator.showInfo(StrConsts.getRMString(35), focusManager, theOwner ? DNotificator._NOTIFICATION_POSITION_TOP_RIGHT : DNotificator._NOTIFICATION_POSITION_TOP_CENTER, theOwner);
			}
		}
		
		private function enableMe():void
		{
			enabled = true;
		}
		
		//		private function call_NOW_onAllDateFields():void
		//		{
		//			const dateInputs:Vector.<DBeanFieldDescriptor> = _entityBeanDescriptorsHandler._dateInputs;
		//
		//			if (dateInputs)
		//			{
		//				const dateInputsLength:int = dateInputs.length;
		//				var inputBeanDescriptor:DBeanFieldDescriptor;
		//				for (var i:int = 0; i < dateInputsLength; i++)
		//				{
		//					inputBeanDescriptor = dateInputs[i];
		//
		//					if (inputBeanDescriptor._defaultValue == DFxGUIConstants._STR_now)
		//						(_objectBeanDictionary[inputBeanDescriptor._javaField] as DDateField).now();
		//				}
		//			}
		//		}
		
		private function toggleNotUpdatableInputs(isEnabled:Boolean):void
		{
			if (_isThisInstanceAddedToStage)
			{
				const notUpdatableInputs:Vector.<FieldDescriptorBean> = _entityDescriptor._notUpdatableInputs;
				
				if (notUpdatableInputs)
				{
					const notUpdatableInputsLength:int = notUpdatableInputs.length;
					var comp:UIComponent;
					var theJavaField:String;
					for (var i:int = 0; i < notUpdatableInputsLength; i++)
					{
						theJavaField = _entityDescriptor._notUpdatableInputs[i]._javaField;
						
						if (theJavaField == _associatedManyToManyProperty)
							continue;
						
						comp = _objectBeanDictionary[theJavaField] as UIComponent;
						if (comp)
							comp.enabled = isEnabled;
					}
				}
			}
		}
		
		private function removeImageChoosersListeners():void
		{
			const imageFields:Vector.<FieldDescriptorBean> = _entityDescriptor._imageFields;
			
			if (imageFields)
			{
				const imageFieldsLength:int = imageFields.length;
				var imageChooser:DImageChooser;
				for (var i:int = 0; i < imageFieldsLength; i++)
				{
					imageChooser = getInput(imageFields[i]._javaField) as DImageChooser;
					imageChooser.removeEventListener(DUploadDownloadEvent._ON_UPLOAD_COMPLETE, afterSaveControlledExecution);
					imageChooser.removeEventListener(DLoadEvent._ON_EXCLUDED, onDImageChooserExcludingImage);
				}
			}
		}
		
		private function removeImageChoosersRelatedObjects():void
		{
			const imageFields:Vector.<FieldDescriptorBean> = _entityDescriptor._imageFields;
			
			if (imageFields)
			{
				const imageFieldsLength:int = imageFields.length;
				for (var i:int = 0; i < imageFieldsLength; i++)
					(getInput(imageFields[i]._javaField) as DImageChooser)._relatedObject = null;
			}
		}
		
		private function addImageChoosersRelatedObjects(relatedObject:Object):void
		{
			const imageFields:Vector.<FieldDescriptorBean> = _entityDescriptor._imageFields;
			
			if (imageFields)
			{
				const imageFieldsLength:int = imageFields.length;
				for (var i:int = 0; i < imageFieldsLength; i++)
					(getInput(imageFields[i]._javaField) as DImageChooser)._relatedObject = relatedObject;
			}
		}
		
		private function addDFileUploadersRelatedObjects(relatedObject:Object):void
		{
			if (_dFileUploadersDictionary)
			{
				const dFileUploadersDictionaryLength:int = _dFileUploadersDictionary.length;
				for (var i:int = 0; i < dFileUploadersDictionaryLength; i++)
					_dFileUploadersDictionary[i]._relatedObject = relatedObject;
			}
		}
		
		private function adjustAllManyToManyFormsSelectedItemLocked1(item:Object):void
		{
			if (_dManyToManyForms)
			{
				const mtmFormsLenght:int = _dManyToManyForms.length;
				var mtmForm:DManyToManyForm;
				for (var i:int = 0; i < mtmFormsLenght; i++)
				{
					mtmForm = _dManyToManyForms[i];
					mtmForm._selectedItemLocked1 = item;
				}
			}
		}
		
		private function adjustAllDCRUDFormsLockedItems(item:Object):void
		{
			if (_dCRUDForms)
			{
				const correctCodeDescriptor:FieldDescriptorBean = _entityDescriptor._codeField ? _entityDescriptor._codeField : _entityDescriptor._fieldDescriptorID;
				const dCRUDFormsLength:int = _dCRUDForms.length;
				for (var i:int = 0; i < dCRUDFormsLength; i++)
					_dCRUDForms[i].associateValue(item, correctCodeDescriptor, _entityDescriptor._descriptionField);
			}
		}
		
		// TODO: VOU UTILIZAR ESTE MÉTODO???
		/*private function cleanAllDImageChoosers():void
		{
		const imageFields:Vector.<DBeanFieldDescriptor> = _entityBeanDescriptorsHandler._imageFields;
		if (imageFields)
		{
		const imageFieldsLength:int = imageFields.length;
		for (var i:int = 0; i < imageFieldsLength; i++)
		(_objectBeanDictionary[imageFields[i]._javaField] as DImageChooser).clean();
		}
		}*/

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Required fields for search:
		
		// -------------------------------------------------------------------------
		// Getter and setter:
		
		public function get _requiredFieldsForSearch():Vector.<RequiredFieldForSearchBean>
		{
			var finalRequiredFieldsForSearch:Vector.<RequiredFieldForSearchBean> = requiredFieldsForSearch
			
			if (!finalRequiredFieldsForSearch && _entityDescriptor)
			{
				const entityDescriptorFields:Vector.<FieldDescriptorBean> = _entityDescriptor._requiredFieldsForSearch;
				
				if (entityDescriptorFields)
				{
					const edfLength:uint = entityDescriptorFields.length;
					var item:FieldDescriptorBean;
					var requiredFieldBean:RequiredFieldForSearchBean;
					
					for (var i:uint = 0; i < edfLength; i++)
					{
						item = entityDescriptorFields[i];
						
						requiredFieldBean = new RequiredFieldForSearchBean();
						requiredFieldBean._fieldName = item._javaField;
						requiredFieldBean._fieldNameFormatted = item._fieldNameFormatted;
						requiredFieldBean._requiredForSearch = item._requiredForSearch;
						requiredFieldBean._bypassRequiredFieldsForSearch = item._bypassRequiredFieldsForSearch;
						requiredFieldBean._minLengthForSearch = item._minLengthForSearch;
						requiredFieldBean.validateMyData();
						
						if (!finalRequiredFieldsForSearch)
							finalRequiredFieldsForSearch = new Vector.<RequiredFieldForSearchBean>();
						
						finalRequiredFieldsForSearch.push(requiredFieldBean);
					}
				}
			}
			
			return finalRequiredFieldsForSearch;
		}
		
		public function set _requiredFieldsForSearch(value:Vector.<RequiredFieldForSearchBean>):void
		{
			if (value)
			{
				const vectorLength:uint = value.length;
				for (var i:uint = 0; i < vectorLength; i++)
					value[i].validateMyData();
				
				requiredFieldsForSearch = value;
			}
			else
				requiredFieldsForSearch = null;
		}
		
		// -------------------------------------------------------------------------
		// Validating:
		
		/**
		 * @return <code>true</code> if all inputs required for search are correctly populated.
		 */
		public function validateRequiredFieldsForSearch():Boolean
		{
			const requiredFieldsForSearch:Vector.<RequiredFieldForSearchBean> = _requiredFieldsForSearch;
			var valErrorFound:Boolean = false;
			
			if (requiredFieldsForSearch)
			{
				var item:RequiredFieldForSearchBean;
				var minLengthForSearch:Number;
				var input:Object;
				var inputContent:String;
				
				const vectorLength:uint = requiredFieldsForSearch.length;
				
				for (var i:uint = 0; i < vectorLength; i++)
				{
					item = requiredFieldsForSearch[i];
					
					minLengthForSearch = item._minLengthForSearch;
					inputContent = _objectBeanDictionary[item._fieldName][_contentProperty];
					
					if (item._bypassRequiredFieldsForSearch)
					{
						if (inputContent)
						{
							if (minLengthForSearch)
							{
								if (validateMinLengthForSearch(minLengthForSearch, inputContent))
									return true;
							}
							else
								return true;
						}
					}
					else if (item._requiredForSearch || minLengthForSearch)
					{
						if (inputContent)
						{
							if (minLengthForSearch)
							{
								if (!validateMinLengthForSearch(minLengthForSearch, inputContent))
									valErrorFound = true;
							}
						}
						else
							valErrorFound = true;
					}
				}
				
				for (var j:uint = 0; j < vectorLength; j++)
				{
					item = requiredFieldsForSearch[j];
					minLengthForSearch = item._minLengthForSearch;
					input = _objectBeanDictionary[item._fieldName];
					inputContent = input[_contentProperty];
					
					if (item._bypassRequiredFieldsForSearch)
					{
						if (inputContent)
						{
							if (minLengthForSearch)
							{
								if (!validateMinLengthForSearch(minLengthForSearch, inputContent))
									addMinLengthString(input, minLengthForSearch);
							}
						}
						else if (valErrorFound)
							addErrorString(input);
					}
					else if (item._requiredForSearch || minLengthForSearch)
					{
						if (inputContent)
						{
							if (minLengthForSearch)
							{
								if (!validateMinLengthForSearch(minLengthForSearch, inputContent))
									addMinLengthString(input, minLengthForSearch);
							}
						}
						else
							addErrorString(input);
					}
				}
			}
			
			return !valErrorFound;
		}
		
		protected function validateMinLengthForSearch(minLengthForSearch:Number, textStr:String):Boolean
		{
			if (!minLengthForSearch)
				return true;
			else
				return textStr.length >= minLengthForSearch;
		}
		
		protected function addErrorString(input:Object):void
		{
			if (input.hasOwnProperty("errorString"))
				input.errorString = StrConsts.getRMString(167);
		}
		
		protected function addMinLengthString(input:Object, minLength:Number):void
		{
			if (input.hasOwnProperty("errorString"))
				input.errorString = DUtilString.upperCaseFirstLetter(StrConsts.getRMString(168)) + ": " + minLength;
		}
		
		public function generateReqFieldsForSearchNotificationStr():String
		{
			if (_requiredFieldsForSearch)
			{
				// Obtaining the necessary information.
				
				var reqForSearchErrArr:Array = null;
				var bypassErrArr:Array = null;
				
				const vectorLength:uint = _requiredFieldsForSearch.length;
				for (var i:uint = 0; i < vectorLength; i++)
				{
					const reqForSearchBean:RequiredFieldForSearchBean = _requiredFieldsForSearch[i];
					
					if (reqForSearchBean._bypassRequiredFieldsForSearch)
					{
						if (!bypassErrArr)
							bypassErrArr = new Array();
						
						bypassErrArr.push(generateReqFieldForSearchError(reqForSearchBean));
					}
					else if (reqForSearchBean._requiredForSearch || reqForSearchBean._minLengthForSearch)
					{
						if (!reqForSearchErrArr)
							reqForSearchErrArr = new Array();
						
						reqForSearchErrArr.push(generateReqFieldForSearchError(reqForSearchBean));
					}
				}
				
				// Creating the notification string with the required fields for the search.

				var errorStr:String = "";
				
				if (reqForSearchErrArr && reqForSearchErrArr.length > 0)
					errorStr +=  StrConsts.getRMString(146) + "<br /><br /><b>" + reqForSearchErrArr.join("<br />") + "</b>";
				
				if (errorStr && bypassErrArr)
				{
					if (bypassErrArr.length == 1)
						errorStr += "<br /><br /><b>" + StrConsts.getRMString(111).toUpperCase() + "</b>, " + StrConsts.getRMString(147) + " <b>" + bypassErrArr[0] + "</b>";
					else
						errorStr += "<br /><br /><b>" + StrConsts.getRMString(111).toUpperCase() + "</b>, " + StrConsts.getRMString(148) + ":<br /><br /><b>" + bypassErrArr.join("<br />") + "</b>";
				}
				
				return errorStr;
			}
			else
				return "";
		}
		
		protected function generateReqFieldForSearchError(reqForSearchBean:RequiredFieldForSearchBean):String
		{
			var errStr:String = "<font color=\"" + StrConsts._COLOR_RED_FIREBRICK_HTML + "\">" + reqForSearchBean._fieldNameFormatted + "</font>";
			
			if (reqForSearchBean._minLengthForSearch)
				errStr += " (" + StrConsts.getRMString(168) + ": <font color=\"" + StrConsts._COLOR_RED_FIREBRICK_HTML + "\">" + reqForSearchBean._minLengthForSearch + "</font>)";
			
			return errStr;
		}
		
		// -------------------------------------------------------------------------
	}
}
