package br.com.dannemann.gui.validator.brazil
{
	import mx.validators.ValidationResult;
	
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.validator.DValidator;

	public class DValidatorCpf extends DValidator
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Static:
		
		// Public:
		
		public static function validateCpf(cpf:String):Boolean
		{
			if (!cpf)
				return false;
			
			cpf = cpf
				.replace(".", "")
				.replace(".", "")
				.replace("-", "");
			
			if (cpf.length != 11)
				return false;
			
			if (isNaN(cpf as Number))
				return false;
			
			if (cpf == "00000000000" || cpf == "11111111111" ||
				cpf == "22222222222" || cpf == "33333333333" ||
				cpf == "44444444444" || cpf == "55555555555" ||
				cpf == "66666666666" || cpf == "77777777777" ||
				cpf == "88888888888" || cpf == "99999999999")
				return false;
			
			const a:Array = new Array(11);
			var b:int = 0;
			var c:int = 11;
			var x:int = 0;
			
			for (var i:int = 0; i < 11; i++)
			{
				a[i] = cpf.charAt(i);
				
				if (i < 9)
					b += (a[i] * --c);
			}
			
			if ((x = b % 11) < 2)
				a[9] = 0;
			else
				a[9] = 11 - x;
			
			b = 0;
			c = 11;
			
			for (i = 0; i < 10; i++)
				b += (a[i] * c--);
			
			if ((x = b % 11) < 2)
				a[10] = 0;
			else
				a[10] = 11 - x;
			
			if(cpf.charAt(9) != a[9] || cpf.charAt(10) != a[10])
				return false;
			
			return true;
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Instance:
		
		// -------------------------------------------------------------------------
		// Fields:
		
		public var _enableCpfValidation:Boolean = true;
		
		// -------------------------------------------------------------------------
		// Overrides/Implementations:
		
		// GlobalizationValidatorBase:
		
		override protected function doValidation(value:Object):Array
		{
			const validationResults:Array = super.doValidation(value);
			
			if (_enableCpfValidation && value) // We don't want to validate empty CPFs because super doValidation already did it (if required is true).
				if (!validateCpf(String(value))) // Validating.
					validationResults.push(new ValidationResult(true, null, null, StrConsts.getRMString(14)));
			
			return validationResults;
		}
		
		// -------------------------------------------------------------------------
	}
}
