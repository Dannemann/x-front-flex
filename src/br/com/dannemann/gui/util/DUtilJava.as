package br.com.dannemann.gui.util
{
	import br.com.dannemann.gui.domain.StrConsts;

	public final class DUtilJava
	{
		public static const _JAVA_LANG_SHORT_MIN_VALUE:int = -32768;
		public static const _JAVA_LANG_SHORT_MAX_VALUE:int = 32767;
		public static const _JAVA_LANG_INTEGER_MIN_VALUE:int = -2147483648;
		public static const _JAVA_LANG_INTEGER_MAX_VALUE:int = 2147483647;
		public static const _JAVA_LANG_LONG_MIN_VALUE:int = -9223372036854775808;
		public static const _JAVA_LANG_LONG_MAX_VALUE:int = 9223372036854775807;
		
		public static function isJavaLangShort(javaType:String):Boolean
		{
			return javaType == StrConsts._JAVA_TYPE_Short;
		}

		public static function isJavaLangInteger(javaType:String):Boolean
		{
			return javaType == StrConsts._JAVA_TYPE_Integer;
		}

		public static function isJavaLangLong(javaType:String):Boolean
		{
			return javaType == StrConsts._JAVA_TYPE_Long;
		}

		public static function isIntegerType(javaType:String):Boolean
		{
			return (
				(javaType == StrConsts._JAVA_TYPE_Short) ||
				(javaType == StrConsts._JAVA_TYPE_Integer) ||
				(javaType == StrConsts._JAVA_TYPE_Long));
		}

		public static function isFloatingPointType(javaType:String):Boolean
		{
			return (
				(javaType == StrConsts._JAVA_TYPE_Double) ||
				(javaType == StrConsts._JAVA_TYPE_Float));
		}

		public static function isOutOfShortLimits(value:Number):Boolean
		{
			if ((value < -32768) || (value > 32767))
				return false;
			else
				return true;
		}

		public static function isOutOfIntegerLimits(value:Number):Boolean
		{
			if ((value < -2147483648) || (value > 2147483647))
				return false;
			else
				return true;
		}

		public static function isOutOfLongLimits(value:Number):Boolean
		{
			if ((value < -9223372036854775808) || (value > 9223372036854775807))
				return false;
			else
				return true;
		}
	}
}
