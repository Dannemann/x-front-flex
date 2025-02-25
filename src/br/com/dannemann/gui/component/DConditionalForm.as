package br.com.dannemann.gui.component
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.core.UIComponent;
	
	import spark.events.IndexChangeEvent;
	import spark.layouts.VerticalAlign;
	
	import br.com.dannemann.gui.bean.FieldDescriptorBean;
	import br.com.dannemann.gui.component.input.DDropDownList;
	import br.com.dannemann.gui.component.input.DTextInput;
	import br.com.dannemann.gui.component.validation.DomainValidatableComponent;
	import br.com.dannemann.gui.controller.EntityDescriptor;
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.library.DIconLibrary;
	import br.com.dannemann.gui.util.DUtilDescriptor;
	import br.com.dannemann.gui.util.DUtilString;
	import br.com.dannemann.gui.validator.DValidatorManager;

	public final class DConditionalForm extends Grid
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		private const _fieldsDataProvider:Array = new Array();
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public var _entityBeanDescriptorsHandler:EntityDescriptor;
		public var _columnsToSelect:String = StrConsts._CHAR_EMPTY_STRING;
		public var _likeDefaults:Object;

		public const _inputRows:ArrayList = new ArrayList();

		
		private const _primaryDataProvider4Conditions:Array = [];
		private const _whereClausesForStringsAndNumbers:Array = [];
		private const _whereClausesForNumbers:Array = [];
		private const _dValidatorManager:DValidatorManager = new DValidatorManager();

		private var _columnsNFrom:String;
		private var _joinConditions:String;
		private var _whereClauses:String;
		private var _firstAddImage:DImage;
		private var _fieldsDDLs:Vector.<DDropDownList> = new Vector.<DDropDownList>();
		private var _whereClausesDDLs:Vector.<DDropDownList> = new Vector.<DDropDownList>();
		private var _addConditionImages:Vector.<DImage> = new Vector.<DImage>();
		private var _removeConditionImages:Vector.<DImage> = new Vector.<DImage>();

		
		
		
		
		
		
		
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Constructor:

		public function DConditionalForm()
		{
			_whereClausesForStringsAndNumbers.push({ label:StrConsts.getRMString(25).toLowerCase(), data:"%a%" });
			_whereClausesForStringsAndNumbers.push({ label:StrConsts.getRMString(114).toLowerCase(), data:"eqEeq" });
			_whereClausesForStringsAndNumbers.push({ label:StrConsts.getRMString(24).toLowerCase(), data:"a%" });
			_whereClausesForStringsAndNumbers.push({ label:StrConsts.getRMString(109).toLowerCase(), data:"eq" });
			_whereClausesForStringsAndNumbers.push({ label:StrConsts.getRMString(26).toLowerCase(), data:"%a" });
			_whereClausesForStringsAndNumbers.push({ label:StrConsts.getRMString(136).toLowerCase(), data:">" });
			_whereClausesForStringsAndNumbers.push({ label:StrConsts.getRMString(137).toLowerCase(), data:">=" });
			_whereClausesForStringsAndNumbers.push({ label:StrConsts.getRMString(138).toLowerCase(), data:"<" });
			_whereClausesForStringsAndNumbers.push({ label:StrConsts.getRMString(139).toLowerCase(), data:"<=" });

			_primaryDataProvider4Conditions.push({ label:StrConsts.getRMString(110), data:"and" });
			_primaryDataProvider4Conditions.push({ label:StrConsts.getRMString(111), data:"or" });
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		//----------------------------------------------------------------------
		// Class Overrides:

		override protected function createChildren():void
		{
			const fieldDescriptors4QueryCreators:Vector.<FieldDescriptorBean> = _entityBeanDescriptorsHandler._domainFields;
			const fieldDescriptors4QueryCreatorsLength:int = fieldDescriptors4QueryCreators.length;
			var fieldDescriptor:FieldDescriptorBean;
			var fieldDescriptorJavaField:String;

			fieldDescriptor = fieldDescriptors4QueryCreators[0];

			for (var i:int = 0; i < fieldDescriptors4QueryCreatorsLength; i++)
			{
				fieldDescriptor = fieldDescriptors4QueryCreators[i];

				if (_entityBeanDescriptorsHandler._searchFieldsFieldDescriptors && _entityBeanDescriptorsHandler._searchFieldsFieldDescriptors[fieldDescriptor._javaField])
					_fieldsDataProvider.push(
					{
						label:fieldDescriptor._fieldNameFormatted,
						data:_entityBeanDescriptorsHandler._searchFieldsFieldDescriptors[fieldDescriptor._javaField]
					});
				else
					_fieldsDataProvider.push(
					{
						label:fieldDescriptor._fieldNameFormatted,
						data:fieldDescriptor
					});
			}

			createNewConditionalRow();
		}

		override public function setFocus():void
		{
			if (_inputRows.getItemAt(0)[2].enabled)
				_inputRows.getItemAt(0)[2].setFocus();
			else
				_inputRows.getItemAt(0)[0].setFocus();
		}

		//----------------------------------------------------------------------
		// DIGUIInput implementation:

		public function dispose():void
		{
			var i:int;

			const fieldsDDLsLength:int = _fieldsDDLs.length;
			for (i = 0; i < fieldsDDLsLength; i++)
				(_fieldsDDLs[i] as DDropDownList).removeEventListener(IndexChangeEvent.CHANGE, adjustCorrectWhereClause);

			const addConditionImagesLength:int = _addConditionImages.length;
			for (i = 0; i < addConditionImagesLength; i++)
				(_addConditionImages[i] as DImage).removeEventListener(MouseEvent.CLICK, onAddCondition);

			const removeConditionImagesLength:int = _removeConditionImages.length;
			for (i = 0; i < removeConditionImagesLength; i++)
				(_removeConditionImages[i] as DImage).removeEventListener(MouseEvent.CLICK, onRemoveCondition);
		}

		
		
		
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Input behavior:

		public function createNewConditionalRow(index:int=-1):void
		{
			const fieldsDropDown:DDropDownList = new DDropDownList();
			fieldsDropDown.id = "fields";
			fieldsDropDown.dataProvider = new ArrayList(_fieldsDataProvider);
			fieldsDropDown.width = 200;
			fieldsDropDown._required = true;

			const numElsEqualsZero:Boolean = numElements == 0;
			
			if (numElsEqualsZero)
			{
				const descriptionField:FieldDescriptorBean = _entityBeanDescriptorsHandler._descriptionField;
				if (descriptionField)
				{
					const fieldsDP:ArrayList = fieldsDropDown.dataProvider as ArrayList;
					const fieldsDPLength:int = fieldsDP.length;
					var loopedFieldDescriptor:FieldDescriptorBean;
					loop:
					for (var i:int = 0; i < fieldsDPLength; i++)
					{
						loopedFieldDescriptor = fieldsDP.getItemAt(i).data as FieldDescriptorBean;

						if (loopedFieldDescriptor._searchFieldFor)
						{
							if (loopedFieldDescriptor._searchFieldFor == descriptionField._javaField)
							{
								fieldsDropDown.selectedItem = fieldsDP.getItemAt(i);
								break loop;
							}
						}
						else if (loopedFieldDescriptor._javaField == descriptionField._javaField)
						{
							fieldsDropDown.selectedItem = fieldsDP.getItemAt(i);
							break loop;
						}
					}
				}
			}

			fieldsDropDown.addEventListener(IndexChangeEvent.CHANGE, adjustCorrectWhereClause, false, 0, true);
			_fieldsDDLs.push(fieldsDropDown);

			const whereClause:DDropDownList = new DDropDownList();
			whereClause.enabled = false;
			whereClause.requireSelection = true;
			// TODO: DISPOSE!!!
			whereClause.addEventListener(IndexChangeEvent.CHANGE, onWhereClauseChange, false, 0, true);
			_whereClausesDDLs.push(whereClause);

			const textInput:DTextInput = new DTextInput();
			textInput._required = true;
			textInput.enabled = false;
			textInput.percentWidth = 100;

			const addImage:DImage = new DImage(DIconLibrary.ADD);
			addImage.buttonMode = true;
			addImage.enabled = false;
			addImage.addEventListener(MouseEvent.CLICK, onAddCondition, false, 0, true);
			_addConditionImages.push(addImage);

			const firstRowVector:Vector.<UIComponent> = new Vector.<UIComponent>();
			const gridRow:GridRow = new GridRow();
			gridRow.percentWidth = 100;
			var gridItem:GridItem = new GridItem();

			if (numElsEqualsZero)
			{
				gridItem.width = 55;
				gridItem.addElement(new DLabel(StrConsts.getRMString(108), true));
				gridItem.setStyle(StrConsts._FLEX_STYLE_PROPERTY_VERTICAL_ALIGN, VerticalAlign.MIDDLE);
				gridRow.addElement(gridItem);

				_firstAddImage = addImage;
			}
			else
			{
				const andOrDDL:DDropDownList = new DDropDownList();
				andOrDDL.dataProvider = new ArrayList(_primaryDataProvider4Conditions);
				andOrDDL.requireSelection = true;
				andOrDDL.width = 55;

				firstRowVector.push(andOrDDL);

				gridItem.addElement(andOrDDL);
				gridRow.addElement(gridItem);
			}

			firstRowVector.push(fieldsDropDown);
			firstRowVector.push(whereClause);
			firstRowVector.push(textInput);
			firstRowVector.push(addImage);

			_dValidatorManager.addComponentToValidation(fieldsDropDown);
			_dValidatorManager.addComponentToValidation(whereClause);
			_dValidatorManager.addComponentToValidation(textInput);

			gridItem = new GridItem();
			gridItem.addElement(fieldsDropDown);
			gridRow.addElement(gridItem);
			gridItem = new GridItem();
			gridItem.addElement(whereClause);
			gridRow.addElement(gridItem);
			gridItem = new GridItem();
			gridItem.addElement(textInput);
			gridItem.percentWidth = 100;
			gridRow.addElement(gridItem);
			gridItem = new GridItem();
			gridItem.setStyle(StrConsts._FLEX_STYLE_PROPERTY_VERTICAL_ALIGN, VerticalAlign.MIDDLE);
			gridItem.addElement(addImage);
			gridRow.addElement(gridItem);

			if (numElements > 0)
			{
				const removeImage:DImage = new DImage(DIconLibrary.REMOVE);
				removeImage.buttonMode = true;
				removeImage.addEventListener(MouseEvent.CLICK, onRemoveCondition, false, 0, true);

				_removeConditionImages.push(removeImage);

				gridItem = new GridItem();
				gridItem.setStyle(StrConsts._FLEX_STYLE_PROPERTY_VERTICAL_ALIGN, VerticalAlign.MIDDLE);
				gridItem.addElement(removeImage);
				gridRow.addElement(gridItem);
			}

			if (index == -1)
			{
				_inputRows.addItem(firstRowVector);
				addElement(gridRow);
			}
			else
			{
				_inputRows.addItemAt(firstRowVector, index);
				addElementAt(gridRow, index);
			}

			if (numElsEqualsZero && fieldsDropDown.selectedItem)
				adjustCorrectWhereClause(null);
		}

		public function mountHQLQuery(findAll:Boolean=false):String
		{
			if (findAll || _dValidatorManager.doValidation())
			{
				const alias:String = _entityBeanDescriptorsHandler._crudDescriptor._classSimpleName.toLowerCase();
				var row:Vector.<UIComponent> = _inputRows.getItemAt(0) as Vector.<UIComponent>;
				var i:int;
				var usingSelectKeyWord:Boolean = false;

				_columnsNFrom = "";
				_joinConditions = "";
				_whereClauses = "";

				if (_columnsToSelect)
				{
					const columnsToSelectArr:Array = _columnsToSelect.split(",");
					const columnsToSelectLen:int = columnsToSelectArr.length;
					var colum:String;
					for (i = 0; i < columnsToSelectLen; i++)
					{
						colum = columnsToSelectArr[i];

						if (colum.indexOf(".") != -1)
							colum = colum.split(".")[0];

						columnsToSelectArr[i] = alias + "." + colum + " as " + colum;
					}

					_columnsNFrom += "select " + columnsToSelectArr.join(", ") + " ";

					usingSelectKeyWord = true;
				}

				_columnsNFrom += "from " + _entityBeanDescriptorsHandler._crudDescriptor._classSimpleName + " as " + alias;

				const manyToOneFieldDescriptors:Vector.<FieldDescriptorBean> = _entityBeanDescriptorsHandler._manyToOneFieldDescriptors;
				if (manyToOneFieldDescriptors)
				{
					const manyToOneFieldDescriptorsLength:int = manyToOneFieldDescriptors.length;
					for (i = 0; i < manyToOneFieldDescriptorsLength; i++)
					{
						if (usingSelectKeyWord)
							_joinConditions += " left join ";
						else
							_joinConditions += " left join fetch ";

						_joinConditions += alias + "." + manyToOneFieldDescriptors[i]._javaField + " ";
					}
				}

				if (!findAll)
				{
					_whereClauses += mountAWhereClause(row);

					const inputRowsLength:int = _inputRows.length;
					for (i = 1; i < inputRowsLength; i++)
						_whereClauses += mountAWhereClause(_inputRows.getItemAt(i) as Vector.<UIComponent>);
				}

				const hqlQuery:String = _columnsNFrom + _joinConditions + _whereClauses;

				return hqlQuery;
			}
			else
				return null;
		}

		public function reset():void
		{
			_firstAddImage = null;
			_fieldsDDLs = new Vector.<DDropDownList>();
			_addConditionImages = new Vector.<DImage>();
			_removeConditionImages = new Vector.<DImage>();
			_dValidatorManager.clean();
			_inputRows.removeAll();
			removeAllElements();
			createNewConditionalRow();
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Private interface:

		// Event listeners:

		private function adjustCorrectWhereClause(event:IndexChangeEvent):void
		{
			const fieldsDDL:DDropDownList = event ? event.currentTarget as DDropDownList : _inputRows.getItemAt(0)[0];
			const selectedItemFieldDescriptor:FieldDescriptorBean = fieldsDDL.selectedItem.data as FieldDescriptorBean;
			const parentGridRow:GridRow = fieldsDDL.parent.parent as GridRow;
			const parentGridRowIndex:int = getElementIndex(parentGridRow);
			const indexCorrector:int = parentGridRowIndex == 0 ? 1 : 2;
			const relativeWhereClauseDDL:DDropDownList = _inputRows.getItemAt(parentGridRowIndex)[indexCorrector];

			relativeWhereClauseDDL.dataProvider = new ArrayList(_whereClausesForStringsAndNumbers);

			if (_likeDefaults)
			{
				const likeDefault:String = _likeDefaults[selectedItemFieldDescriptor._javaField];

				if (likeDefault)
				{
					const whereClausesDP:ArrayList = relativeWhereClauseDDL.dataProvider as ArrayList;
					const whereClausesDPLength:int = whereClausesDP.length;
					loop:
					for (var i:int = 0; i < whereClausesDPLength; i++)
						if (whereClausesDP.getItemAt(i).data == likeDefault)
						{
							relativeWhereClauseDDL.selectedItem = whereClausesDP.getItemAt(i);
							break loop;
						}
				}
			}

			relativeWhereClauseDDL.enabled = true;
			(_inputRows.getItemAt(parentGridRowIndex)[(++indexCorrector)] as DTextInput).enabled = true;
			(_inputRows.getItemAt(parentGridRowIndex)[(++indexCorrector)] as DImage).enabled = true;
		}

		private function onWhereClauseChange(event:IndexChangeEvent):void
		{
		}

		private function onAddCondition(event:MouseEvent):void
		{
			createNewConditionalRow(getElementIndex((event.currentTarget as DImage).parent.parent as GridRow) + 1);
		}

		private function onRemoveCondition(event:MouseEvent):void
		{
			const removeImage:DImage = event.currentTarget as DImage;
			removeImage.removeEventListener(MouseEvent.CLICK, onRemoveCondition);

			const parentGridRow:GridRow = removeImage.parent.parent as GridRow;
			const parentGridRowIndex:int = getElementIndex(parentGridRow);

			const rowVector:Vector.<UIComponent> = _inputRows.getItemAt(parentGridRowIndex) as Vector.<UIComponent>;
			_dValidatorManager.removeComponentToValidation(rowVector[1] as DomainValidatableComponent);
			_dValidatorManager.removeComponentToValidation(rowVector[2] as DomainValidatableComponent);
			_dValidatorManager.removeComponentToValidation(rowVector[3] as DomainValidatableComponent);
			_inputRows.removeItemAt(parentGridRowIndex);

			removeElement(parentGridRow);
		}

		// Private generic interface:

		private function mountAWhereClause(row:Vector.<UIComponent>):String
		{
			var index:int = ((row[0] as DDropDownList).id == "fields") ? 0 : 1;
			var fieldDescriptor:FieldDescriptorBean = (row[index] as DDropDownList).selectedItem.data;
			var whereClauseMatchMode:String = (row[index + 1] as DDropDownList).selectedItem.data as String;
			var whereClause:String = (index == 0) ? " where " : " " + (row[0] as DDropDownList).selectedItem.data.toString() + " ";
			var whereClauseResolved:String;

			const alias:String = _entityBeanDescriptorsHandler._crudDescriptor._classSimpleName.toLowerCase();

			if (DUtilDescriptor.isNumericType(fieldDescriptor))
			{
				if (whereClauseMatchMode == "a%" || whereClauseMatchMode == "%a%" || whereClauseMatchMode == "%a")
					whereClause += propertyToHQLStr(alias, (row[index] as DDropDownList).selectedItem.data._dataGridColumn);
				else
					whereClause += alias + "." + (row[index] as DDropDownList).selectedItem.data._dataGridColumn;

				whereClauseResolved = resolveWhereClause(whereClauseMatchMode, (row[index + 2] as DTextInput).text);

				if (!whereClauseResolved)
				{
					DNotificator.showError2(StrConsts.getRMString(121));
					return null;
				}
				else
					whereClause += whereClauseResolved;
			}
			else
			{
				const isSearchField:Boolean = (row[index] as DDropDownList).selectedItem.data._searchFieldFor;

				whereClauseResolved = resolveWhereClause((row[index + 1] as DDropDownList).selectedItem.data, (row[index + 2] as DTextInput).text, isSearchField)

				if (!whereClauseResolved)
				{
					DNotificator.showError2(StrConsts.getRMString(121));
					return null;
				}
				else
					whereClause += propertyToHQLLower(alias, (row[index] as DDropDownList).selectedItem.data._dataGridColumn, !isSearchField) + whereClauseResolved;
			}

			return whereClause;
		}

		private function propertyToHQLLower(alias:String, field:String, notASearchField:Boolean=true):String
		{
			if (notASearchField)
				return " lower(" + alias + "." + field + ") ";
			else
				return " " + alias + "." + field + " ";
		}

		private function propertyToHQLStr(alias:String, field:String):String
		{
			return " str(" + alias + "." + field + ") ";
		}

		private function resolveWhereClause(whereClause:String, value:String, isSearchField:Boolean=false):String
		{
			var returnStr:String = " ";

			if (isSearchField)
				value = DUtilString.removeSpecialCharsAndUpperCase(value);

			if (whereClause == "%a%")
				returnStr += "like '%" + value + "%'";
			else if (whereClause == "eqEeq")
			{
				const tempLowerCasedValue:String = value.toLowerCase();
				var betweenValues:Array;

				if (tempLowerCasedValue.indexOf(" e ") != -1)
				{
					if (DUtilString.numberOfOccurrences(tempLowerCasedValue, " e ") > 1)
						return null;
					else
						betweenValues = value.split(/ e /i);
				}
				else if (tempLowerCasedValue.indexOf(" and ") != -1)
				{
					if (DUtilString.numberOfOccurrences(tempLowerCasedValue, " and ") > 1)
						return null;
					else
						betweenValues = value.split(/ and /i);
				}

				if (betweenValues)
					returnStr += "between '" + betweenValues[0] + "' and '" + betweenValues[1] + "'";
				else
					returnStr += ">= '" + value + "'";
			}
			else if (whereClause == ">")
				returnStr += "> '" + value + "'";
			else if (whereClause == ">=")
				returnStr += ">= '" + value + "'";
			else if (whereClause == "<")
				returnStr += "< '" + value + "'";
			else if (whereClause == "<=")
				returnStr += "<= '" + value + "'";
			else if (whereClause == "a%")
				returnStr += "like '" + value + "%'";
			else if (whereClause == "eq")
				returnStr += "= '" + value + "'";
			else if (whereClause == "%a")
				returnStr += "like '%" + value + "'";

			return (returnStr + " ");
		}

		//----------------------------------------------------------------------
	}
}
