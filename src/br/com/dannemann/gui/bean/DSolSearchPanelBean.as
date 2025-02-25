package br.com.dannemann.gui.bean
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.component.input.DSelectOneListing;
	import br.com.dannemann.gui.controller.BlazeDs;
	import br.com.dannemann.gui.controller.EntityDescriptor;

	public final class DSolSearchPanelBean implements DIBean
	{
		public var _entityBeanDescriptorsHandler:EntityDescriptor;
		public var _columnsForHibernateSelectCSV:String = StrConsts._CHAR_ASTERISK;
		public var _solDataGridColumnsCSV:String;
		public var _solDataGridColumnsToRemoveCSV:String;
		public var _solDataGridColumnsManyToOneCSV:String;
		public var _solLikeDefaults:String;
		public var _dSelectOneListingParent:DSelectOneListing;
		public var _blazeDS:BlazeDs = new BlazeDs();

		public function fillMe(object:Object):void
		{
			if (object)
			{
				_entityBeanDescriptorsHandler = object.entityBeanDescriptorsHandler;
				_columnsForHibernateSelectCSV = object.columnsForHibernateSelectCSV;
				_solDataGridColumnsCSV = object.solDataGridColumnsCSV;
				_solDataGridColumnsToRemoveCSV = object.solDataGridColumnsToRemoveCSV;
				_solDataGridColumnsManyToOneCSV = object.solDataGridColumnsManyToOneCSV;
				_solLikeDefaults = object.solLikeDefaults;
				_dSelectOneListingParent = object.dSelectOneListingParent;
				_blazeDS = object.blazeDS;
			}
			else
				throw new Error(" ### DBeanDSelectOneListingSearchPanel.fillMe: Objeto nulo.");
		}
	}
}
