package br.com.dannemann.gui.formatter
{
	import mx.formatters.NumberFormatter;

	public final class DFormatterDouble extends NumberFormatter
	{
		public function DFormatterDouble(precision:int=2)
		{
			this.precision = precision;
		}
	}
}
