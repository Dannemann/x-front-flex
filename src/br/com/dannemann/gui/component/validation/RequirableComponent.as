package br.com.dannemann.gui.component.validation
{
	public interface RequirableComponent extends ValidatableComponent
	{
		/**
		 * <p>Whether this component is required to return a non-emtpty value or not.</p>
		 */
		function get _required():Boolean;
		function set _required(value:Boolean):void;
	}
}
