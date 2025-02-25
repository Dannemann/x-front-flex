package br.com.dannemann.gui.component.input
{
	import flash.events.Event;
	
	import mx.events.ValidationResultEvent;
	
	import spark.components.TextInput;
	
	import br.com.dannemann.gui.component.validation.RequirableComponent;
	import br.com.dannemann.gui.util.DUtilFocus;
	import br.com.dannemann.gui.util.DUtilValidator;
	import br.com.dannemann.gui.validator.DValidatorString;

	public class DTextInput extends TextInput implements DInput, RequirableComponent
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Fields:

		// -------------------------------------------------------------------------
		// Features:
		
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
		// Overrides/Implementations:
		
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
		
		// TODO: IMPLEMENT THIS FEATURE IN THE FUTURE.
		
//		public var _javaTypeChangeMaxChars:Boolean = true;
//		
//		protected var javaType:String;
//		public function get _javaType():String
//		{
//			return javaType;
//		}
//		public function set _javaType(value:String):void
//		{
//			javaType = value;
//			
//			if (DUtilJava.isIntegerType(javaType))
//			{
//				restrict = StrConsts._REGEXP_RESTRICT_INTEGER;
//				
//				if (_javaTypeChangeMaxChars)
//				{
//					if (DUtilJava.isJavaLangShort(javaType))
//						callLater(function ():void { maxChars = 5; });
//					else if (DUtilJava.isJavaLangInteger(javaType))
//						callLater(function ():void { maxChars = 10; });
//					else if (DUtilJava.isJavaLangLong(javaType))
//						callLater(function ():void { maxChars = 19; });
//				}
//			}
//			else if (DUtilJava.isFloatingPointType(javaType))
//			{
//				restrict = StrConsts._REGEXP_RESTRICT_DECIMAL;
//				
//				if (_javaTypeChangeMaxChars)
//					callLater(function ():void { maxChars = 25; });
//			}
//			else
//				restrict = null;
//		}
//		
//		override public function get text():String
//		{
//			if (DUtilJava.isFloatingPointType(javaType))
//			{
//				const returnStr:String = DUtilString.replaceAll(super.text, ".", "");
//				return returnStr.replace(",", ".");
//			}
//			else
//				return super.text;
//		}
//		
//		override public function set text(value:String):void
//		{
//			if (DUtilJava.isFloatingPointType(javaType))
//				super.text = (new DFormatterBrazilianDecimal()).format(value.replace(".", ","));
//			else
//				super.text = value;
//		}
	}
}
