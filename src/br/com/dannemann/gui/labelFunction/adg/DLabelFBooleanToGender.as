package br.com.dannemann.gui.labelFunction.adg
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.custom.DCustomLabelFunctionADG;

	public final class DLabelFBooleanToGender extends DCustomLabelFunctionADG
	{
		public const _false:String = StrConsts._FLEX_STYLE_VALUE_FALSE;
		public const _true:String = StrConsts._FLEX_STYLE_VALUE_TRUE;

		public const _F:String = StrConsts._CHAR_F;
		public const _M:String = StrConsts._CHAR_M;

		override protected function valueSwitcher(value:String):String
		{
			switch (value)
			{
				case _false:
					return _F;
				case _true:
					return _M;
				case null:
					return "";
				default:
					return value;
			}
		}
	}
}
