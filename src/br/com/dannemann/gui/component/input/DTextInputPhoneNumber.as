package br.com.dannemann.gui.component.input
{
	import br.com.dannemann.gui.component.validation.DomainValidatableComponent;
	import br.com.dannemann.gui.validator.brazil.DValidatorPhoneNumber;
	
	public class DTextInputPhoneNumber extends DTextInputMasked implements DomainValidatableComponent
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Fields:
		
		public static const _PHONE_NUMBER_MASK:String = "## ####-####";
		
		private var selfValidate:Boolean;
		protected var selfValidateChanged:Boolean;
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Component creation:
		
		// Constructor:
		
		public function DTextInputPhoneNumber()
		{
			_phoneMaskEnabled = true;
			_selfValidate = true;
		}
		
		// UIComponent:
		
		override protected function commitProperties():void
		{
			if (requiredChanged || selfValidateChanged)
			{
				configureValidator();
				
				requiredChanged = false;
				selfValidateChanged = false;
			}
			
			super.commitProperties();
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Features:
		
		/**
		 * @defaultValue true 
		 */
		
		public function get _phoneMaskEnabled():Boolean
		{
			return inputMask == _PHONE_NUMBER_MASK;
		}
		
		public function set _phoneMaskEnabled(value:Boolean):void
		{
			inputMask = value ? _PHONE_NUMBER_MASK : "";
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Validation:
		
		// DomainValidatableComponent:
		
		/**
		 * @defaultValue true 
		 */
		
		public function get _selfValidate():Boolean
		{
			return selfValidate;
		}
		
		public function set _selfValidate(value:Boolean):void
		{
			selfValidateChanged = selfValidate != value;
			selfValidate = value;
			
			if (selfValidateChanged)
				invalidateProperties();
		}
		
		// Protected:
		
		override protected function needValidation():Boolean
		{
			return super.needValidation() || _selfValidate;
		}
		
		override protected function createValidator():void
		{
			_selfValidator = new DValidatorPhoneNumber();
		}
		
		override protected function setValidatorProperties():void
		{
			super.setValidatorProperties();
			
			if (_selfValidator)
				(_selfValidator as DValidatorPhoneNumber)._enablePhoneNumberValidation = _selfValidate;
		}
		
		// -------------------------------------------------------------------------
	}
}
