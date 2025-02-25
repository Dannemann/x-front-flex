package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;

	import spark.components.Label;

	public final class DLabel extends Label implements DComponent
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		public var _useColon:Boolean;
		public var _useChar:String;

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Constructor:

		public function DLabel(text:String=StrConsts._CHAR_EMPTY_STRING, useColon:Boolean=false, useChar:String=StrConsts._CHAR_EMPTY_STRING)
		{
			this.text = text;
			_useColon = useColon;
			_useChar = useChar;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		//----------------------------------------------------------------------
		// Class Overrides:

		override protected function createChildren():void
		{
			super.createChildren();

			if (_useColon)
				text += StrConsts._CHAR_COLON;
			else if (_useChar)
				text += _useChar;
		}

		//----------------------------------------------------------------------
	}
}
