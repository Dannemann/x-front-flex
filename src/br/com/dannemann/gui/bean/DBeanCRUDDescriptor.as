package br.com.dannemann.gui.bean
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.util.DUtilStringTransformer;

	public final class DBeanCRUDDescriptor implements DIBean
	{
		public var _classNameFormatted:String;
		public var _menuNode:String;
		public var _menuIcon:String;
		public var _useButtonSearch:Boolean = true;
		public var _useButtonSearchAll:Boolean = true;
		public var _useButtonInsertNewRow:Boolean = true;
		public var _useButtonSaveOrUpdate:Boolean = true;
		public var _useButtonExclude:Boolean = true;
		public var _numberOfGridColumnsOnForm:uint = 2;
		public var _tabs:String = StrConsts._CHAR_EMPTY_STRING;
		public var _usingAddressForm:String = StrConsts._CHAR_EMPTY_STRING;
		public var _fileUploaders:Array;
		public var _fileUploadersMap:Object;
		public var _dataGridColumns:String = StrConsts._CHAR_ASTERISK;
		public var _executeAfterSave:String = StrConsts._CHAR_EMPTY_STRING;
		public var _searchAllOnOpen:Boolean;
		public var _cachedCRUDForm:Boolean;
		public var _customCRUDForm:String = StrConsts._CHAR_EMPTY_STRING;
		public var _manyToManyAssocTable:Boolean;

		public var _tableName:String;
		public var _className:String;
		public var _classSimpleName:String

		public function DBeanCRUDDescriptor(object:Object=null)
		{
			if (object)
				fillMe(object);
		}

		public function fillMe(object:Object):void
		{
			if (object)
			{
				_classNameFormatted = object.classNameFormatted;
				_menuNode = object.menuNode;
				_menuIcon = object.menuIcon;
				_useButtonSearch = object.useButtonSearch;
				_useButtonSearchAll = object.useButtonSearchAll;
				_useButtonInsertNewRow = object.useButtonInsertNewRow;
				_useButtonSaveOrUpdate = object.useButtonSaveOrUpdate;
				_useButtonExclude = object.useButtonExclude;
				_numberOfGridColumnsOnForm = object.numberOfGridColumnsOnForm;
				_tabs = object.tabs;
				_usingAddressForm = object.usingAddressForm;

				if (object.fileUploaders)
				{
					const entries:Vector.<Object> = DUtilStringTransformer.transformation1IntoVector(object.fileUploaders);
					const numberOfEntries:int = entries.length;
					var newDBeanFileUploader:DBeanFileUploader;
					_fileUploaders = [];
					_fileUploadersMap = new Object();
					for (var i:int = 0; i < numberOfEntries; i++)
					{
						newDBeanFileUploader = new DBeanFileUploader(entries[i]);
						_fileUploaders.push(newDBeanFileUploader);
						_fileUploadersMap[newDBeanFileUploader._id] = newDBeanFileUploader;
					}
				}

				_dataGridColumns = object.dataGridColumns;
				_executeAfterSave = object.executeAfterSave;
				_searchAllOnOpen = object.searchAllOnOpen;
				_cachedCRUDForm = object.cachedCRUDForm;
				_customCRUDForm = object.customCRUDForm;
				_manyToManyAssocTable = object.manyToManyAssocTable;

				_tableName = object.tableName;
				_className = object.className;
				_classSimpleName = object.classSimpleName;
			}
			else
				throw new Error(" ### DBeanCRUDDescriptor.fillMe: Objeto nulo.");
		}
	}
}
