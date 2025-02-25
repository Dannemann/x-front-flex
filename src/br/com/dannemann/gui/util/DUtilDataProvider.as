package br.com.dannemann.gui.util
{
	import br.com.dannemann.gui.domain.StrConsts;

	import mx.collections.HierarchicalCollectionView;
	import mx.collections.HierarchicalData;
	import mx.controls.AdvancedDataGrid;

	public final class DUtilDataProvider
	{
		public var _targetAdvancedDataGrid:AdvancedDataGrid;
		public var _descriptorFKHolderForJavaField:String;
		public var _executeAfter_flat2HierarchicalData:Function;

		private var _returnedArray:Array;
		private var _returnedArrayLength:int;
		private var _hierarchicalArray:Array;

		private const id:String = "id"; // TODO: "id" "hard-coded". Tornar dinâmico.

		public function DUtilDataProvider(targetAdvancedDataGrid:AdvancedDataGrid, descriptorFKHolderForJavaField:String, executeAfter_flat2HierarchicalData:Function=null)
		{
			_targetAdvancedDataGrid = targetAdvancedDataGrid;
			_descriptorFKHolderForJavaField = descriptorFKHolderForJavaField;
			_executeAfter_flat2HierarchicalData = executeAfter_flat2HierarchicalData;
		}

		public function flat2HierarchicalData(dataProvider:Array):void
		{
			_hierarchicalArray = [];
			_returnedArray = dataProvider;
			_returnedArrayLength = _returnedArray.length;

			var objHolder:Object;

			for (var i:int = 0; i < _returnedArrayLength; i++)
			{
				objHolder = _returnedArray[i];

				if ((objHolder[_descriptorFKHolderForJavaField] == null) || (objHolder[id] == objHolder[_descriptorFKHolderForJavaField]))
				{
					_hierarchicalArray.push(objHolder);
					findMyChildren(objHolder);
				}
			}

			const hierarchicalData:HierarchicalData = new HierarchicalData();
			hierarchicalData.source = _hierarchicalArray;
			const hierarchicalCollectionView:HierarchicalCollectionView = new HierarchicalCollectionView(hierarchicalData);
			_targetAdvancedDataGrid.dataProvider = null;
			_targetAdvancedDataGrid.displayItemsExpanded = true;
			_targetAdvancedDataGrid.dataProvider = hierarchicalCollectionView;
			_targetAdvancedDataGrid.validateNow();

			if (_executeAfter_flat2HierarchicalData != null)
				_executeAfter_flat2HierarchicalData();
		}

		private function findMyChildren(item:Object):void
		{
			item[StrConsts._FLEX_PROPERTY_CHILDREN] = [];
			var objHolder:Object;

			for (var j:int = 0; j < _returnedArrayLength; j++)
			{
				objHolder = _returnedArray[j];

				if (objHolder[_descriptorFKHolderForJavaField] == item[id])
				{
					(item[StrConsts._FLEX_PROPERTY_CHILDREN] as Array).push(objHolder);
					findMyChildren(objHolder);
				}
			}
		}
	}
}
