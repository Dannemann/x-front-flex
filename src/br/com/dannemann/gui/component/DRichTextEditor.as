package br.com.dannemann.gui.component
{
	import flash.events.FocusEvent;
	
	import mx.controls.RichTextEditor;
	import mx.events.ValidationResultEvent;
	
	import br.com.dannemann.gui.component.input.DInput;
	import br.com.dannemann.gui.component.validation.RequirableComponent;
	import br.com.dannemann.gui.util.DUtilValidator;
	import br.com.dannemann.gui.validator.DValidatorString;

	public final class DRichTextEditor extends RichTextEditor implements DInput, RequirableComponent
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		protected var defaultValue:Object;
		public function get _defaultValue():Object
		{
			return defaultValue;
		}
		public function set _defaultValue(value:Object):void
		{
			defaultValue = value;

			if (defaultValue)
				setStyle("errorColor", _errorColorCode);
			else
				setStyle("errorColor", "0xFF0000");
		}

		protected var description:String;
		public function get _description():String
		{
			return description;
		}
		public function set _description(value:String):void
		{
			description = value;

		}

		public var _validator:DValidatorString;

		protected const _errorColorCode:String = "0xFF00FF";

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		//----------------------------------------------------------------------
		// DIGUIInput implementation:

		// TODO: What if I need "super.text" property? With this, I'm stucked on "htmlText".
		override public function get text():String
		{
			return htmlText;
		}

		// TODO: What if I need "super.text" property? With this, I'm stucked on "htmlText".
		override public function set text(value:String):void
		{
			htmlText = value;
		}

		public function clean():void
		{
			htmlText = "";
		}

		public function dispose():void
		{
			if (hasEventListener(FocusEvent.FOCUS_OUT))
				removeEventListener(FocusEvent.FOCUS_OUT, validateInput);
		}

		//----------------------------------------------------------------------
		// ValidatableComponent implementation:

		public function get _required():Boolean
		{
			if (!_validator)
				return false;
			else
				return _validator.required;
		}

		public function set _required(required:Boolean):void
		{
			if (required)
			{
				if (!_validator)
					initializeValidator();

				_validator.required = true;
			}
			else
				if (_validator)
					_validator.required = false;
		}

		public function initializeValidator():void
		{
			_validator = new DValidatorString();
			_validator.enabled = false;
			_validator.property = "text";
			_validator.source = this;

			addEventListener(FocusEvent.FOCUS_OUT, validateInput, false, 0, true);
		}

		public function enableValidators(value:Boolean):void
		{
			DUtilValidator.handleValidatorsEnabling(_validator, value, this);
		}
		
		public function validateInput(value:Object=null):ValidationResultEvent
		{
			if (_validator)
			{
				_validator.enabled = true;
				const result:ValidationResultEvent = _validator.validate();
				_validator.enabled = false;

				return result;
			}
			else
				return new ValidationResultEvent(ValidationResultEvent.VALID);
		}

		//----------------------------------------------------------------------
	}
}
