package br.com.dannemann.gui.validator.brazil
{
	import mx.validators.ValidationResult;
	
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.validator.DValidator;

	public class DValidatorCep extends DValidator
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Static:
		
		// Public:
		
		public static function validateCep(cep:String):Boolean
		{
			cep = cep.replace(/-/g, "");
			
			if (isNaN(Number(cep)))
				return false;
			else
				return cep.length == 8;
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Instance:
		
		// -------------------------------------------------------------------------
		// Fields:
		
		public var _enableCepValidation:Boolean = true;
		
		// -------------------------------------------------------------------------
		// Overrides/Implementations:
		
		// GlobalizationValidatorBase:
		
		override protected function doValidation(value:Object):Array
		{
			const validationResults:Array = super.doValidation(value);
			
			if (_enableCepValidation && value) // We don't want to validate empty CEPs because super doValidation already did it (if required is true).
				if (!validateCep(String(value))) // Validating.
					validationResults.push(new ValidationResult(true, null, null, StrConsts.getRMString(80)));
			
			return validationResults;
		}
		
		// -------------------------------------------------------------------------
	}
}
