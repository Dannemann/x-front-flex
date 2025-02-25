package br.com.dannemann.gui.component.adg.filter
{
	import br.com.dannemann.gui.component.adg.DADGColumn;
	import br.com.dannemann.gui.util.DUtilWildcard;

	public class DADGColumnFilterBase
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		public var _column:DADGColumn;

		protected var searchString:String;
		protected var searchExpression:RegExp;

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Constructor:

		public function DADGColumnFilterBase(column:DADGColumn)
		{
			_column = column;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Abstractions:

		public /*abstract*/ function filterFunction(obj:Object):Boolean
		{
			return true;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Public interface:

		// Getters and setters:

		public function get _searchString():String
		{
			return searchString;
		}

		public function set _searchString(value:String):void
		{
			if (value)
			{
				searchString = value;
				searchExpression = DUtilWildcard.wildcardToRegExp(value);
			}
			else
			{
				searchString = null;
				searchExpression = null;
			}
		}

		public function get _searchExpression():RegExp
		{
			return searchExpression;
		}

		public function get _isActive():Boolean
		{
			if (searchExpression)
				return true;
			else
				return false;
		}

		//----------------------------------------------------------------------
	}
}
