package br.com.dannemann.gui.dto
{
	import br.com.dannemann.gui.bean.DIBean;

	public dynamic class Request implements DIBean
	{
		//----------------------------------------------------------------------
		// Fields:

		public var tenant:String;
		public var object:Object;
		public var objectType:String;
		public var localeTag:String;

		//----------------------------------------------------------------------
		// Constructors:

		public function Request(obj:Object=null)
		{
			fillMe(obj);
		}

		//----------------------------------------------------------------------
		// DIBean implementations:

		public function fillMe(obj:Object):void
		{
			if (obj) {
				this.tenant = obj.enterprise;
				this.object = obj.entityBeanObject;
				this.objectType = obj.entityBeanClassName;
				this.localeTag = obj.localeTag;
			}
		}

		//----------------------------------------------------------------------
	}
}
