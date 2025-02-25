package br.com.dannemann.gui.component.input
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TitleWindow;
	import mx.controls.ToolTip;
	import mx.core.FlexGlobals;
	import mx.events.ValidationResultEvent;
	import mx.managers.PopUpManager;
	import mx.managers.ToolTipManager;
	
	import spark.components.Group;
	import spark.layouts.VerticalAlign;
	
	import br.com.dannemann.gui.XFrontConfigurator;
	import br.com.dannemann.gui.bean.DSolSearchPanelBean;
	import br.com.dannemann.gui.component.DBitmapImage;
	import br.com.dannemann.gui.component.DFastSearcher;
	import br.com.dannemann.gui.component.autoComplete.DAutoComplete;
	import br.com.dannemann.gui.component.container.DApplication;
	import br.com.dannemann.gui.component.container.DHGroup;
	import br.com.dannemann.gui.component.validation.RequirableComponent;
	import br.com.dannemann.gui.controller.BlazeDs;
	import br.com.dannemann.gui.controller.DSession;
	import br.com.dannemann.gui.controller.EntityDescriptor;
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.dto.persistence.Request;
	import br.com.dannemann.gui.event.DSelectOneListingEvent;
	import br.com.dannemann.gui.library.DIconLibrary;
	import br.com.dannemann.gui.util.DUtilFocus;
	import br.com.dannemann.gui.util.DUtilString;
	import br.com.dannemann.gui.util.DUtilValidator;
	import br.com.dannemann.gui.validator.DValidator;

	[Event(name="onChange", type="br.com.dannemann.gui.event.DSelectOneListingEvent")]

	// TODO: CHECK FOR "if (_codeTextInput)" AS NOW WE CREATE IT ON BEFORE THE CONSTRUCTION (MAYBE REPLACE BY A CHECKING IF ITS ON EAGER MODE).
	
	public class DSelectOneListing extends DHGroup implements DInput, RequirableComponent
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Fields:
		
		// -------------------------------------------------------------------------
		// Features:

		protected var entityType:String;
		protected var descriptionField:String;
		protected var descriptionFieldJavaType:String;
		protected var codeField:String;
		protected var codeFieldJavaType:String;
		protected var idField:String;
		protected var idFieldJavaType:String;
		
		public var _entityDescriptor:EntityDescriptor;
		
		// Mode:
		
		public static const _AUTO_COMPLETE_MODE_LAZY:String = "LAZY";
		public static const _AUTO_COMPLETE_MODE_EAGER:String = "EAGER";
		
		public var _autoCompleteMode:String = _AUTO_COMPLETE_MODE_LAZY;
		
		// Validation:
		private var required:Boolean;
		
		// Back-end services:
		public var _serverDestination:String = XFrontConfigurator._crudServiceDestination;
		public var _findByIdMethod:String = XFrontConfigurator._findByIdMethod;
		public var _findByExampleMethod:String = XFrontConfigurator._findByExampleMethod;
		public var _findAllMethod:String = XFrontConfigurator._findAllMethod;
		protected var tenant:String;
		
		private var selectedItem:Object;

		// -------------------------------------------------------------------------
		// Components:
		
		public const _descriptionTextInput:DAutoComplete = createAutoCompleteInput();
		public const _codeTextInput:DAutoComplete = createAutoCompleteInput();
		
		public var _descriptionValidator:DValidator;
		public var _codeValidator:DValidator;
		
		public const _groupBitMapGoogle:Group = new Group();
		public const _groupBitMapArrow:Group = new Group();

		public const _descriptionLazyTimer:Timer = new Timer(700, 1);
		public const _codeLazyTimer:Timer = new Timer(700, 1);

		public var _loadingToolTip:ToolTip;
		
		public const _blazeds:BlazeDs = new BlazeDs();
		public const _request:Request = new Request();
		public var _eagerDataProvider:Array;
		
		public var _dSelectOneListingSearchPanel:DSelectOneListingSearchPanel;
		public var _dSelectOneListingSearchPanelReference:TitleWindow;
		
		// Internal control:
		
		protected var _isDescriptionFieldNameAndJavaTypePopulated:Boolean;
		protected var _isIdFieldNameAndJavaTypePopulated:Boolean;
		protected var _isCodeFieldNameAndJavaTypePopulated:Boolean;
		
		
		
		
		
		
		
		
		
		
		
		
		public var _solDataGridColumnsCSV:String;
		public var _solDataGridColumnsToRemoveCSV:String;
		public var _solDataGridColumnsManyToOneCSV:String;
		public var _solLikeDefaults:String;
		
		
		

		
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
		
		public function DSelectOneListing()
		{
			focusEnabled = false; // This component is primarily a horizontal group. We only want to focus the text inputs and not the group itself.
			verticalAlign = VerticalAlign.MIDDLE;
			
			// We don't want to start searching at the exact same moment the user types a character. We need to add a little delay before it.
			_descriptionLazyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete_DescriptionInput, false, 0, true);
			_codeLazyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete_CodeInput, false, 0, true);
		}

		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// UIComponent:

		override protected function createChildren():void
		{
			super.createChildren();
			
			// Must call this first.
			validateRequiredFields();
			
			if (_isDescriptionFieldNameAndJavaTypePopulated)
				createDTextInputDescription();
			if (_isIdFieldNameAndJavaTypePopulated || _isCodeFieldNameAndJavaTypePopulated)
				createDTextInputID();

			createSearchGoogleButton();
			createGoToNewScreenButton();
			
			configureRequestObj();
			
			if (isEagerModeEnabled())
				loadEagerDataProvider();
		}
		
		override protected function updateDisplayList(unscaled:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			_descriptionTextInput.dropDownWidth = width;
			_codeTextInput.dropDownWidth = width;
		}

		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Inputs:
		
		protected function createAutoCompleteInput():DAutoComplete
		{
			const textInput:DAutoComplete = new DAutoComplete();
			textInput.allowDuplicates = false;
			textInput.allowMultipleSelection = false;
			textInput.allowNewValues = false;
			textInput.backspaceAction = "remove";
			textInput.dropDownRowCount = 17; // TODO: SHOULD THIS BE DYNAMIC BECAUSE OF THE SCREEN SIZE??? TEST IT.
			textInput.labelFunction = labelFunction;
			textInput.matchType = "anyPart";
			textInput.setStyle("selectedItemStyleName", "normal");
			return textInput;
		}
		
		protected function createDTextInputDescription():void
		{
			// TODO: _descriptionTextInput needs to be added to a container before we set _javaType (because it's is not finished yet).
			addElement(_descriptionTextInput);
			
			//  _descriptionTextInput.
			_descriptionTextInput.enableClearIcon = true;
			_descriptionTextInput.labelField = getLastFieldOfDescriptionField();
			_descriptionTextInput.percentWidth = 100;
			_descriptionTextInput._javaType = _descriptionFieldJavaType;
			_descriptionTextInput.addEventListener(Event.CHANGE, syncCodeInputValue, false, 0, true); // DAutoComplete CHANGE event is triggered when an item is chosen on the pop-up list (not while typing).
			
			if (isNormalModeEnabled())
			{
				_descriptionTextInput._executeOnFocusOut = onFocusOutInputs;
				_descriptionTextInput.textInput.addEventListener(Event.CHANGE, onTyping_DescriptionInput, false, 0, true); // Listening for user typing on the text input.
			}
		}
		
		protected function createDTextInputID():void
		{
			addElement(_codeTextInput);
			
			_descriptionTextInput.enableClearIcon = false;
			_codeTextInput.labelField = getMostPrecedenceCodeField();
			_codeTextInput._javaType = getMostPrecedenceCodeFieldJavaType();
			_codeTextInput.addEventListener(Event.CHANGE, syncDescriptionInputValue, false, 0, true); // DAutoComplete CHANGE event is triggered when an item is chosen on the pop-up list (not while typing).
			
			if (_isDescriptionFieldNameAndJavaTypePopulated)
				_codeTextInput.width = 55;
			else
				_codeTextInput.percentWidth = 100;
			
			if (isNormalModeEnabled())
			{
				_codeTextInput._executeOnFocusOut = onFocusOutInputs;
				_codeTextInput.textInput.addEventListener(Event.CHANGE, onTyping_CodeInput, false, 0, true);
			}
		}
		
		protected function createSearchGoogleButton():void
		{
			_groupBitMapGoogle.buttonMode = true;
			_groupBitMapGoogle.addElement(new DBitmapImage(DIconLibrary.GOOGLE));
			_groupBitMapGoogle.addEventListener(MouseEvent.CLICK, click_createSOLSearchScreen, false, 0, true);
			addElement(_groupBitMapGoogle);
		}
		
		protected function createGoToNewScreenButton():void
		{
			_groupBitMapArrow.buttonMode = true;
			_groupBitMapArrow.addElement(new DBitmapImage(DIconLibrary.ARROW_GOLD_RIGHT));
			_groupBitMapArrow.addEventListener(MouseEvent.CLICK, click_bitMapArrow, false, 0, true);
			addElement(_groupBitMapArrow);
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
		// Features:
		
		// -------------------------------------------------------------------------
		// Entity type:
		
		public function get _entityType():String
		{
			var finalEntityType:String = entityType;
			
			if (!finalEntityType && (_entityDescriptor && _entityDescriptor._crudDescriptor))
				finalEntityType = _entityDescriptor._crudDescriptor._className;
			
			return finalEntityType;
		}
		
		public function set _entityType(entityType:String):void
		{
			this.entityType = entityType;
		}
		
		// -------------------------------------------------------------------------
		// Description:
		
		// Field:
		
		public function get _descriptionField():String
		{
			var finalDescriptionField:String = descriptionField;
			
			if (!finalDescriptionField && (_entityDescriptor && _entityDescriptor._descriptionField))
				finalDescriptionField = _entityDescriptor._descriptionField._dataGridColumn;
			
			return finalDescriptionField;
		}
		
		public function set _descriptionField(descriptionField:String):void
		{
			this.descriptionField = descriptionField;
		}
		
		// Java type:
		
		public function get _descriptionFieldJavaType():String
		{
			var finalDescriptionFieldJavaType:String = descriptionFieldJavaType;
			
			if (!finalDescriptionFieldJavaType && (_entityDescriptor && _entityDescriptor._descriptionField))
				finalDescriptionFieldJavaType = _entityDescriptor._descriptionField._javaType;
			
			return finalDescriptionFieldJavaType;
		}
		
		public function set _descriptionFieldJavaType(descriptionFieldJavaType:String):void
		{
			this.descriptionFieldJavaType = descriptionFieldJavaType;
		}
		
		// -------------------------------------------------------------------------
		// ID:
		
		// Field:
		
		public function get _idField():String
		{
			var finalIdField:String = idField;
			
			if (!finalIdField && (_entityDescriptor && _entityDescriptor._fieldDescriptorID))
				finalIdField = _entityDescriptor._fieldDescriptorID._javaField;
			
			return finalIdField;
		}
		
		public function set _idField(idField:String):void
		{
			this.idField = idField;
		}
		
		// Java type:
		
		public function get _idFieldJavaType():String
		{
			var finalIdFieldJavaType:String = idFieldJavaType;
			
			if (!finalIdFieldJavaType && (_entityDescriptor && _entityDescriptor._fieldDescriptorID))
				finalIdFieldJavaType = _entityDescriptor._fieldDescriptorID._javaType;
			
			return finalIdFieldJavaType;
		}
		
		public function set _idFieldJavaType(idFieldJavaType:String):void
		{
			this.idFieldJavaType = idFieldJavaType;
		}
		
		// -------------------------------------------------------------------------
		// Code:
		
		// Field:
		
		public function get _codeField():String
		{
			var finalCodeField:String = codeField;
			
			if (!finalCodeField && (_entityDescriptor && _entityDescriptor._codeField))
				finalCodeField = _entityDescriptor._codeField._javaField;
			
			return finalCodeField;
		}
		
		public function set _codeField(codeField:String):void
		{
			this.codeField = codeField;
		}
		
		// Java type:
		
		public function get _codeFieldJavaType():String
		{
			var finalCodeFieldJavaType:String = codeFieldJavaType;
			
			if (!finalCodeFieldJavaType && (_entityDescriptor && _entityDescriptor._codeField))
				finalCodeFieldJavaType = _entityDescriptor._codeField._javaType;
			
			return finalCodeFieldJavaType;
		}
		
		public function set _codeFieldJavaType(codeFieldJavaType:String):void
		{
			this.codeFieldJavaType = codeFieldJavaType;
		}
		
		// -------------------------------------------------------------------------
		// Tenant:
		
		public function get _tenant():String
		{
			var finalTenant:String = tenant;
			
			if (!finalTenant)
				finalTenant = DSession._tenant;
			
			return finalTenant;
		}
		
		public function set _tenant(tenant:String):void
		{
			this.tenant = tenant;
		}
		
		// -------------------------------------------------------------------------
		// Selected item:
		
		public function get _selectedItem():Object
		{
			return selectedItem;
		}
		
		public function set _selectedItem(value:Object):void
		{
			selectedItem = value;
			
			if (_descriptionTextInput.parent)
			{
				_descriptionTextInput.clear();
				_descriptionTextInput.selectedItems.addItem(selectedItem);
			}
			
			if (_codeTextInput.parent)
			{
				_codeTextInput.clear();
				_codeTextInput.selectedItems.addItem(selectedItem);
			}
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
		// Inputs behavior:
		
		protected function labelFunction(item:Object):String
		{
			if (item is String)
				return item as String;
			else
			{
				var label:String;
				var needDash:Boolean = false;
				
				const mostPrecedenceCodeField:String = getMostPrecedenceCodeField();
				if (mostPrecedenceCodeField)
				{
					label = item[mostPrecedenceCodeField];
					needDash = true;
				}
				
				if (_isDescriptionFieldNameAndJavaTypePopulated)
				{
					if (needDash)
						label += " - " + item[_descriptionField];
					else
						label = item[_descriptionField];
				}
				
				return label;
			}
		}
		
		protected function onTypingInputs(event:Event, target:DAutoComplete, timer:Timer):void
		{
			if (target.searchText)
			{
				openLoadingToolTip(target);
				target.hideDropDown();
				startSearchTimer(timer);
			}
			else
			{
				target.hideDropDown();
				closeLoadingToolTip();
			}
		}
		
		protected function onFocusOutInputs(event:FocusEvent):void
		{
			if (_descriptionTextInput.parent && _codeTextInput.parent)
			{
				if (_descriptionTextInput.selectedItem && !_codeTextInput.selectedItem)
					_selectedItem = _descriptionTextInput.selectedItem;
				else if (_codeTextInput.selectedItem && !_descriptionTextInput.selectedItem)
					_selectedItem = _codeTextInput.selectedItem;
			}
		}
		
		protected function startSearchTimer(timer:Timer):void
		{
			if (timer.running)
			{
				timer.stop();
				timer.start();
			}
			else
				timer.start();
		}
		
		protected function onLoadEagerDataProvider(response:Object):void
		{
			if (!response)
			{
				// TODO: THROW AN ERROR.
			}
			
			const result:Array = response.result;
			
			if (!result)
			{
				// TODO: THROW AN ERROR.
			}
			
			_descriptionTextInput.dataProvider = new ArrayCollection(result);
			_descriptionTextInput.prompt = "";
			
			_codeTextInput.dataProvider = new ArrayCollection(result);
			_codeTextInput.prompt = "";
			
			_eagerDataProvider = result;
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Description:
		
		protected function onTyping_DescriptionInput(event:Event):void
		{
			onTypingInputs(event, _descriptionTextInput, _descriptionLazyTimer);
		}

		protected function onTimerComplete_DescriptionInput(event:TimerEvent):void
		{
			if (_descriptionTextInput.searchText)
				findDescriptionByExample();
			else
				closeLoadingToolTip();
		}
		
		protected function syncCodeInputValue(event:Event):void
		{
			_selectedItem = _descriptionTextInput.selectedItem;
			dispatchEvent(new DSelectOneListingEvent(DSelectOneListingEvent._ON_CHANGE)); // TODO: AM I USING THIS? IF NOT REMOVE.
		}
		
		protected function onFindDescriptionSuccess(response:Object):void
		{
			if (!response)
			{
				// TODO: THROW AN ERROR.
			}
			
			const result:Array = response.result;
			
			if (!result)
			{
				// TODO: THROW AN ERROR.
			}
			
			_descriptionTextInput.dataProvider = new ArrayCollection(result);
			_descriptionTextInput.hideDropDown();
			_descriptionTextInput.showDropDown();

			closeLoadingToolTip();
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// ID/Code:
		
		protected function onTyping_CodeInput(event:Event):void
		{
			onTypingInputs(event, _codeTextInput, _codeLazyTimer);
		}
		
		protected function onTimerComplete_CodeInput(event:TimerEvent):void
		{
			if (_codeTextInput.searchText)
				findById();
			else
				closeLoadingToolTip();
		}
		
		protected function syncDescriptionInputValue(event:Event):void
		{
			_selectedItem = _codeTextInput.selectedItem;
			dispatchEvent(new DSelectOneListingEvent(DSelectOneListingEvent._ON_CHANGE)); // TODO: AM I USING THIS? IF NOT REMOVE.
		}
		
		protected function onFindCodeSuccess(response:Object):void
		{
			if (!response)
			{
				// TODO: THROW AN ERROR.
			}
			
			const result:Object = response.result;
			
			if (!result)
			{
				// TODO: THROW AN ERROR.
			}
			
			if (result)
			{
				_codeTextInput.dataProvider = new ArrayCollection([ result ]);
				_codeTextInput.showDropDown();
			}
			
			closeLoadingToolTip();
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Buttons:
		
		protected function click_bitMapArrow(event:MouseEvent):void
		{
			const app:DApplication = FlexGlobals.topLevelApplication as DApplication;
			app.addMDIWindow(app.entityBeanDescriptorsHandlerToDBeanMenu(_entityDescriptor));
		}
		
		protected function click_createSOLSearchScreen(event:MouseEvent):void
		{
			DFastSearcher._locked = true;
			
			if (!_dSelectOneListingSearchPanel)
			{
				const dBeanSOLSearchPanel:DSolSearchPanelBean = new DSolSearchPanelBean();
				dBeanSOLSearchPanel._columnsForHibernateSelectCSV = _solDataGridColumnsCSV ? _solDataGridColumnsCSV : StrConsts._CHAR_ASTERISK;
				dBeanSOLSearchPanel._dSelectOneListingParent = this;
				dBeanSOLSearchPanel._entityBeanDescriptorsHandler = _entityDescriptor;
				dBeanSOLSearchPanel._solDataGridColumnsCSV = _solDataGridColumnsCSV;
				dBeanSOLSearchPanel._solDataGridColumnsToRemoveCSV = _solDataGridColumnsToRemoveCSV;
				dBeanSOLSearchPanel._solDataGridColumnsManyToOneCSV = _solDataGridColumnsManyToOneCSV;
				dBeanSOLSearchPanel._solLikeDefaults = _solLikeDefaults;
				
				
				
				
				
				
				
				
				
				
				
				
				_dSelectOneListingSearchPanel = new DSelectOneListingSearchPanel(dBeanSOLSearchPanel);
				_dSelectOneListingSearchPanel._eagerDataProvider = _eagerDataProvider;
				_dSelectOneListingSearchPanel._serverDestination = _serverDestination;
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				_dSelectOneListingSearchPanelReference = _dSelectOneListingSearchPanel.createSearchPanel();
			}
			
			_dSelectOneListingSearchPanelReference.validateNow();
			
			PopUpManager.addPopUp(_dSelectOneListingSearchPanelReference, FlexGlobals.topLevelApplication as DisplayObject, true);
			PopUpManager.centerPopUp(_dSelectOneListingSearchPanelReference);
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
		
		public function isEagerModeEnabled():Boolean
		{
			return _autoCompleteMode.toUpperCase() == _AUTO_COMPLETE_MODE_EAGER.toUpperCase();
		}
		
		protected function isNormalModeEnabled():Boolean
		{
			return _autoCompleteMode.toUpperCase() == _AUTO_COMPLETE_MODE_LAZY.toUpperCase();
		}
		
		public function loadEagerDataProvider():void
		{
			// TODO: CANCEL ANY PENDING OPERATION BEFORE EXECUTE A NEW ONE?
			
			_descriptionTextInput.prompt = StrConsts.getRMString(140) + "...";
			_codeTextInput.prompt = "...";
			
			_blazeds.invoke3(_serverDestination, _findAllMethod, _request, onLoadEagerDataProvider, this);
		}

		public function findById():void
		{
			// TODO: CANCEL ANY PENDING OPERATION BEFORE EXECUTE A NEW ONE?

			const entity:Object = new Object();
			entity[getMostPrecedenceCodeField()] = _codeTextInput.searchText;
			
			_request.object = entity;

			_blazeds.invoke3(_serverDestination, _findByIdMethod, _request, onFindCodeSuccess);
		}

		public function findDescriptionByExample():void
		{
			// TODO: CANCEL ANY PENDING OPERATION BEFORE EXECUTE A NEW ONE?
			
			const entity:Object = new Object();
			entity[getLastFieldOfDescriptionField()] = _descriptionTextInput.searchText;
			
			_request.object = entity;
			
			_blazeds.invoke3(_serverDestination, _findByExampleMethod, _request, onFindDescriptionSuccess);
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
		// Validation:
		
		// RequirableComponent:
		
		public function get _required():Boolean
		{
			return required;
		}
		
		public function set _required(value:Boolean):void
		{
			required = value;
			
			createDescriptionValidatorIfNeeded(required);
			createCodeValidatorIfNeeded(required);
			
			if (_descriptionValidator)
				_descriptionValidator.required = required;
			if (_codeValidator)
				_codeValidator.required = required;
			
			validateInput();
		}
		
		// ValidatableComponent:
		
		public function enableValidators(value:Boolean):void
		{
			DUtilValidator.handleValidatorsEnabling(_descriptionValidator, value, this);
			DUtilValidator.handleValidatorsEnabling(_codeValidator, value, this);
		}
		
		public function validateInput(value:Object=null):ValidationResultEvent
		{
			if (_descriptionValidator/* && _codeValidator*/) // Both validators are created together so, null-checking just one gives the same result as null-checking both.
			{
				const resultDesc:ValidationResultEvent = _descriptionValidator.validate();
				const resultCode:ValidationResultEvent = _codeValidator.validate();
				
				return DUtilValidator.mergeValidationResults(resultDesc, resultCode);
			}
			else
				return new ValidationResultEvent(ValidationResultEvent.VALID);
		}
		
		// IValidatorListener:
		
		override public function set errorString(value:String):void
		{
			_descriptionTextInput.errorString = value;
			_codeTextInput.errorString = value;
		}
		
		override public function validationResultHandler(event:ValidationResultEvent):void
		{
			super.validationResultHandler(event);
			
			DUtilFocus.updateFocusRetangle(_descriptionTextInput);
			DUtilFocus.updateFocusRetangle(_codeTextInput);
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Protected:
		
		// Description input:
		
		protected function createDescriptionValidator():void
		{
			_descriptionValidator = new DValidator();
		}
		
		protected function setDescriptionValidatorDefaults():void
		{
			_descriptionValidator.property = "text";
			_descriptionValidator.source = _descriptionTextInput;
			
			if (!hasEventListener(Event.CHANGE))
				addEventListener(Event.CHANGE, validateInput, false, 0, true);
		}
		
		protected function createDescriptionValidatorIfNeeded(value:Boolean):void
		{
			if (value && !_descriptionValidator)
			{
				createDescriptionValidator();
				setDescriptionValidatorDefaults();
			}
		}
		
		// Code input:
		
		protected function createCodeValidator():void
		{
			_codeValidator = new DValidator();
		}
		
		protected function setCodeValidatorDefaults():void
		{
			_codeValidator.property = "text";
			_codeValidator.source = _codeTextInput;
			
			if (!hasEventListener(Event.CHANGE))
				addEventListener(Event.CHANGE, validateInput, false, 0, true);
		}
		
		protected function createCodeValidatorIfNeeded(value:Boolean):void
		{
			if (value && !_codeValidator)
			{
				createCodeValidator();
				setCodeValidatorDefaults();
			}
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
		// Overrides/Implementations:
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			if (_codeTextInput)
			{
				_codeTextInput.editable = value;
				_codeTextInput.enabled = value;
			}
			
			_descriptionTextInput.editable = value;
			_descriptionTextInput.enabled = value;
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// DIGUIInput implementation:
		
		public function get text():String
		{
			if (selectedItem)
			{
				if (selectedItem is String)
					return selectedItem as String;
				else
					return selectedItem[getMostPrecedenceCodeField()];
			}
			else
				return "";
		}

		public function set text(value:String):void
		{
			setValueAsString2(value);
		}

		override public function setFocus():void
		{
			if (_descriptionTextInput.enabled)
				_descriptionTextInput.setFocus();
		}

		public function clean():void
		{
//			cancelOperations();

			selectedItem = null;

			if (_codeTextInput)
				_codeTextInput.clear();

			_descriptionTextInput.clear();
		}

		public function dispose():void
		{
//			cancelOperations();

			closeLoadingToolTip();

			_descriptionTextInput.hideDropDown();
			_descriptionTextInput.labelFunction = null;
			_descriptionTextInput._executeOnFocusOut = null;
			_descriptionTextInput.removeEventListener(Event.CHANGE, syncCodeInputValue);

			if (isNormalModeEnabled())
			{
				if (_codeTextInput)
				{
					_codeTextInput.hideDropDown();
					_codeTextInput.labelFunction = null;
					_codeTextInput._executeOnFocusOut = null;
					_codeTextInput.removeEventListener("change", syncDescriptionInputValue);
				}
			}

			_groupBitMapGoogle.removeEventListener(MouseEvent.CLICK, click_createSOLSearchScreen);
			_groupBitMapArrow.removeEventListener(MouseEvent.CLICK, click_bitMapArrow);

			if (hasEventListener(FocusEvent.FOCUS_OUT))
				removeEventListener(FocusEvent.FOCUS_OUT, validateInput);

			_codeLazyTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete_CodeInput);
			_descriptionLazyTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete_DescriptionInput);
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
		// Public:
		
		public function get text2():String
		{
			if (selectedItem)
				return selectedItem[getMostPrecedenceCodeField()] + " - " + selectedItem[_descriptionField];
			else
				return "";
		}
		
		// TODO: Change this method name.
		public function setValueAsString2(code:String, description:String=null):void
		{
			if (description)
			{
				selectedItem = createObjValue(code, description);
				
				if (_codeTextInput)
				{
					_codeTextInput.selectedItems.addItem(selectedItem);
					_codeTextInput.validateNow();
				}
				
				_descriptionTextInput.selectedItems.addItem(selectedItem);
				_descriptionTextInput.validateNow();
			}
			else
			{
				// TODO: Get from server.
			}
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
		// Protected:
		
		protected function validateRequiredFields():void
		{
			if (!_entityType)
				throw new Error("TODO: DSOL TEM QUE TER TIPO"); // TODO: WORK ON THIS
			
			_isDescriptionFieldNameAndJavaTypePopulated = _descriptionField && _descriptionFieldJavaType;
			_isIdFieldNameAndJavaTypePopulated = _idField && _idFieldJavaType;
			_isCodeFieldNameAndJavaTypePopulated = _codeField && _codeFieldJavaType;
			
			if (!(_isDescriptionFieldNameAndJavaTypePopulated || _isIdFieldNameAndJavaTypePopulated || _isCodeFieldNameAndJavaTypePopulated))
				// TODO: WORK ON THIS.
				// throw new Error(StrConsts.getRMString2("500160") + ". " + StrConsts.getRMString(141) + ": " + _entityDescriptor._crudDescriptor._className);
				throw new Error("DSOL MUST FILL ID AND JAVATYPE OOU CODE AND JAVATPE OU DESCRIPTIN");
		}
		
		protected function configureRequestObj():void
		{
			_request.tenant = _tenant;
			_request.objectType = _entityType;
		}
		
		protected function getMostPrecedenceCodeField():String
		{
			if (_codeField)
				return _codeField;
			else if (_idField)
				return _idField;
			else
				return null;
		}
		
		protected function getMostPrecedenceCodeFieldJavaType():String
		{
			if (_codeFieldJavaType)
				return _codeFieldJavaType;
			else if (_idFieldJavaType)
				return _idFieldJavaType;
			else
				return null;
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
		// Loading tool tip:
		
		public function openLoadingToolTip(targetInput:DAutoComplete):void
		{
			const pt:Point = targetInput.localToGlobal(new Point(targetInput.textInput.textInput.x, targetInput.textInput.textInput.y - 30));
			
			if (_loadingToolTip)
			{
				_loadingToolTip.x = pt.x;
				_loadingToolTip.y = pt.y;
				_loadingToolTip.visible = true;
			}
			else
			{
				_loadingToolTip = ToolTipManager.createToolTip(StrConsts.getRMString(140) + "...", pt.x, pt.y, "errorTipAbove") as ToolTip;
				_loadingToolTip.setStyle("styleName", "loadingToolTip");
			}
		}
		
		public function closeLoadingToolTip():void
		{
			if (_loadingToolTip)
				_loadingToolTip.visible = false;
		}












		// -------------------------------------------------------------------------
		// Private generic interface:



		protected function createObjValue(id:String, description:String):Object
		{
			const newItem:Object = new Object();
			newItem[getMostPrecedenceCodeField()] = id;
			newItem[getLastFieldOfDescriptionField()] = description;
			return newItem;
		}

		// TODO: DO I NEED THIS?
		private function getLastFieldOfDescriptionField():String
		{
			return DUtilString.getStringAfterFirstOccurrenceOf(".", _descriptionField);
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
		// Old code backup:
		
//		// Lock interface:
//
//		public var _dCRUDToolBar:DCRUDToolBar;
//		
//		public function addMyLock():void
//		{
//			if (canILockTheCRUDToolBar())
//				_dCRUDToolBar._dLinkButtonSave.enabled = false;
//		}
//
//		public function releaseMyLock():void
//		{
//			if (canILockTheCRUDToolBar())
//				_dCRUDToolBar._dLinkButtonSave.enabled = true;
//		}
//
//		public function canILockTheCRUDToolBar():Boolean
//		{
//			return ((_dCRUDToolBar) && (_dCRUDToolBar._crudMode != DCRUDToolBar._CRUD_MODE_SEARCH) && (_dCRUDToolBar._dLinkButtonSave));
//		}
//
//		public var _hierarchicalCodeField:String;
//	
//		private function populateHierarchicalCodeField():void
//		{
//			if (_entityDescriptor._fieldDescriptorHierarchicalCode)
//				_hierarchicalCodeField = _entityDescriptor._fieldDescriptorHierarchicalCode._javaField;
//		}
//		
//		public function syncDescriptorInputWithIDOnEagerMode(cleanWhenNotFind:Boolean=true):void
//		{
//			const theItem:Object = findByIDOnEagerMode((_codeTextInput.text));
//			
//			if (theItem)
//				_descriptionTextInput.selectedItems.addItemAt(theItem, 0);
//			else
//			{
//				if (cleanWhenNotFind)
//					clean();
//			}
//		}
//		
//		public function syncDescriptorInputWithIDOnLazyMode():void
//		{
//			const id:String = _codeTextInput.text;
//			
//			if (id)
//			{
//				try
//				{
//					//if (!isNaN(Number(id)))
//					//	onDTextInputIDFocusOut(null);
//					//					else
//					// TODO: If not searching for an ID, but for a code or a generic String.
//				}
//				catch (error:Error)
//				{
//					throw new Error("Erro ao converter uma String para um número. Contate o suporte técnico."); // TODO: Force this to verify if Number("a") (for example) really throws an error.
//				}
//			}
//			else
//				clean();
//		}
		
		// -------------------------------------------------------------------------
	}
}
