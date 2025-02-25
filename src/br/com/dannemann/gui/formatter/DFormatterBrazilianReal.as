package br.com.dannemann.gui.formatter
{
	import mx.formatters.CurrencyFormatter;

	public final class DFormatterBrazilianReal extends CurrencyFormatter
	{
		public function DFormatterBrazilianReal()
		{
			currencySymbol = "R$ ";
			thousandsSeparatorTo = ".";
			decimalSeparatorTo = ",";
			this.precision = precision;
		}
	}
}
