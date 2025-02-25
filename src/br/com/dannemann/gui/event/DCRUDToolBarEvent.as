package br.com.dannemann.gui.event
{
	import flash.events.Event;

	public final class DCRUDToolBarEvent extends Event
	{
		public static const _ON_AFTER_CHANGED_TO_MODE_INSERT:String = "onAfterChangedToModeInsert";

		public static const _ON_BEFORE_SEARCH:String = "onBeforeSearch";
		public static const _ON_AFTER_SEARCH:String = "onAfterSearch";
		public static const _ON_BEFORE_SEARCH_ALL:String = "onBeforeSearchAll";
		public static const _ON_AFTER_SEARCH_ALL:String = "onAfterSearchAll";
		public static const _ON_BEFORE_SAVE:String = "onBeforeSave";
		public static const _ON_AFTER_SAVE:String = "onAfterSave";
		public static const _ON_BEFORE_DELETE:String = "onBeforeDelete";
		public static const _ON_AFTER_DELETE:String = "onAfterDelete";

		public static const _ON_CHANGE_SELECTED_ITEM:String = "onChangeSelectedItem";

		public static const _ON_CHANGED_TO_SEARCH_MODE:String = "onChangedToSearchMode";
		public static const _ON_CHANGED_TO_INSERT_MODE:String = "onChangedToInsertMode";
		public static const _ON_CHANGED_TO_UPDATE_MODE:String = "onChangedToUpdateMode";

		public function DCRUDToolBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
