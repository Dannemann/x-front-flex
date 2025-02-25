package br.com.dannemann.gui.controller
{
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import br.com.dannemann.gui.bean.DBeanBlazeDS;

	public dynamic final class DBlazeDSRemoteObject extends RemoteObject
	{
		public var _dBeanBlazeDS:DBeanBlazeDS;

		public function DBlazeDSRemoteObject(destination:String=null)
		{
			super(destination);
		}
	}
}
