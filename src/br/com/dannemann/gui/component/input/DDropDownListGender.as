package br.com.dannemann.gui.component.input
{
	import mx.collections.ArrayList;
	
	import spark.events.IndexChangeEvent;
	
	import br.com.dannemann.gui.util.DUtilGender;
	import br.com.dannemann.gui.validator.DValidatorString;

	public final class DDropDownListGender extends DDropDownList
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:
		
		public const _M:String = DUtilGender._M.toUpperCase();
		public const _F:String = DUtilGender._F.toUpperCase();

		// Overrides:

		override public function set selectedItem(value:*):void
		{
			if (value)
			{
				if (DUtilGender.isMale(value))
					super.selectedItem = _M;
				else if (DUtilGender.isFemale(value))
					super.selectedItem = _F;
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

		public function DDropDownListGender()
		{
			dataProvider = new ArrayList([ _M, _F ]);
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		//----------------------------------------------------------------------
		// DIGUIInput implementation:

		override public function get text():String
		{
			if (DUtilGender.isMale(selectedItem))
				return "true";
			else if (DUtilGender.isFemale(selectedItem))
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
