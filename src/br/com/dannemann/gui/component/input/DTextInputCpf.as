package br.com.dannemann.gui.component.input
{
	import br.com.dannemann.gui.component.validation.DomainValidatableComponent;
	import br.com.dannemann.gui.validator.brazil.DValidatorCpf;

	public class DTextInputCpf extends DTextInputMasked implements DomainValidatableComponent
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Fields:
		
		public static const _CPF_MASK:String = "###.###.###-##";
		
		private var selfValidate:Boolean;
		protected var selfValidateChanged:Boolean;
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Component creation:
		
		// Constructor:
		
		public function DTextInputCpf()
		{
			_cpfMaskEnabled = true;
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
		
		public function get _cpfMaskEnabled():Boolean
		{
			return inputMask == _CPF_MASK;
		}
		
		public function set _cpfMaskEnabled(value:Boolean):void
		{
			inputMask = value ? _CPF_MASK : "";
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
			_selfValidator = new DValidatorCpf();
		}
		
		override protected function setValidatorProperties():void
		{
			super.setValidatorProperties();
			
			if (_selfValidator)
				(_selfValidator as DValidatorCpf)._enableCpfValidation = _selfValidate;
		}
		
		// -------------------------------------------------------------------------
	}
}
