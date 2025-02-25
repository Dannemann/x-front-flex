package br.com.dannemann.gui.util
{
	public final class DUtilGender
	{
		public static const _M:String = "m";
		public static const _MALE_en_us:String = "male";
		public static const _MALE_pt_br:String = "macho";
		public static const _MAN_en_us:String = "man";
		public static const _MAN_pt_br:String = "homem";
		public static const _F:String = "f";
		public static const _FEMALE_en_us:String = "female";
		public static const _FEMALE_pt_br:String = "femea";
		public static const _FEMALE_ACCENT_pt_br:String = "fêmea";
		public static const _WOMAN_en_us:String = "woman";
		public static const _WOMAN_pt_br:String = "mulher";

		public static function isMale(value:*):Boolean
		{
			if (value is String)
			{
				value = value.toLowerCase();

				if (DUtilBoolean.isTrue(value) ||
					value == _M ||
					value == _MALE_en_us ||
					value == _MALE_pt_br ||
					value == _MAN_en_us ||
					value == _MAN_pt_br)
					return true;
				else
					return false;
			}
			else if (value is Boolean)
				return value;
			else
				return false;
		}

		public static function isFemale(value:*):Boolean
		{
			if (value is String)
			{
				value = value.toLowerCase();

				if (DUtilBoolean.isFalse(value) ||
					value == _F ||
					value == _FEMALE_en_us ||
					value == _FEMALE_pt_br ||
					value == _FEMALE_ACCENT_pt_br ||
					value == _WOMAN_en_us ||
					value == _WOMAN_pt_br)
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
