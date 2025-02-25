package br.com.dannemann.gui.dto.persistence
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.dto.Request;

	public dynamic class Request extends br.com.dannemann.gui.dto.Request
	{
		//----------------------------------------------------------------------
		// Fields:
		
		// IMPORTANT: Do not add an underscore at the beginning of the properties contained in the Java version of the Request object.
		//			  We need to keep the original names for the object deserialization.

		public var id:String;
		public var query:String;

		
		
		
		
		
		// Main:
		public var _applicationName:String;

		public var _manyToOneEagerColumnsCSV:String;

		// Relative to save.
		public var _hierarchicalCodeIdField:String;
		public var _hierarchicalCodeLineageField:String;
		public var _hierarchicalRootNode:Boolean;
		public var _fileUploaders:Array;
		public var _sql:String;

		public var _idJavaType:String;
		public var _columnsForHibernateSelectCSV:String = StrConsts._CHAR_ASTERISK;
		public var _whereField:String;
		public var _whereValueToCompare:String;
		public var _whereMatchMode:String;
		public var _orderBy:String;
		public var _invokeGetOnResult:String;

		// Listeners.
		public var _executeAfterSave:String;

		//----------------------------------------------------------------------
		// Constructors:

		public function Request(obj:Object=null)
		{
			super(obj);

			fillMe(obj);
		}

		//----------------------------------------------------------------------
		// DIBean implementations:

		public override function fillMe(obj:Object):void
		{
			if (obj)
			{
				this.id = obj.id;
				
				_applicationName = obj.applicationName;

				_manyToOneEagerColumnsCSV = obj.manyToOneEagerColumnsCSV;

				_hierarchicalCodeIdField = obj.hierarchicalCodeIdField;
				_hierarchicalCodeLineageField = obj.hierarchicalCodeLineageField;
				_hierarchicalRootNode = obj.hierarchicalRootNode;
				_fileUploaders = obj.fileUploaders;
				_sql = obj.sql;

				query = obj.hql;
				
				_idJavaType = obj.idJavaType;
				_columnsForHibernateSelectCSV = obj.columnsForHibernateSelectCSV ? obj.columnsForHibernateSelectCSV : StrConsts._CHAR_ASTERISK;
				_whereField = obj.whereField;
				_whereValueToCompare = obj.whereValueToCompare;
				_whereMatchMode = obj.whereMatchMode;
				_orderBy = obj.orderBy;
				_invokeGetOnResult = obj.invokeGetOnResult;

				_executeAfterSave = obj.executeAfterSave;
			}
		}

		//----------------------------------------------------------------------
	}
}
