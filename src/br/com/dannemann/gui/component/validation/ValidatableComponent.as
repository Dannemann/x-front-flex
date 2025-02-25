package br.com.dannemann.gui.component.validation
{
	import mx.events.ValidationResultEvent;

	/**
	 * <p>A self validatable component.</p>
	 */
	public interface ValidatableComponent
	{
		/**
		 * <p>Enables/Disables the current self validators attached to this component.</p>
		 * @param value <code>true</code> to enable all validations, otherwise <code>false</code>.
		 */
		function enableValidators(value:Boolean):void;

		/**
		 * <p>Validate this component's input.</p>
		 * <p>Note: We choose the name <code>validateInput</code> instead of just <code>validate</code> because we fell it more specific to what it does as Flex has
		 * other validation methods not related to the input itself like <code>validateDisplayList</code> and <code>validateNow</code>.</p>
		 * @param value Just a generic Value Object (VO) in case you use this method as an event handler or need external data while implementing this method.
		 */
		function validateInput(value:Object=null):ValidationResultEvent;
	}
}
