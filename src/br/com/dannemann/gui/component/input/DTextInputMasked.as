package br.com.dannemann.gui.component.input
{
	import flash.events.Event;
	
	import mx.events.ValidationResultEvent;
	
	import br.com.dannemann.gui.component.validation.RequirableComponent;
	import br.com.dannemann.gui.domain.component.input.DTextInputMaskedBase;
	import br.com.dannemann.gui.util.DUtilFocus;
	import br.com.dannemann.gui.util.DUtilValidator;
	import br.com.dannemann.gui.validator.DValidator;
	import br.com.dannemann.gui.validator.DValidatorString;

	public class DTextInputMasked extends DTextInputMaskedBase implements DInput, RequirableComponent
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Fields:

		// -------------------------------------------------------------------------
		// Features:
		
		// Just an undescored access to inputMask property.
		public function get _inputMask():String { return inputMask; }
		public function set _inputMask(value:String):void { inputMask = value; }
		
		protected var requiredChanged:Boolean;
		
		// -------------------------------------------------------------------------
		// Components:
		
		public var _selfValidator:DValidator;
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Overrides/Implementations:
		
		// UIComponent:
		
		override protected function commitProperties():void
		{
			if (requiredChanged)
			{
				configureValidator();

				requiredChanged = false;
			}
			
			super.commitProperties();
		}
		
		// DInput:
		
		public function clean():void
		{
			text = "";
		}
		
		public function dispose():void
		{
			removeEventListener(Event.CHANGE, validateInput);
		}
		
		// ITextInput:
		
		override public function set editable(value:Boolean):void
		{
			super.editable = value;
			super.enabled = value;
		}
		
		// IUIComponent:
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			super.editable = value;
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Validation:
		
		// -------------------------------------------------------------------------
		// Overrides/Implementations:
		
		// DTextInputMaskedTemplate:
		
		override public function set required(value:Boolean):void
		{
			requiredChanged = required != value;
			super.required = value;
			
			if (requiredChanged)
				invalidateProperties();
		}
		
		// RequirableComponent:
		
		public function get _required():Boolean
		{
			return required;
		}
		
		public function set _required(value:Boolean):void
		{
			required = value;
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
