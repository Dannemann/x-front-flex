package br.com.dannemann.gui.validator.brazil
{
	import mx.validators.ValidationResult;
	
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.validator.DValidator;
	
	public class DValidatorPhoneNumber extends DValidator
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Static:
		
		// Public:
		
		public static function validatePhoneNumber(phoneNumber:String):Boolean
		{
			phoneNumber = phoneNumber
				.replace(/\+/g, "")
				.replace(/\(/g, "")
				.replace(/\)/g, "")
				.replace(/ /g, "")
				.replace(/-/g, "");
			
			return !isNaN(Number(phoneNumber));
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Instance:
		
		// -------------------------------------------------------------------------
		// Fields:
		
		public var _enablePhoneNumberValidation:Boolean = true;
		
		// -------------------------------------------------------------------------
		// Overrides/Implementations:
		
		// GlobalizationValidatorBase:
		
		override protected function doValidation(value:Object):Array
		{
			const validationResults:Array = super.doValidation(value);
			
			if (_enablePhoneNumberValidation && value) // We don't want to validate empty phone numbers because super doValidation already did it (if required is true).
				if (!validatePhoneNumber(String(value))) // Validating.
					validationResults.push(new ValidationResult(true, null, null, StrConsts.getRMString(161)));
			
			return validationResults;
		}
		
		// -------------------------------------------------------------------------
	}
}
