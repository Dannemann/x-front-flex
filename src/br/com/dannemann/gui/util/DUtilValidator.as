package br.com.dannemann.gui.util
{
	import mx.core.UIComponent;
	import mx.events.ValidationResultEvent;
	import mx.validators.IValidator;
	
	import br.com.dannemann.gui.component.validation.ValidatableComponent;

	public final class DUtilValidator
	{
		/**
		 * <p>This method encapsulates the default D framework's behavior for when enabling/disabling validators.</p>
		 */
		public static function handleValidatorsEnabling(validator:IValidator, isValidatorEnabled:Boolean, component:ValidatableComponent):void
		{
			if (validator)
				validator.enabled = isValidatorEnabled;
			
			if (isValidatorEnabled)
				component.validateInput();
			else
			{
				const uiComponent:UIComponent = component as UIComponent; // Must NEVER be null.
				uiComponent.errorString = "";
				
				DUtilFocus.updateFocusRetangle(uiComponent);
			}
		}
		
		/**
		 * @param ...results The <code>ValidationResultEvent</code>s to merge.
		 */
		public static function mergeValidationResults(...results:*):ValidationResultEvent
		{
			const finalVre:ValidationResultEvent = new ValidationResultEvent(ValidationResultEvent.INVALID, false, false, null, []);
			
			const resultsLength:uint = results.length;
			for (var i:uint = 0; i < resultsLength; i++)
			{
				const vreObj:Object = results[i];
				
				if (vreObj)
				{
					const vre:ValidationResultEvent = vreObj as ValidationResultEvent;
					
					if (vre.type == ValidationResultEvent.INVALID)
						finalVre.results.concat(vre.results);
				}
			}
			
			if (finalVre.results.length > 0)
				return finalVre;
			else
				return new ValidationResultEvent(ValidationResultEvent.VALID);
		}
	}
}
