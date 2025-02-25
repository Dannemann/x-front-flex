package br.com.dannemann.gui.util
{
	public final class DUtilBoolean
	{
		public static const _TRUE:String = "true";
		public static const _YES_en_us:String = "yes";
		public static const _YES_pt_br:String = "sim";
		public static const _FALSE:String = "false";
		public static const _NO_en_us:String = "no";
		public static const _NO_pt_br:String = "nao";
		public static const _NO_ACCENT_pt_br:String = "não";

		public static function isTrue(value:*):Boolean
		{
			if (value is String)
			{
				value = value.toLowerCase();

				if (value == _TRUE ||
					value == _YES_en_us ||
					value == _YES_pt_br)
					return true;
				else
					return false;
			}
			else if (value is Boolean)
				return value;
			else
				return false;
		}

		public static function isFalse(value:*):Boolean
		{
			if (value is String)
			{
				value = value.toLowerCase();

				if (value == _FALSE ||
					value == _NO_en_us ||
					value == _NO_pt_br ||
					value == _NO_ACCENT_pt_br)
					return true;
				else
					return false;
			}
			else if (value is Boolean)
				return !value;
			else
				return false;
		}
	}
}
