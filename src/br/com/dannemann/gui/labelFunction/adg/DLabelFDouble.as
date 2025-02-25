package br.com.dannemann.gui.labelFunction.adg
{
	import br.com.dannemann.gui.custom.DCustomLabelFunctionADG;
	import br.com.dannemann.gui.formatter.DFormatterBrazilianDecimal;

	public final class DLabelFDouble extends DCustomLabelFunctionADG
	{
		private const _formatter:DFormatterBrazilianDecimal = new DFormatterBrazilianDecimal();

		override protected function valueSwitcher(value:String):String
		{
			if (value)
				return _formatter.format(value.replace(".", ","));
			else
				return "";
		}
	}
}
