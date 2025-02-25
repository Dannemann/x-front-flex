package br.com.dannemann.gui.component.adg
{
	public final class DADGItemRendererCPF extends DADGItemRenderer
	{
		private const empty:String = "";
		private const dash:String = "-";
		private const dot:String = ".";

		override public function validateProperties():void
		{
			super.validateProperties();

			if (listData && listData.label)
			{
				const cpf:String = trim(listData.label);
				htmlText = cpf ? cpf.substring(0, 3) + dot + cpf.substring(3, 6) + dot + cpf.substring(6, 9) + dash + cpf.substring(9) : empty;
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
