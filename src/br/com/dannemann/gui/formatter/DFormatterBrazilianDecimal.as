package br.com.dannemann.gui.formatter
{
	import mx.formatters.NumberFormatter;

	public final class DFormatterBrazilianDecimal extends NumberFormatter
	{
		public function DFormatterBrazilianDecimal(precision:int=2)
		{
			thousandsSeparatorTo = ".";
			decimalSeparatorTo = ",";
			this.precision = precision;
		}

		// TODO: Can be an user configuration.
//		override public function format(value:Object):String
//		{
//			return super.format(value).replace(",00", "");
//		}
	}
}
