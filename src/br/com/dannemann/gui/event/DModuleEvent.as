package br.com.dannemann.gui.event
{
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;

	public final class DModuleEvent extends ModuleEvent
	{
		public var _executeAfterModuleLoaded:Function;

		public function DModuleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, bytesLoaded:uint=0, bytesTotal:uint=0, errorText:String=null, module:IModuleInfo=null)
		{
			super(type, bubbles, cancelable, bytesLoaded, bytesTotal, errorText, module);
		}
	}
}
