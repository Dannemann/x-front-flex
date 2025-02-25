package br.com.dannemann.gui.component.input
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.events.ValidationResultEvent;
	
	import spark.components.DropDownList;
	
	import br.com.dannemann.gui.component.DNotificator;
	import br.com.dannemann.gui.component.validation.RequirableComponent;
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.util.DUtilFocus;
	import br.com.dannemann.gui.util.DUtilValidator;
	import br.com.dannemann.gui.validator.DValidatorString;

	public class DDropDownList extends DropDownList implements DInput, RequirableComponent
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Fields:
		
		// -------------------------------------------------------------------------
		// Features:
		
		/**
		 * <p>The name of the field in the data provider items to return by this component.</p>
		 */
		public var _dataField:String;
		
		/**
		 * <p>Sets a "Loading..." (already internationalized) message as the initial selected item of this component. 
		 * This is useful for the user to know that this drop down is still fetching it's data provider from the server.</p>
		 */
		public var _useLoadingOnInit:Boolean;
		
		/**
		 * <p>Whether this component uses "Select:" (already internationalized) as prompt.</p> 
		 */
		private var useSelectAsPrompt:Boolean = true;
		
		private var required:Boolean;
		protected var requiredChanged:Boolean;
		
		// -------------------------------------------------------------------------
		// Component:
		
		public var _selfValidator:DValidatorString;
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Component creation:
		
		// -------------------------------------------------------------------------
		// UIComponent:
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (_useLoadingOnInit)
				dataProvider = new ArrayList([ StrConsts.getRMString(9) + "..." ]);
			
			if (_useSelectAsPrompt)
				setSelectAsPrompt();
		}
		
		override protected function commitProperties():void
		{
			if (requiredChanged)
			{
				configureValidator();
				
				requiredChanged = false;
			}
			
			super.commitProperties();
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Features:
		
		/**
		 * @copy #useSelectAsPrompt
		 */
		
		public function get _useSelectAsPrompt():Boolean
		{
			return useSelectAsPrompt;
		}
		
		public function set _useSelectAsPrompt(value:Boolean):void
		{
			useSelectAsPrompt = value;
			
			if (useSelectAsPrompt)
				setSelectAsPrompt();
			else
				prompt = "";
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Public:
		
		public function setSelectAsPrompt():void
		{
			prompt = StrConsts.getRMString(10) + ":";
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Overrides/Implementations:
		
		// -------------------------------------------------------------------------
		// DInput:
		
		public function get text():String
		{
			if (selectedItem)
			{
				if (selectedItem is String)
					return selectedItem;
				else if (_dataField)
					return selectedItem[_dataField];
				else if (labelField)
					return selectedItem[labelField];
			}
			
			return selectedItem;
		}
		
		public function set text(value:String):void
		{
			if (value)
			{
				if (dataProvider)
				{
					const dataProviderLength:int = dataProvider.length;
					
					if (dataProviderLength > 0)
					{
						var item:Object = dataProvider.getItemAt(0);
						
						if (item is String)
							selectedItem = value;
						else
						{
							const dpLabelField:String = _dataField ? _dataField : (labelField ? labelField : "label");
							item = null;
							
							for (var i:int = 0; i < dataProviderLength; i++)
							{
								item = dataProvider.getItemAt(i);
								
								if (item)
								{
									if (item[dpLabelField] == value)
									{
										selectedItem = item;
										return;
									}
								}
								else
									DNotificator.show("DROPDOWNLIST NULL OPTION"); // TODO: WORK ON THIS.
								
								// TODO: LOG UNSUCCESSFUL ATTEMPTS.
							}
							
							clean();
						}
					}
				}
			}
			else
				selectedItem = null;
		}
		
		public function clean():void
		{
			selectedIndex = -1;
		}
		
		public function dispose():void
		{
			removeEventListener(Event.CHANGE, validateInput);
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Validation:
		
		// -------------------------------------------------------------------------
		// Overrides/Implementations:
		
		// RequirableComponent:
		
		public function get _required():Boolean
		{
			return required;
		}
		
		public function set _required(value:Boolean):void
		{
			requiredChanged = required != value;
			required = value;
			
			if (requiredChanged)
				invalidateProperties();
		}
		
		// ValidatableComponent:
		
		public function enableValidators(value:Boolean):void
		{
			DUtilValidator.handleValidatorsEnabling(_selfValidator, value, this);
		}
		
		public function validateInput(value:Object=null):ValidationResultEvent
		{
			if (_selfValidator)
				return _selfValidator.validate(text);
			else
				return new ValidationResultEvent(ValidationResultEvent.VALID);
		}
		
		// IValidatorListener:
		
		override public function validationResultHandler(event:ValidationResultEvent):void
		{
			super.validationResultHandler(event);
			
			DUtilFocus.updateFocusRetangle(this);
		}
		
		// -------------------------------------------------------------------------
		// Protected:
		
		protected function configureValidator():void
		{
			if (needValidation() && !_selfValidator)
			{
				createValidator();
				setValidatorDefaults();
			}
			
			setValidatorProperties();
			validateInput();
		}
		
		protected function needValidation():Boolean
		{
			return _required;
		}
		
		protected function createValidator():void
		{
			_selfValidator = new DValidatorString();
		}
		
		protected function setValidatorDefaults():void
		{
			_selfValidator.property = "text";
			_selfValidator.source = this;
			
			addEventListener(Event.CHANGE, validateInput, false, 0, true);
		}
		
		protected function setValidatorProperties():void
		{
			if (_selfValidator)
				_selfValidator.required = _required;
		}
		
		// -------------------------------------------------------------------------
	}
}
