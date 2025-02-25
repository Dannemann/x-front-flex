package br.com.dannemann.gui.component.validation
{
	/**
	 * <p>A self validatable component that doesn't need external validators to validate it's data according to the business.
	 * Examples of candidates for implementing this interface are inputs like e-mail, ZIP code and etc.</p>
	 */
	public interface DomainValidatableComponent extends ValidatableComponent
	{
		/**
		 * <p>Enable/Disable business self validation in this component.</p>
		 */
		function get _selfValidate():Boolean;
		function set _selfValidate(value:Boolean):void;
	}
}
