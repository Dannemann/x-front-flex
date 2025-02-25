package br.com.dannemann.gui.bean
{
	import br.com.dannemann.gui.controller.ServerVarsDecoder;

	public final class DBeanFileUploader implements DIBean
	{
		public var _id:String;
		public var _title:String;
		public var _destination:String;

		public function DBeanFileUploader(object:Object=null)
		{
			if (object)
				fillMe(object);
		}

		public function fillMe(object:Object):void
		{
			if (object)
			{
				_id = object.id;
				_title = ServerVarsDecoder.replaceAllMessageDVars(object.title);
				_destination = object.destination;
			}
			else
				throw new Error(" ### DBeanFileUploader.fillMe: Null object.");
		}
	}
}
