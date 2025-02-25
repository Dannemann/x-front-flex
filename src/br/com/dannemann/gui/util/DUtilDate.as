package br.com.dannemann.gui.util
{
	import br.com.dannemann.gui.domain.StrConsts;

	public final class DUtilDate
	{
		public static function addDaysOnDate(date:Date, days:int):Date
		{
			return new Date(date.getTime() + (days * (1000 * 60 * 60 * 24)));
		}

		public static function dateObjToBrStringDDMMYYYY(date:Date, incrementMonth:Boolean=true):String
		{
			const dateStr:String = String(date.date);
			const monthStr:String = incrementMonth ? String((Number(date.month) + 1)) : String(date.month);

			return (dateStr.length == 1 ? StrConsts._STR_0 + dateStr : dateStr) + StrConsts._CHAR_FORWARD_SLASH +
				(monthStr.length == 1 ? StrConsts._STR_0 + monthStr : monthStr) + StrConsts._CHAR_FORWARD_SLASH +
				date.fullYear;
		}

		public static function dateObjToBrStringDDMMYYYYHHMM(date:Date, incrementMonth:Boolean=true):String
		{
			const dateStr:String = String(date.date);
			const monthStr:String = incrementMonth ? String((Number(date.month) + 1)) : String(date.month);
			const hourStr:String = String(date.hours);
			const minuteStr:String = String(date.minutes);

			return (dateStr.length == 1 ? StrConsts._STR_0 + dateStr : dateStr) + StrConsts._CHAR_FORWARD_SLASH +
				(monthStr.length == 1 ? StrConsts._STR_0 + monthStr : monthStr) + StrConsts._CHAR_FORWARD_SLASH +
				date.fullYear + StrConsts._CHAR_SPACE +
				(hourStr.length == 1 ? StrConsts._STR_0 + hourStr : hourStr) + StrConsts._CHAR_COLON +
				(minuteStr.length == 1 ? StrConsts._STR_0 + minuteStr : minuteStr);
		}

		public static function dateObjToBrStringDDMMYYYYHHMMSS(date:Date, incrementMonth:Boolean=true):String
		{
			const dateStr:String = String(date.date);
			const monthStr:String = incrementMonth ? String((Number(date.month) + 1)) : String(date.month);
			const hourStr:String = String(date.hours);
			const minuteStr:String = String(date.minutes);
			const secondStr:String = String(date.seconds);

			return (dateStr.length == 1 ? StrConsts._STR_0 + dateStr : dateStr) + StrConsts._CHAR_FORWARD_SLASH +
				(monthStr.length == 1 ? StrConsts._STR_0 + monthStr : monthStr) + StrConsts._CHAR_FORWARD_SLASH +
				date.fullYear + StrConsts._CHAR_SPACE +
				(hourStr.length == 1 ? StrConsts._STR_0 + hourStr : hourStr) + StrConsts._CHAR_COLON +
				(minuteStr.length == 1 ? StrConsts._STR_0 + minuteStr : minuteStr) + StrConsts._CHAR_COLON +
				(secondStr.length == 1 ? StrConsts._STR_0 + secondStr : secondStr);
		}

		public static function dateObjToHHMM(date:Date):String
		{
			const hourStr:String = String(date.hours);
			const minuteStr:String = String(date.minutes);

			return (hourStr.length == 1 ? StrConsts._STR_0 + hourStr : hourStr) + StrConsts._CHAR_COLON +
				(minuteStr.length == 1 ? StrConsts._STR_0 + minuteStr : minuteStr);
		}

		public static function formatStringYYYYMMDDHHMM_2_BrStringDDMMYYYYHHMM(string:String):String
		{
			return string.substring(6, 8) + StrConsts._CHAR_FORWARD_SLASH +
				string.substring(4, 6) + StrConsts._CHAR_FORWARD_SLASH +
				string.substring(0, 4) + StrConsts._CHAR_SPACE +
				string.substring(8, 10) + StrConsts._CHAR_COLON +
				string.substring(10, 12);
		}

		public static function formatStringYYYYMMDD_2_BrStringDDMMYYYY(string:String):String
		{
			return string.substring(6, 8) + StrConsts._CHAR_FORWARD_SLASH +
				string.substring(4, 6) + StrConsts._CHAR_FORWARD_SLASH +
				string.substring(0, 4) + StrConsts._CHAR_SPACE;
		}

		public static function dateNowMap_From_DFxGUIService_Now_Method_To_String_YYYYMMDDHHMM(returnObjFromNowMethod:Object):String
		{
			var dayStr:String = String(returnObjFromNowMethod.day);
			if (dayStr.length == 1)
				dayStr = StrConsts._STR_0 + dayStr;

			var monthStr:String = String(returnObjFromNowMethod.month);
			if (monthStr.length == 1)
				monthStr = StrConsts._STR_0 + monthStr;

			var hourStr:String = String(returnObjFromNowMethod.hour);
			if (hourStr.length == 1)
				hourStr = StrConsts._STR_0 + hourStr;

			var minuteStr:String = String(returnObjFromNowMethod.minute);
			if (minuteStr.length == 1)
				minuteStr = StrConsts._STR_0 + minuteStr;

			return returnObjFromNowMethod.year + monthStr + dayStr + hourStr + minuteStr;
		}
	}
}
