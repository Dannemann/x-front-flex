package br.com.dannemann.gui.validator
{
	import spark.validators.supportClasses.GlobalizationValidatorBase;

	/**
	 * <p>Base class for all D framework's validators.</p>
	 */
	public class DValidator extends GlobalizationValidatorBase
	{
		public function DValidator()
		{
			required = false;
		}
	}
}
