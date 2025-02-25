package br.com.dannemann.gui.event
{
	import flash.events.Event;

	public final class DADGToolBarEvent extends Event
	{
		public static const _ON_CHANGING_TO_TREE_MODE:String = "onChangingToTreeMode";
		public static const _ON_EXIT_TREE_MODE:String = "onExitTreeMode";

		public function DADGToolBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
