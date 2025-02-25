package br.com.dannemann.gui.bean
{
	import mx.core.UIComponent;

	public final class DBeanBlazeDS implements DIBean
	{
		public var _pkgClassMethod:String;
		public var _parameters:Object;
		public var _caller:UIComponent;
		public var _callbackSucess:Function
		public var _callbackFault:Function;
		public var _disableCaller:Boolean = true;

		public function DBeanBlazeDS(object:Object=null)
		{
			if (object)
				fillMe(object);
		}

		public function fillMe(object:Object):void
		{
			if (object)
			{
				_pkgClassMethod = object.pkgClassMethod;
				_parameters = object.parameters;
				_caller = object.caller;
				_callbackSucess = object.callbackSucess;
				_callbackFault = object.callbackFault;
				_disableCaller = object.disableCaller;
			}
			else
				throw new Error(" ### DBeanBlazeDS.fillMe: Objeto nulo.");
		}
	}
}
