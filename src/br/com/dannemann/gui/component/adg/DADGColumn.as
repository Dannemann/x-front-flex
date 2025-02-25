package br.com.dannemann.gui.component.adg
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.bean.FieldDescriptorBean;
	import br.com.dannemann.gui.component.adg.filter.DADGColumnFilterBase;
	import br.com.dannemann.gui.component.adg.filter.DADGColumnFilterWildcard;
	import br.com.dannemann.gui.controller.ServerVarsDecoder;
	import br.com.dannemann.gui.custom.DCustomLabelFunctionADG;
	import br.com.dannemann.gui.labelFunction.adg.DLabelFBooleanToGender;
	import br.com.dannemann.gui.labelFunction.adg.DLabelFBooleanToYesNo;
	import br.com.dannemann.gui.labelFunction.adg.DLabelFDouble;
	import br.com.dannemann.gui.renderer.DRendererADGCImageCell;
	import br.com.dannemann.gui.util.DUtilAdvancedDataGrid;
	import br.com.dannemann.gui.util.DUtilJava;
	import br.com.dannemann.gui.util.DUtilLabelFunction;

	import flash.utils.getDefinitionByName;

	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.core.ClassFactory;
	import mx.core.ContextualClassFactory;

	public final class DADGColumn extends AdvancedDataGridColumn
	{
		public var _dADG:DADG;
		public var _myFieldDescriptor:FieldDescriptorBean;
		public var _isFiltered:Boolean;
		public var _useBoldTextForMatchingItems:Boolean;
		public var _filter:DADGColumnFilterBase;

		public function DADGColumn(adg:DADG, myFieldDescriptor:FieldDescriptorBean, isFiltered:Boolean=true, useBoldTextForMatchingItems:Boolean=true)
		{
			super(null);

			_dADG = adg;
			_myFieldDescriptor = myFieldDescriptor;

			if ((_isFiltered = isFiltered))
			{
				headerRenderer = new ClassFactory(DADGHeaderRenderer);

				if (!_filter)
					_filter = new DADGColumnFilterWildcard(this);

				if ((_useBoldTextForMatchingItems = useBoldTextForMatchingItems))
					if (_dADG.itemRenderer is ContextualClassFactory)
						_dADG.itemRenderer = new ClassFactory(DADGItemRenderer);

				_dADG.isFiltered = true;
			}

			// TODO: This should be label functions.
			if (myFieldDescriptor._isCPF)
				itemRenderer = new ClassFactory(DADGItemRendererCPF);
			else if (myFieldDescriptor._isCNPJ)
				itemRenderer = new ClassFactory(DADGItemRendererCNPJ);

			if (_myFieldDescriptor)
			{
				dataField = _myFieldDescriptor._dataGridColumn;
				headerText = ServerVarsDecoder.replaceAllMessageDVars(_myFieldDescriptor._fieldNameFormatted);

				if (_myFieldDescriptor._customADGLabelFunction)
				{
					const customLB:DCustomLabelFunctionADG = new (getDefinitionByName(_myFieldDescriptor._customADGLabelFunction) as Class)() as DCustomLabelFunctionADG;
					customLB._dataField = _myFieldDescriptor._dataGridColumn;
					sortCompareFunction = customLB.mySortCompareFunction;
					labelFunction = customLB.myLabelFunction;
				}
				else if (_myFieldDescriptor._isDateField)
					labelFunction = DUtilLabelFunction.dateFormatterToBrazilADGC;
				else if (_myFieldDescriptor._isPhoneNumber)
					labelFunction = DUtilLabelFunction.phoneNumberFormatterADGC;
				else if (_myFieldDescriptor._isGender)
				{
					const booleanToGenderLF:DLabelFBooleanToGender = new DLabelFBooleanToGender();
					booleanToGenderLF._dataField = _myFieldDescriptor._javaField;
					sortCompareFunction = booleanToGenderLF.mySortCompareFunction;
					labelFunction = booleanToGenderLF.myLabelFunction;
					width = 50;
				}
				else if (_myFieldDescriptor._javaType == StrConsts._JAVA_TYPE_Boolean)
				{
					const booleanLabelFunc:DLabelFBooleanToYesNo = new DLabelFBooleanToYesNo();
					booleanLabelFunc._dataField = _myFieldDescriptor._javaField;
					sortCompareFunction = booleanLabelFunc.mySortCompareFunction;
					labelFunction = booleanLabelFunc.myLabelFunction;
					width = 50;
				}
				else if (DUtilJava.isFloatingPointType(_myFieldDescriptor._javaType))
				{
					const doubleLabelFunc:DLabelFDouble = new DLabelFDouble();
					doubleLabelFunc._dataField = _myFieldDescriptor._javaField;
					labelFunction = doubleLabelFunc.myLabelFunction;
				}
				else if (_myFieldDescriptor._isManyToOne)
					labelFunction = DUtilAdvancedDataGrid.adgcCorrector;
//				else if (_myFieldDescriptor._imageField)
//					itemRenderer = new ClassFactory(DRendererADGCImageCell);
				else if (_myFieldDescriptor._isMainID)
					width = 55;

				const dataGridColulmnWidth:String = _myFieldDescriptor._dataGridColumnWidth;
				if (dataGridColulmnWidth)
					width = Number(dataGridColulmnWidth);
			}
		}

		public function filter(value:String):void
		{
			_filter._searchString = value;
			_dADG.updateColumnFilterFunctions();
		}
	}
}
