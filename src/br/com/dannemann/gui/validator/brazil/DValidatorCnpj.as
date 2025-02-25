package br.com.dannemann.gui.validator.brazil
{
	import mx.validators.ValidationResult;
	
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.validator.DValidator;

	public class DValidatorCnpj extends DValidator
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Static:
		
		// Public:
		
		public static function validateCnpj(cnpj:String):Boolean
		{
			if (!cnpj)
				return false;
			
			cnpj = cnpj
				.replace(".", "")
				.replace(".", "")
				.replace("/", "")
				.replace("-", "");
			
			if(cnpj.length != 14)
				return false;
			
			if(isNaN(cnpj as Number))
				return false;
			
			const a:Array = new Array(14);
			var b:int;
			var c:Array = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
			var x:int;
			
			for (var i:int = 0; i < 12; i++)
			{
				a[i] = cnpj.charAt(i);
				b += a[i] * c[i + 1];
			}
			
			if ((x = b % 11) < 2)
				a[12] = 0;
			else
				a[12] = 11 - x;
			
			b = 0;
			
			for (i = 0; i < 13; i++)
				b += (a[i] * c[i]);
			
			if ((x = b % 11) < 2)
				a[13] = 0;
			else
				a[13] = 11 - x;
			
			if (cnpj.charAt(12) != a[12] || cnpj.charAt(13) != a[13])
				return false;
			
			return true;
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Instance:
		
		// -------------------------------------------------------------------------
		// Fields:
		
		public var _enableCnpjValidation:Boolean = true;
		
		// -------------------------------------------------------------------------
		// Overrides/Implementations:

		// GlobalizationValidatorBase:

		override protected function doValidation(value:Object):Array
		{
			const validationResults:Array = super.doValidation(value);

			if (_enableCnpjValidation && value) // We don't want to validate empty CNPJs because super doValidation already did it (if required is true).
				if (!validateCnpj(String(value))) // Validating.
					validationResults.push(new ValidationResult(true, null, null, StrConsts.getRMString(21)));

			return validationResults;
		}

		// -------------------------------------------------------------------------
	}
}
