package br.com.dannemann.gui.labelFunction.adg
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.custom.DCustomLabelFunctionADG;
	
	import mx.collections.GroupingField;

	public final class DLabelFBooleanToYesNo extends DCustomLabelFunctionADG
	{
		public const _false:String = StrConsts._FLEX_STYLE_VALUE_FALSE;
		public const _true:String = StrConsts._FLEX_STYLE_VALUE_TRUE;

		public const _nao:String = StrConsts.getRMString(72);
		public const _sim:String = StrConsts.getRMString(71);

		public const _bracketOpen:String = " (";
		public const _bracketClose:String = ")";

		override public function myGroupingFunction(item:Object, column:GroupingField):String
		{
			return valueSwitcher(item[column.name]) + _bracketOpen + _fieldNameFormatted + _bracketClose
		}

		override protected function valueSwitcher(value:String):String
		{
			switch (value)
			{
				case _false:
					return _nao;
				case _true:
					return _sim;
				case null:
					return "";
				default:
					return value;
			}
		}
	}
}
