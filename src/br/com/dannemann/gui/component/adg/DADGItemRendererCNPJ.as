package br.com.dannemann.gui.component.adg
{
	public final class DADGItemRendererCNPJ extends DADGItemRenderer
	{
		private const empty:String = "";
		private const dash:String = "-";
		private const dot:String = ".";
		private const slash:String = "/";

		override public function validateProperties():void
		{
			super.validateProperties();

			if (listData && listData.label)
			{
				const cnpj:String = trim(listData.label);
				htmlText = cnpj ? cnpj.substring(0, 2) + dot + cnpj.substring(2, 5) + dot + cnpj.substring(5, 8) + slash + cnpj.substring(8, 12) + dash + cnpj.substring(12) : empty;
			}
		}

		private function trim(str:String):String
		{
			if (str == null) return '';

			var startIndex:int = 0;
			while (isWhitespace(str.charAt(startIndex)))
				++startIndex;

			var endIndex:int = str.length - 1;
			while (isWhitespace(str.charAt(endIndex)))
				--endIndex;

			if (endIndex >= startIndex)
				return str.slice(startIndex, endIndex + 1);
			else
				return "";
		}

		private function isWhitespace(character:String):Boolean
		{
			switch (character)
			{
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;

				default:
					return false;
			}
		}
	}
}
