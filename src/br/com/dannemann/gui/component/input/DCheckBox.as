package br.com.dannemann.gui.component.input
{

	import spark.components.CheckBox;

	public final class DCheckBox extends CheckBox implements DInput
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		public var _defaultValue:Object;
		public var _description:String;

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		//----------------------------------------------------------------------
		// Class Overrides:

		override protected function createChildren():void
		{
			super.createChildren();

			clean();
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// DIGUIInput implementation:

		public function get text():String
		{
			return selected.toString();
		}

		public function set text(value:String):void
		{
			if ((value == "true") || (value == "1") || (value == "on"))
				selected = true;
			else if ((value == "false") || (value == "0") || (value == "off"))
				selected = false;
		}

		public function clean():void
		{
			if (_defaultValue)
			{
				if (_defaultValue is Boolean)
					selected = _defaultValue;
				else if (_defaultValue is String)
					text = _defaultValue.toString();
				else
					selected = false;
			}
			else
				selected = false;
		}

		public function dispose():void
		{
		}

		//----------------------------------------------------------------------
	}
}
