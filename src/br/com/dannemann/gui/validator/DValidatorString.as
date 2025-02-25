package br.com.dannemann.gui.validator
{
	import mx.validators.ValidationResult;
	
	import br.com.dannemann.gui.domain.StrConsts;

	public class DValidatorString extends DValidator
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Fields:

		// Length related:
		
		/** The exact length that the validating string must have. */
		public var _exactLength:Number;
		
		/** The minimum length that the validating string must have. If <code>_exactLength</code> is also informed, this property is ignored. */
		private var minimumLength:Number;
		
		/** The maximum length that the validating string must have. If <code>_exactLength</code> is also informed, this property is ignored. */
		private var maximumLength:Number;

		// Control:
		
		public var _enableStringValidation:Boolean = true;
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Features:
		
		/**
		 * @copy #minimumLength
		 */

		public function get _minimumLength():Number
		{
			return minimumLength;
		}

		public function set _minimumLength(value:Number):void
		{
			if (value)
			{
				if (value < 1)
					throw new Error("STRING VALIDATOR - MINIMUM LENgth TEM QUE SER MAIOR QUE 0"); // TODO: WORK ON THIS;
				else if (_maximumLength && _maximumLength <= value)
					throw new Error("STRING VALIDATOR - MAXIMUM LENgth EH MENOR ou igual O MINIMO INFORMADO"); // TODO: WORK ON THIS;
				else
					minimumLength = value;
			}
			else
				minimumLength = NaN;
		}

		/**
		 * @copy #maximumLength
		 */

		public function get _maximumLength():Number
		{
			return maximumLength;
		}

		public function set _maximumLength(value:Number):void
		{
			if (value)
			{
				if (value < 1)
					throw new Error("STRING VALIDATOR - MAXIMUM LENgth TEM QUE SER MAIOR QUE 0"); // TODO: WORK ON THIS;
				else if (_minimumLength && _minimumLength >= value)
					throw new Error("STRING VALIDATOR - MINIMUM LENgth EH MAIOR ou igual O MAXIMO INFORMADO"); // TODO: WORK ON THIS;
				else
					maximumLength = value;
			}
			else
				maximumLength = NaN;
		}

		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Overrides/Implementations:
		
		// GlobalizationValidatorBase:

		override protected function doValidation(value:Object):Array
		{
			const validationResults:Array = super.doValidation(value);
			
			if (_enableStringValidation && value) // We don't want to validate empty strings because super doValidation already did it (if required is true).
				validationResults.concat(executeLengthValidations(value));
			
			return validationResults;
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Validation:
		
		protected function executeLengthValidations(value:Object):Array
		{
			const lengthErrsArr:Array = new Array(); // The array with all validation errors to be returned.
			const valStr:String = String(value);
			var errorStr:String;

			// If the length is exact we don't need further length validations.
			if (_exactLength)
			{
				if (!validateExactLength(valStr))
				{
					errorStr = StrConsts.getRMString(164) + " " + _exactLength + " " + resolveDigitWordPlural(_exactLength);
					lengthErrsArr.push(new ValidationResult(true, null, null, errorStr));
				}
			}
			else
			{
				// _minimumLength and _maximumLength are equal, we treat both as _exactLength property.
				if ((_minimumLength && _maximumLength) && (_minimumLength == _maximumLength))
				{
					if (!(valStr.length == _minimumLength)) // Validating exact length.
					{
						errorStr = StrConsts.getRMString(164) + " " + _minimumLength + " " + resolveDigitWordPlural(_minimumLength);
						lengthErrsArr.push(new ValidationResult(true, null, null, errorStr));
					}
				}
				else
				{
					if (_minimumLength)
					{
						if (!validateMinimumLength(valStr))
						{
							errorStr = StrConsts.getRMString(165) + " " + _minimumLength + " " + resolveDigitWordPlural(_minimumLength);
							lengthErrsArr.push(new ValidationResult(true, null, null, errorStr));
						}
					}
					
					if (_maximumLength)
					{
						if (!validateMaximumLength(valStr))
						{
							errorStr = StrConsts.getRMString(166) + " " + _maximumLength + " " + resolveDigitWordPlural(_maximumLength);
							lengthErrsArr.push(new ValidationResult(true, null, null, errorStr));
						}
					}
				}
			}
			
			return lengthErrsArr;
		}
		
		protected function validateExactLength(string:String):Boolean
		{
			return string.length == _exactLength;
		}
		
		protected function validateMinimumLength(string:String):Boolean
		{
			return string.length >= _minimumLength;
		}
		
		protected function validateMaximumLength(string:String):Boolean
		{
			return string.length <= _maximumLength;
		}
		
		// Protected:
		
		protected function resolveDigitWordPlural(length:Number):String
		{
			return length == 1 ? StrConsts.getRMString(128) : StrConsts.getRMString(127); // ? "digit" : "digits";
		}
		
		// -------------------------------------------------------------------------
		
		// Original implementation using a description field.
//		public function executeLengthValidations():String
//		{
//			const withDescInitialStr:String = required ? StrConsts.getRMString(125) : StrConsts.getRMString(130) + ", " + StrConsts.getRMString(125).toLowerCase(); // ? "The field" : "If informed, the field";
//			const noDescInitialStr:String = required ? StrConsts.getRMString(129) : StrConsts.getRMString(130) + ", " + StrConsts.getRMString(129).toLowerCase(); // ? "This field" : "If informed, this field";
//			const digitWordPlural:String = _exactLength == 1 ? StrConsts.getRMString(128) : StrConsts.getRMString(127); // ? "digit" : "digits";
//			
//			return _description ?
//				withDescInitialStr + " \"" + _description + "\" " + StrConsts.getRMString(126) + " " + _exactLength + " " + digitWordPlural :
//				noDescInitialStr + " " + StrConsts.getRMString(126) + " " + _exactLength + " " + digitWordPlural;
//		}
	}
}
