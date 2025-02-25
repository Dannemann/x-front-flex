package br.com.dannemann.gui.controller
{
	import br.com.dannemann.gui.bean.DBeanCRUDDescriptor;
	import br.com.dannemann.gui.bean.FieldDescriptorBean;
	import br.com.dannemann.gui.domain.StrConsts;

	public final class EntityDescriptor
	{
		// -------------------------------------------------------------------------
		// Fields:
		
		public const _fields:Array = new Array(); // All field descriptors goes here. They are stored as list AND as dictionary using the field name as key.
		public const _domainFields:Vector.<FieldDescriptorBean> = new Vector.<FieldDescriptorBean>(); // Holds domain fields like "name", "phone", "productName" and etc (no control fields like "id" or "version").
		
		public var _requiredFieldsForSearch:Vector.<FieldDescriptorBean>; // Fields that must be informed in order to fetch the database.
		
		public var _codeField:FieldDescriptorBean; // The general entity code field descriptor.
		public var _descriptionField:FieldDescriptorBean; // The general entity description field descriptor.
		
		
		
		
		
		
		public var _crudDescriptor:DBeanCRUDDescriptor;

		// One per class field descriptors:

		public var _fieldDescriptorID:FieldDescriptorBean;
		public var _fieldDescriptorFKHolderFor:FieldDescriptorBean;
		public var _fieldDescriptorHierarchicalCode:FieldDescriptorBean;
		public var _fieldDescriptorRemarks:FieldDescriptorBean;
		public var _fieldDescriptorVersion:FieldDescriptorBean;

		// Grouped field descriptors.

		public var _groupByFieldDescriptors:Vector.<FieldDescriptorBean>;
		public var _oneToManyFieldDescriptors:Vector.<FieldDescriptorBean>;
		public var _manyToOneFieldDescriptors:Vector.<FieldDescriptorBean>;
		public var _manyToManyFieldDescriptors:Vector.<FieldDescriptorBean>;
		public var _searchFieldsFieldDescriptors:Object;
		public var _notInsertableInputs:Vector.<FieldDescriptorBean>;
		public var _notUpdatableInputs:Vector.<FieldDescriptorBean>;
		public var _dateInputs:Vector.<FieldDescriptorBean>;
		public var _imageFields:Vector.<FieldDescriptorBean>;
		
		

		//----------------------------------------------------------------------
		// Constructor:

		public function EntityDescriptor(descriptors:Array)
		{
			var descriptor:Object = null;
			var fieldDescriptorBean:FieldDescriptorBean = null;
			var i:int;

			const fieldsDescriptorsArrayLength:int = descriptors.length;
			for (i = 0; i < fieldsDescriptorsArrayLength; i++)
			{
				descriptor = descriptors[i];

				if (descriptor.isCRUDDescriptor)
					_crudDescriptor = new DBeanCRUDDescriptor(descriptor);
				else if (descriptor.isFieldDescriptor)
				{
					fieldDescriptorBean = new FieldDescriptorBean(descriptor);
					fieldDescriptorBean._parentEntityDescriptor = this;

					// All field descriptors goes here.
					_fields.push(fieldDescriptorBean);
					_fields[fieldDescriptorBean._javaField] = fieldDescriptorBean;

					// Gets the domain related field descritors (like "name", "phone", "productName" and etc).
					if (!(
						fieldDescriptorBean._fkHolderFor ||
						fieldDescriptorBean._imageField ||
						fieldDescriptorBean._isPasswordEncrypted ||
						fieldDescriptorBean._isPasswordField ||
						fieldDescriptorBean._isVersionField ||
						fieldDescriptorBean._isOneToMany ||
//						dBeanFieldDescriptor._isManyToMany || // TODO: REMOVE THIS?
						fieldDescriptorBean._searchFieldFor
					))
						_domainFields.push(fieldDescriptorBean);

					// Get the description/code field.
					if (fieldDescriptorBean._isDescriptionField && fieldDescriptorBean._isCodeField)
						throw new Error("NAO PODE SER DESCRIPTIO E CODE JUNTOS");
					else if (fieldDescriptorBean._isCodeField)
						_codeField = fieldDescriptorBean;
					else if (fieldDescriptorBean._isDescriptionField)
						_descriptionField = fieldDescriptorBean;

					// Whether the field is required for search.
					if (fieldDescriptorBean._requiredForSearch || fieldDescriptorBean._minLengthForSearch || fieldDescriptorBean._bypassRequiredFieldsForSearch)
					{
						if (!_requiredFieldsForSearch)
							_requiredFieldsForSearch = new Vector.<FieldDescriptorBean>();

						_requiredFieldsForSearch.push(fieldDescriptorBean);
					}

					if (fieldDescriptorBean._groupByThisField)
					{
						if (!_groupByFieldDescriptors)
							_groupByFieldDescriptors = new Vector.<FieldDescriptorBean>();

						_groupByFieldDescriptors.push(fieldDescriptorBean);
					}

					if (!fieldDescriptorBean._isInsertable)
					{
						if (!_notInsertableInputs)
							_notInsertableInputs = new Vector.<FieldDescriptorBean>();

						_notInsertableInputs.push(fieldDescriptorBean);
					}

					if (!fieldDescriptorBean._isUpdatable)
					{
						if (!_notUpdatableInputs)
							_notUpdatableInputs = new Vector.<FieldDescriptorBean>();

						_notUpdatableInputs.push(fieldDescriptorBean);
					}

					if (fieldDescriptorBean._isManyToOne)
					{
						if (!_manyToOneFieldDescriptors)
							_manyToOneFieldDescriptors = new Vector.<FieldDescriptorBean>();

						_manyToOneFieldDescriptors.push(fieldDescriptorBean);
					}
					else if (fieldDescriptorBean._searchFieldFor)
					{
						if (!_searchFieldsFieldDescriptors)
							_searchFieldsFieldDescriptors = new Object();

						_searchFieldsFieldDescriptors[fieldDescriptorBean._searchFieldFor] = fieldDescriptorBean;
					}
					else if (fieldDescriptorBean._isDateField)
					{
						if (!_dateInputs)
							_dateInputs = new Vector.<FieldDescriptorBean>();

						_dateInputs.push(fieldDescriptorBean);
					}
					else if (fieldDescriptorBean._imageField)
					{
						if (!_imageFields)
							_imageFields = new Vector.<FieldDescriptorBean>();

						_imageFields.push(fieldDescriptorBean);
					}
					else if (fieldDescriptorBean._isOneToMany)
					{
						if (!_oneToManyFieldDescriptors)
							_oneToManyFieldDescriptors = new Vector.<FieldDescriptorBean>();

						_oneToManyFieldDescriptors.push(fieldDescriptorBean);
					}
					else if (fieldDescriptorBean._isManyToMany)
					{
						if (!_manyToManyFieldDescriptors)
							_manyToManyFieldDescriptors = new Vector.<FieldDescriptorBean>();

						_manyToManyFieldDescriptors.push(fieldDescriptorBean);
					}
					else if (fieldDescriptorBean._fkHolderFor)
						_fieldDescriptorFKHolderFor = fieldDescriptorBean;
					else if (fieldDescriptorBean._hierarchicalCodeIdField && fieldDescriptorBean._hierarchicalCodeParentField)
						_fieldDescriptorHierarchicalCode = fieldDescriptorBean;
					else if (fieldDescriptorBean._isVersionField)
						_fieldDescriptorVersion = fieldDescriptorBean;
					else if (fieldDescriptorBean._isMainID)
						_fieldDescriptorID = fieldDescriptorBean;
					else if (fieldDescriptorBean._isRemarksField)
						_fieldDescriptorRemarks = fieldDescriptorBean;
				}
			}

			if (_fieldDescriptorFKHolderFor)
			{
				const targetFieldDescriptor:FieldDescriptorBean = getFKHolderTargetFieldDescriptor(_fieldDescriptorFKHolderFor);
				targetFieldDescriptor._fkHolderForSourceDescriptor = _fieldDescriptorFKHolderFor;
				_fieldDescriptorFKHolderFor._fkHolderForTarget = targetFieldDescriptor;
			}
		}

		//----------------------------------------------------------------------
		// Public interface:

		public function getFieldDescriptorByJavaField(javaField:String):FieldDescriptorBean
		{
			const fieldDescriptorsLength:int = _fields.length;
			for (var i:int = 0; i < fieldDescriptorsLength; i++)
				if (_fields[i]._javaField == javaField)
					return _fields[i];

			return null;
		}

		public function getManyToOneJavaFieldsOnCSVStr():String
		{
			if (_manyToOneFieldDescriptors)
			{
				const manyToOneJavaFields:Vector.<String> = new Vector.<String>();

				const manyToOneFieldsDescriptorsLength:int = _manyToOneFieldDescriptors.length;
				for (var i:int = 0; i < manyToOneFieldsDescriptorsLength; i++)
					manyToOneJavaFields.push(_manyToOneFieldDescriptors[i]._javaField);

				return manyToOneJavaFields.join(StrConsts._CHAR_COMMA);
			}
			else
				return null;
		}

		public function getFKHolderTargetFieldDescriptor(fkHolderDescriptor:FieldDescriptorBean, descriptors:Array=null):FieldDescriptorBean
		{
			const fkHolderJavaField:String = fkHolderDescriptor._fkHolderFor;
			var i:int;

			if (descriptors)
			{
				const descriptorsLength:int = descriptors.length;
				for (i = 0; i < descriptorsLength; i++)
					if (descriptors[i].javaField == fkHolderJavaField)
						return new FieldDescriptorBean(descriptors[i]);

				return null;
			}
			else
			{
				if (_manyToOneFieldDescriptors)
				{
					const manyToOneFieldsDescriptorsLength:int = _manyToOneFieldDescriptors.length;
					for (i = 0; i < manyToOneFieldsDescriptorsLength; i++)
						if (_manyToOneFieldDescriptors[i]._javaField == fkHolderJavaField)
							return _manyToOneFieldDescriptors[i];

					return null;
				}
				else
					return null;
			}
		}
		
		//----------------------------------------------------------------------
	}
}
