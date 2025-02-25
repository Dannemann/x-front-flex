package br.com.dannemann.gui.bean
{
	import br.com.dannemann.gui.component.input.DSelectOneListing;
	import br.com.dannemann.gui.controller.EntityDescriptor;
	import br.com.dannemann.gui.controller.ServerVarsDecoder;
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.util.DUtilBoolean;

	public final class FieldDescriptorBean implements DIBean
	{
		public var _index:int = -1;
		public var _tabNavigatorIndex:int = 0;
		public var _length:int = 255;
		public var _defaultValue:String = StrConsts._CHAR_EMPTY_STRING;
		public var _acceptableValues:String = StrConsts._CHAR_EMPTY_STRING;
		public var _fieldNameFormatted:String = StrConsts._CHAR_EMPTY_STRING;
		public var _dataGridColumn:String = StrConsts._CHAR_EMPTY_STRING;
		public var _dataGridColumnWidth:String = StrConsts._CHAR_EMPTY_STRING;
		public var _postLabel:String = StrConsts._CHAR_EMPTY_STRING;
		public var _solDescriptonField:String = StrConsts._CHAR_EMPTY_STRING;
		public var _solAutoCompleteMode:String = DSelectOneListing._AUTO_COMPLETE_MODE_LAZY;
		public var _solFieldsToSelectCSV:String = StrConsts._CHAR_EMPTY_STRING;
		public var _solDataGridColumnsCSV:String = StrConsts._CHAR_EMPTY_STRING;
		public var _solDataGridColumnsToRemoveCSV:String = StrConsts._CHAR_EMPTY_STRING;
		public var _solDataGridColumnsManyToOneCSV:String = StrConsts._CHAR_EMPTY_STRING;
		public var _solLikeDefaults:String = StrConsts._CHAR_EMPTY_STRING;
		public var _searchFieldFor:String = StrConsts._CHAR_EMPTY_STRING;
		public var _fkHolderFor:String = StrConsts._CHAR_EMPTY_STRING;
		public var _hierarchicalCodeIdField:String = StrConsts._CHAR_EMPTY_STRING;
		public var _hierarchicalCodeParentField:String = StrConsts._CHAR_EMPTY_STRING;
		public var _compositeIDFields:String = StrConsts._CHAR_EMPTY_STRING;
		public var _customADGLabelFunction:String = StrConsts._CHAR_EMPTY_STRING;
		public var _mask:String = StrConsts._CHAR_EMPTY_STRING;
		public var _imageField:String = StrConsts._CHAR_EMPTY_STRING;
		public var _manyToManyTarget:String = StrConsts._CHAR_EMPTY_STRING;
		public var _manyToManyTableName:String = StrConsts._CHAR_EMPTY_STRING;
		public var _manyToManyJoinColumnName:String = StrConsts._CHAR_EMPTY_STRING;
		public var _manyToManyInverseJoinColumnName:String = StrConsts._CHAR_EMPTY_STRING;
		private var groupByThisField:String = StrConsts._CHAR_EMPTY_STRING;
		public function get _groupByThisField():Boolean
		{
			return DUtilBoolean.isTrue(groupByThisField);
		}
		public function set _groupByThisField(value:Boolean):void
		{
			groupByThisField = value.toString();
		}
		
		
		
		
		public var _requiredForSearch:Boolean;
		public var _bypassRequiredFieldsForSearch:Boolean;
		public var _minLengthForSearch:Number;
		
		
		
		
		
		public var _isMainID:Boolean = false;
		public var _isCodeField:Boolean = false;
		public var _isDescriptionField:Boolean = false;
		public var _isNullable:Boolean = true;
		public var _isReadonly:Boolean = false;
		public var _isInsertable:Boolean = true;
		public var _isUpdatable:Boolean = true;
		public var _isUnique:Boolean = false;
		public var _isDateField:Boolean = false;
		public var _isHourField:Boolean = false;
		public var _isTimestamp:Boolean = false;
		public var _isCEP:Boolean = false;
		public var _isCNPJ:Boolean = false;
		public var _isCPF:Boolean = false;
		public var _isGender:Boolean = false;
		public var _isPasswordField:Boolean = false;
		public var _isPasswordEncrypted:Boolean = false;
		public var _isPhoneNumber:Boolean = false;
		public var _isRemarksField:Boolean = false;
		public var _isManyToOne:Boolean = false;
		public var _isManyToMany:Boolean = false;
		public var _isVersionField:Boolean = false;
		public var _validateCEPNumber:Boolean = true;
		public var _validateCNPJNumber:Boolean = true;
		public var _validateCPFNumber:Boolean = true;
		public var _validatePhoneNumber:Boolean = true;

		public var _isOneToMany:Boolean = false;
		public var _oneToManyTarget:String;
		public var _oneToManyMappedBy:String;

		// Populated by DUtilDCore.
		public var _javaField:String = StrConsts._CHAR_EMPTY_STRING;
		public var _javaType:String = StrConsts._CHAR_EMPTY_STRING;
		public var _solClassName:String = StrConsts._CHAR_EMPTY_STRING;

		// Populated by EntityBeanDescriptorsHandler.
		public var _parentEntityDescriptor:EntityDescriptor;
		public var _fkHolderForTarget:FieldDescriptorBean;
		public var _fkHolderForSourceDescriptor:FieldDescriptorBean;

		public function FieldDescriptorBean(object:Object=null)
		{
			if (object)
				fillMe(object);
		}

		public function fillMe(object:Object):void
		{
			if (object)
			{
				_index = object.index;
				_tabNavigatorIndex = object.tabNavigatorIndex;
				_length = object.length;
				_defaultValue = object.defaultValue;
				_acceptableValues = object.acceptableValues;
				_fieldNameFormatted = ServerVarsDecoder.replaceAllMessageDVars(object.fieldNameFormatted);
				_dataGridColumn = object.dataGridColumn;
				_dataGridColumnWidth = object.dataGridColumnWidth;
				_postLabel = object.postLabel;
				_solDescriptonField = object.solDescriptonField;
				_solAutoCompleteMode = object.solAutoCompleteMode;
				_solFieldsToSelectCSV = object.solFieldsToSelectCSV;
				_solDataGridColumnsCSV = object.solDataGridColumnsCSV;
				_solDataGridColumnsToRemoveCSV = object.solDataGridColumnsToRemoveCSV;
				_solDataGridColumnsManyToOneCSV = object.solDataGridColumnsManyToOneCSV;
				_solLikeDefaults = object.solLikeDefaults;
				_searchFieldFor = object.searchFieldFor;
				_fkHolderFor = object.fkHolderFor;
				_hierarchicalCodeIdField = object.hierarchicalCodeIdField;
				_hierarchicalCodeParentField = object.hierarchicalCodeParentField;
				_compositeIDFields = object.compositeIDFields;
				_customADGLabelFunction = object.customADGLabelFunction;
				_mask = object.mask;
				_imageField = object.imageField;
				_groupByThisField = DUtilBoolean.isTrue(object.groupByThisField);
				_manyToManyTarget = object.manyToManyTarget;
				_manyToManyTableName = object.manyToManyTableName;
				_manyToManyJoinColumnName = object.manyToManyJoinColumnName;
				_manyToManyInverseJoinColumnName = object.manyToManyInverseJoinColumnName;
				
				
				_requiredForSearch = object.requiredForSearch;
				_bypassRequiredFieldsForSearch = object.bypassRequiredFieldsForSearch;
				_minLengthForSearch = object.minLengthForSearch;
				
				
				_isMainID = object.isMainID;
				_isCodeField = object.isCodeField;
				_isDescriptionField = object.isDescriptionField;
				_isNullable = object.isNullable;
				_isReadonly = object.isReadonly;
				_isInsertable = object.isInsertable;
				_isUpdatable = object.isUpdatable;
				_isUnique = object.isUnique;
				_isDateField = object.isDateField;
				_isHourField = object.isHourField;
				_isTimestamp = object.isTimestamp;
				_isCEP = object.isCEP;
				_isCNPJ = object.isCNPJ;
				_isCPF = object.isCPF;
				_isGender = object.isGender;
				_isPasswordField = object.isPasswordField;
				_isPasswordEncrypted = object.isPasswordEncrypted;
				_isPhoneNumber = object.isPhoneNumber;
				_isRemarksField = object.isRemarksField;
				_isManyToOne = object.isManyToOne;
				_isManyToMany = object.isManyToMany;
				_isVersionField = object.isVersionField;
				_validateCEPNumber = object.validateCEPNumber;
				_validateCNPJNumber = object.validateCNPJNumber;
				_validateCPFNumber = object.validateCPFNumber;
				_validatePhoneNumber = object.validatePhoneNumber;

				_isOneToMany = object.isOneToMany;
				_oneToManyTarget = object.oneToManyTarget;
				_oneToManyMappedBy = object.oneToManyMappedBy;

				_javaField = object.javaField;
				_javaType = object.javaType;
				_solClassName = object.solClassName;
			}
			else
				throw new Error(" ### DBeanFieldDescriptor.fillMe: Objeto nulo.");
		}
	}
}
