package br.com.dannemann.gui.custom
{
	import mx.collections.GroupingField;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;

	public class DCustomLabelFunctionADG
	{
		//----------------------------------------------------------------------
		// Fields:

		public var _dataField:String;
		public var _fieldNameFormatted:String;

		//----------------------------------------------------------------------
		// Public interface:

		public function myLabelFunction(item:Object, column:AdvancedDataGridColumn):String
		{
			return valueSwitcher(item[_dataField]);
		}

		public function mySortCompareFunction(obj1:Object, obj2:Object):int
		{
			return defaultComparison(obj1, obj2);
		}

		public function myGroupingFunction(item:Object, column:GroupingField):String
		{
			return valueSwitcher(item[column.name]);
		}

		//----------------------------------------------------------------------
		// Protected interface:

		protected function valueSwitcher(value:String):String
		{
			if (value)
				return value;
			else
				return "";
		}

		protected function defaultComparison(obj1:Object, obj2:Object):int
		{
			const a:String = valueSwitcher(obj1[_dataField]);
			const b:String = valueSwitcher(obj2[_dataField]);

			if (a == null && b == null)
				return 0;
			else if (a == null)
				return 1;
			else if (b == null)
				return -1;
			else if (a < b)
				return -1;
			else if (a > b)
				return 1;
			else
				return 0;
		}

		//----------------------------------------------------------------------
	}
}
