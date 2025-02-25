package br.com.dannemann.gui.event
{
	import flash.events.Event;

	public final class DTextInputAutoCompleteEvent extends Event
	{
		public static const ON_CHANGE:String = "onChange";
		public static const ON_ENTER:String = "onEnter";
		public static const ON_SELECT:String = "onSelect";

		public var _selectedString:String;
		public var _currentWritedText:String;

		public function DTextInputAutoCompleteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles,cancelable);
		}
	}
}
