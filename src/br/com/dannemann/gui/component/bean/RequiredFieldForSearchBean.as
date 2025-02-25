package br.com.dannemann.gui.component.bean
{
	public class RequiredFieldForSearchBean
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Fields:
		
		/** The field name ("fullName" or "zipCode" for example). */
		private var fieldName:String;
		
		/** The formatted/human-readable version of the field name ("Full name" or "ZIP code" for example). */
		private var fieldNameFormatted:String;
		
		/** Whether this field is required for executing database searches. */
		private var requiredForSearch:Boolean;
		
		/** The mimimum length required for this field to execute a database search. */
		private var minLengthForSearch:Number;
		
		/** Whether this field can bypass the required fields for search. */
		private var bypassRequiredFieldsForSearch:Boolean;
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Public:
		
		public function validateMyData():void
		{
			if (!fieldName)
				throw new Error("FIELD NAME OBRIGATORIO NO REQUIRED FOR SEARCH"); // TODO: WORK ON THIS.
			else if (!fieldNameFormatted)
				throw new Error("FIELD NAME FORMATTED OBRIGATORIO NO REQUIRED FOR SEARCH"); // TODO: WORK ON THIS.
			else if (_requiredForSearch && _bypassRequiredFieldsForSearch)
				throw new Error("NAO PODE SER requiredForSearch && bypassRequiredFieldsForSearch.. DEU TRUE"); // TODO: WORK ON THIS.
			else if (!(_requiredForSearch || _minLengthForSearch || _bypassRequiredFieldsForSearch)) 
				throw new Error("TEM QUE INFORMAR PELO MENOS UM requiredForSearch || bypassRequiredFieldsForSearch || minLengthForSearch"); // TODO: WORK ON THIS.
		}
		
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Getters and setters:
		
		/**
		 * @copy #fieldName
		 */
		
		public function get _fieldName():String
		{
			return fieldName;
		}
		
		public function set _fieldName(value:String):void
		{
			if (!value)
				throw new Error("FIELD NAME OBRIGATORIO NO REQUIRED FOR SEARCH"); // TODO: WORK ON THIS.
			else
				fieldName = value;
		}
		
		/**
		 * @copy #fieldNameFormatted
		 */
		
		public function get _fieldNameFormatted():String
		{
			return fieldNameFormatted;
		}
		
		public function set _fieldNameFormatted(value:String):void
		{
			if (!value)
				throw new Error("FIELD NAME FORMATTED OBRIGATORIO NO REQUIRED FOR SEARCH"); // TODO: WORK ON THIS.
			else
				fieldNameFormatted = value;
		}
		
		/**
		 * @copy #requiredForSearch
		 */
		
		public function get _requiredForSearch():Boolean
		{
			return requiredForSearch;
		}
		
		public function set _requiredForSearch(value:Boolean):void
		{
			if (value && _bypassRequiredFieldsForSearch)
				throw new Error("NAO PODE SER requiredForSearch && bypassRequiredFieldsForSearch.. DEU TRUE"); // TODO: WORK ON THIS.
			else
				requiredForSearch = value;
		}
		
		/**
		 * @copy #minLengthForSearch
		 */
		
		public function get _minLengthForSearch():Number
		{
			return minLengthForSearch;
		}
		
		public function set _minLengthForSearch(value:Number):void
		{
			minLengthForSearch = value;
		}
		
		/**
		 * @copy #bypassRequiredFieldsForSearch
		 */
		
		public function get _bypassRequiredFieldsForSearch():Boolean
		{
			return bypassRequiredFieldsForSearch;
		}
		
		public function set _bypassRequiredFieldsForSearch(value:Boolean):void
		{
			if (value && _requiredForSearch)
				throw new Error("NAO PODE SER bypassRequiredFieldsForSearch && requiredForSearch.. DEU TRUE"); // TODO: WORK ON THIS.
			else
				bypassRequiredFieldsForSearch = value;
		}
		
		// -------------------------------------------------------------------------
	}
}
