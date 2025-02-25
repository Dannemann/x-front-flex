package br.com.dannemann.gui.validator
{
	import mx.collections.ArrayList;
	import mx.core.UIComponent;
	import mx.events.ValidationResultEvent;
	import mx.validators.Validator;
	
	import br.com.dannemann.gui.component.input.DInput;
	import br.com.dannemann.gui.component.DNotificator;
	import br.com.dannemann.gui.component.validation.DomainValidatableComponent;
	import br.com.dannemann.gui.component.validation.ValidatableComponent;
	import br.com.dannemann.gui.domain.StrConsts;

	public final class DValidatorManager
	{
		//----------------------------------------------------------------------
		// Fields:

		public var _componentsToValidate:ArrayList = new ArrayList();
		public var _requiredComponentsToValidate:ArrayList = new ArrayList();

		//----------------------------------------------------------------------
		// Public interface:

		public function doValidation(showNotification:Boolean=true, setFocusOnInvalidComponent:Boolean=true, customValidator:Validator=null):Boolean
		{
			if (_componentsToValidate)
			{
				const componentsToValidateLength:int = _componentsToValidate.length;

				if (componentsToValidateLength > 0)
				{
					var validationErrorFound:Boolean = false;
					var validatableComponentInstance:ValidatableComponent = null;
					var validatableComponentInstanceObj:Object = null;
					var validationResultEvent:ValidationResultEvent;
					var compAsUIComponent:UIComponent;

					for (var i:int = 0; i < componentsToValidateLength; i++)
					{
						validatableComponentInstance = _componentsToValidate.getItemAt(i) as ValidatableComponent;
						validatableComponentInstanceObj = validatableComponentInstance as Object;

						if (validatableComponentInstance)
						{
							validationResultEvent = validatableComponentInstance.validateInput();

							if (validatableComponentInstanceObj.hasOwnProperty("_defaultValue") && validatableComponentInstanceObj._defaultValue) // TODO: _defaultValue must be in DIGUIInput interface.
								continue;
//							else if (validationResultEvent.results && validationResultEvent.results.length > 0 && validationResultEvent.message && !validationErrorFound)
							else if (validationResultEvent && validationResultEvent.results && validationResultEvent.results.length > 0 && validationResultEvent.message && !validationErrorFound)
							{
								compAsUIComponent = validatableComponentInstance as UIComponent;

								if (showNotification)
									DNotificator.showError2(validationResultEvent.message, compAsUIComponent.focusManager);

								if (setFocusOnInvalidComponent)
									if (compAsUIComponent.enabled)
									{
										if (validatableComponentInstance is DInput)
											(validatableComponentInstance as DInput).setFocus();
										else
											compAsUIComponent.setFocus();

										// TODO: Need this?
//										if (_focusManager)
//											_focusManager.mx_internal::lastFocus = validatableComponentInstance as IFocusManagerComponent;
									}

								validationErrorFound = true;
							}
						}
					}

					if (validationErrorFound)
						return false;

					return true;
				}
				else
					return true;
			}
			else
				return true;
		}

		public function addComponentToValidation(component:ValidatableComponent):DValidatorManager
		{
//			if (component is RequirableComponent)
//				_requiredComponentsToValidate.addItem(component);
				
			_componentsToValidate.addItem(component);

			return this;
		}

		public function addComponentsToValidation(components:Array):DValidatorManager
		{
			const componentsLength:int = components.length;
			var dIValidatableComponent:DomainValidatableComponent;
			for (var i:int = 0; i < componentsLength; i++)
			{
				dIValidatableComponent = components[i];
				_componentsToValidate.addItem(dIValidatableComponent);

				if (dIValidatableComponent._selfValidate)
					_requiredComponentsToValidate.addItem(dIValidatableComponent);
			}

			return this;
		}

		public function removeComponentToValidation(component:DomainValidatableComponent):void
		{
			_componentsToValidate.removeItem(component);
		}

		public function clean():void
		{
			_componentsToValidate = new ArrayList();
		}

		public function toggleRequiredValidationsEnabled(enabled:Boolean):void
		{
			const componentsToValidateLength:int = _componentsToValidate.length;
			for (var i:int = 0; i < componentsToValidateLength; i++)
				(_componentsToValidate.getItemAt(i) as ValidatableComponent).enableValidators(enabled);
		}
		
		public function cleanErrorStrings():void
		{
			const requiredComponentsToValidateLength:int = _requiredComponentsToValidate.length;
			for (var i:int = 0; i < requiredComponentsToValidateLength; i++)
			{
				(_requiredComponentsToValidate.getItemAt(i) as UIComponent).errorString = StrConsts._CHAR_EMPTY_STRING;
			}
		}

		//----------------------------------------------------------------------
	}
}
