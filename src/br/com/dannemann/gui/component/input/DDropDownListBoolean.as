package br.com.dannemann.gui.component.input
{
	import mx.collections.ArrayList;
	
	import spark.events.IndexChangeEvent;
	
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.util.DUtilBoolean;
	import br.com.dannemann.gui.validator.DValidatorString;

	public final class DDropDownListBoolean extends DDropDownList
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		// Overrides:

		override public function set selectedItem(value:*):void
		{
			if (value)
			{
				if (DUtilBoolean.isTrue(value))
					super.selectedItem = StrConsts.getRMString(71);
				else if (DUtilBoolean.isFalse(value))
					super.selectedItem = StrConsts.getRMString(72);
				else
					super.selectedIndex = -1;
			}
			else
				super.selectedIndex = -1;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Constructor:

		public function DDropDownListBoolean()
		{
			dataProvider = new ArrayList([ StrConsts.getRMString(71), StrConsts.getRMString(72) ]);
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		//----------------------------------------------------------------------
		// DIGUIInput implementation:

		override public function get text():String
		{
			if (DUtilBoolean.isTrue(selectedItem))
				return "true";
			else if (DUtilBoolean.isFalse(selectedItem))
				return "false";
			else
				return null;
		}

		override public function dispose():void
		{
			super.dispose();

			if (hasEventListener(IndexChangeEvent.CHANGE))
				removeEventListener(IndexChangeEvent.CHANGE, validateInput);
		}

		//----------------------------------------------------------------------
		// ValidatableComponent implementation:

		public function initializeValidator():void
		{
			_selfValidator = new DValidatorString();
			_selfValidator.enabled = false;
			_selfValidator.property = "selectedItem";
			_selfValidator.source = this;

			addEventListener(IndexChangeEvent.CHANGE, validateInput, false, 0, true);
		}

		//----------------------------------------------------------------------
	}
}
