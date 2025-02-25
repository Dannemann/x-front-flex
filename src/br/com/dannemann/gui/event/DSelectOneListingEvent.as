package br.com.dannemann.gui.event
{
	import flash.events.Event;

	public final class DSelectOneListingEvent extends Event
	{
		public static const _ON_CHANGE:String = "onChange";

		public function DSelectOneListingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
