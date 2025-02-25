package br.com.dannemann.gui.component.addressing.brazil
{
	import flash.events.Event;
	
	import mx.events.ValidationResultEvent;
	
	import br.com.dannemann.gui.component.input.DTextInputMasked;
	import br.com.dannemann.gui.util.DUtilValidator;

	/**
	 * <p>Specialized text input for the Brazilian addressing code system (Brazilian ZIP code).</p>
	 * @see https://viacep.com.br
	 */
	public class DTextInputCep extends DTextInputMasked
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Fields:

		// Mask:
		public static const _CEP_MASK:String = "#####-###";
		
		private	var useCEPMask:Boolean;
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Constructors:
		
		public function DTextInputCep()
		{
			_useCEPMask = true;
			_validateCEPNumber = true;
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Overrides:
		
		// -------------------------------------------------------------------------
		// DTextInputMaskedTemplate overrides:
		
//		// TODO: DO I NEED THIS?
//		override public function set text(value:String):void
//		{
////			super.text = _lastSearchedCEP = value;
//			super.text = value;
//			validateNow();
//		}
		
		// -------------------------------------------------------------------------
		// DTextInputMasked overrides:
		
		// Clean:
		
		override public function clean():void
		{
			super.clean();
			
//			cleanMeAndDAddressInputsParent();
		}
		
		// Validation:
		
		override public function validateInput(value:Object=null):ValidationResultEvent
		{
//			const result:ValidationResultEvent = super.validateInput(value);
			
			//if (result.type == ValidationResultEvent.VALID)
//				searchInformedCEP();
			
			
//			const addressVo:AddressVo = new AddressVo();
////			addressDTO.cep = "38703-036";
//			addressVo.uf = "MG";
//			addressVo.localidade = "Patos De Minas";
//			addressVo.logradouro = "Maj";
//			
//			
//			findAddress(addressVo);
			
			return null;
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Component features:

		// -------------------------------------------------------------------------
		// CEP mask:

		// TODO: ABSTRACT THIS (_useCEPMask GET AND SET)?
		
		public function get _useCEPMask():Boolean
		{
			return useCEPMask;
		}

		public function set _useCEPMask(value:Boolean):void
		{
			if (value)
				inputMask = _CEP_MASK;
			else
				inputMask = ""; // TODO: TRY WITH NULL INSTEAD "".
		}

		// -------------------------------------------------------------------------
		// CEP search:
		

		
		// -------------------------------------------------------------------------
		// CEP validation:

		override public function enableValidators(value:Boolean):void
		{
			DUtilValidator.handleValidatorsEnabling(_selfValidator, value, this);
		}
		
		public function get _validateCEPNumber():Boolean
		{
//			if (_selfValidator)
//				return !isNaN(_selfValidator._validateExactLength);
//			else
				return false;
		}
		
		public function set _validateCEPNumber(validateCEPNumber:Boolean):void
		{
//			if (validateCEPNumber)
//			{
//				if (!_validator)
//					initializeValidator();
//
//				_validator._validateExactLength = 8;
//			}
//			else
//				if (_validator)
//					_validator._validateExactLength = NaN;
		}


		// -------------------------------------------------------------------------
	}
}
