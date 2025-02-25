package br.com.dannemann.gui.component.adg.filter
{
	import br.com.dannemann.gui.component.adg.DADGColumn;

	public final class DADGColumnFilterWildcard extends DADGColumnFilterBase
	{
		private const _children:String = "children";
		private const _groupLabelProperty:String = "GroupLabel";
		private const _dot:String = ".";
		private const _getNodeDepth:String = "getNodeDepth";

		public function DADGColumnFilterWildcard(column:DADGColumn)
		{
			super(column);
		}

		override public function filterFunction(obj:Object):Boolean
		{
			if (!(obj.hasOwnProperty(_children)))
			{
				if (_searchExpression)
					return _searchExpression.test(_column.itemToLabel(obj));
				else
					return false;
			}
			else
			{
				if (obj.hasOwnProperty(_groupLabelProperty))
					return true;
				else if (_column._dADG.dataProvider.hasOwnProperty(_getNodeDepth))
					return true;
				else if (_column.dataField.indexOf(_dot) == -1)
					return _searchExpression.test(_column.itemToLabel(obj));
				else
					return _searchExpression.test(navigateToPropertyAndGetValue(_column.dataField, obj));
			}
		}

		private function navigateToPropertyAndGetValue(propertyToFind:String, target:Object):String
		{
			const propertiesToFind:Array = propertyToFind.split(_dot);
			const propertiesToFindLength:int = propertiesToFind.length;
			var propertyValue:Object = null;

			for (var i:int = 0; i < propertiesToFindLength; i++)
			{
				if (!propertyValue)
				{
					propertyValue = target[propertiesToFind[i]];

					if (!propertyValue)
						return _searchString;
					else if (propertyValue is Object)
						continue;
				}
				else
				{
					if (propertyValue is String)
						return propertyValue as String;
					else
					{
						propertyValue = propertyValue[propertiesToFind[i]];

						if (propertyValue is String || propertyValue is Number)
							return propertyValue.toString();
						else
							continue;
					}
				}
			}

			return null;
		}
	}
}
