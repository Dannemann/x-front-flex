package br.com.dannemann.gui.event
{
	import br.com.dannemann.gui.component.DMDIWindowNavigatorButton;

	import flash.events.Event;

	public final class DMDIWindowNavigatorEvent extends Event
	{
		public static const _ON_CLICK:String = "onClick";

		public var _pressedButton:DMDIWindowNavigatorButton;

		public function DMDIWindowNavigatorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, pressedButton:DMDIWindowNavigatorButton=null)
		{
			super(type, bubbles, cancelable);
			_pressedButton = pressedButton;
		}
	}
}
