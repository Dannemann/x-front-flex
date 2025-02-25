package br.com.dannemann.gui.util
{
	import br.com.dannemann.gui.domain.StrConsts;

	import mx.collections.GroupingCollection2;
	import mx.collections.GroupingField;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.utils.StringUtil;

	public final class DUtilAdvancedDataGrid
	{
		public static function adgcCorrector(item:Object, column:AdvancedDataGridColumn):String
		{
			const columnDataField:String = column.dataField;

			if (item is GroupingCollection2)
				return "";

			if (columnDataField.indexOf(StrConsts._CHAR_DOT) != -1)
				return DUtilObject.navigateToPropertyAndGetValue(columnDataField, item);
			else
				return item[columnDataField].toString();
		}





		public static function sortCompareFunctionForNumbers(a:Number, b:Number):int
		{
			if (!a && !b)
				return 0;
			else if (!a)
				return 1;
			else if (!b)
				return -1;
			else if (a == b)
				return 0;
			else if (a > b)
				return 1;
			else if (a < b)
				return -1;

			throw new Error(StrConsts.getRMString(54));
		}

		public static function sortCompareFunctionForStrings(a:String, b:String):int
		{
			if (!a && !b)
				return 0;
			else if (!a)
				return 1;
			else if (!b)
				return -1;
			else if (a == b)
				return 0;
			else if (a > b)
				return 1;
			else if (a < b)
				return -1;

			throw new Error(StrConsts.getRMString(54));
		}
	}
}
