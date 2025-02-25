package br.com.dannemann.gui.util
{
	import br.com.dannemann.gui.domain.StrConsts;

	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.dataGridClasses.DataGridColumn;

	public final class DUtilLabelFunction
	{
		public static function dateFormatterToBrazilADGC(item:Object, column:AdvancedDataGridColumn):String
		{
			const dateValueAsNumber:String = item[column.dataField];

			if (dateValueAsNumber)
			{
				if (dateValueAsNumber.length == 8)
					return DUtilDate.formatStringYYYYMMDD_2_BrStringDDMMYYYY(dateValueAsNumber);
				else if (dateValueAsNumber.length == 10)
					return DUtilDate.formatStringYYYYMMDDHHMM_2_BrStringDDMMYYYYHHMM(dateValueAsNumber);
			}

			return null;
		}

		public static function dateFormatterToBrazilDGC(item:Object, column:DataGridColumn):String
		{
			const dateValueAsNumber:String = item[column.dataField];

			if (dateValueAsNumber)
			{
				if (dateValueAsNumber.length == 8)
					return DUtilDate.formatStringYYYYMMDD_2_BrStringDDMMYYYY(dateValueAsNumber);
				else if (dateValueAsNumber.length == 10)
					return DUtilDate.formatStringYYYYMMDDHHMM_2_BrStringDDMMYYYYHHMM(dateValueAsNumber);
			}

			return null;
		}

		public static function hidePasswordWithAsteriskCharactersADGC(item:Object, column:AdvancedDataGridColumn):String
		{
			return StrConsts._CHAR_ASTERISKX5;
		}

		public static function phoneNumberFormatterADGC(item:Object, column:AdvancedDataGridColumn):String
		{
			const phoneNumber:String = item[column.dataField];

			if (phoneNumber)
				return phoneNumber.substring(0, 2) + StrConsts._CHAR_SPACE + phoneNumber.substring(2, 6) + StrConsts._CHAR_DASH + phoneNumber.substring(6, 10);

			return null;
		}

		public static function phoneNumberFormatterDGC(item:Object, column:DataGridColumn):String
		{
			const phoneNumber:String = item[column.dataField];

			if (phoneNumber)
				return phoneNumber.substring(0, 2) + StrConsts._CHAR_SPACE + phoneNumber.substring(2, 6) + StrConsts._CHAR_DASH + phoneNumber.substring(6, 10);

			return null;
		}
	}
}
