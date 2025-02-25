package br.com.dannemann.gui.event
{
	import flash.events.Event;

	public final class DFastSearcherEvent extends Event
	{
		public static const ON_SELECT:String = "onSelect";
		public static const ON_ENTER:String = "onEnter";

		public var _selectedString:String;
		public var _currentWritedText:String;

		public function DFastSearcherEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
