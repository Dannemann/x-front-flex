package br.com.dannemann.gui.event
{
	import flash.events.Event;

	public final class DLoadEvent extends Event
	{
		public static const _ON_LOADING:String = "onLoading";
		public static const _ON_LOADED:String = "onLoaded";
		public static const _ON_LOAD_IO_ERROR:String = "onLoadIOError";
		public static const _ON_LOAD_SECURITY_ERROR:String = "onLoadSecurityError";

		// TODO: Isso deve ficar em outra classe.
		public static const _ON_EXCLUDING:String = "onExcluding";
		public static const _ON_EXCLUDED:String = "onExcluded";

		public function DLoadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
