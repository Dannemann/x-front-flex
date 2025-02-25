package br.com.dannemann.gui.domain
{
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class Msgs
	{
		//----------------------------------------------------------------------
		// Fields:

		protected static const _RM_INSTANCE:IResourceManager = ResourceManager.getInstance();

		protected static const _RESOURCE_BUNDLE_NAME:String = "xfront_flex_locale";

		//----------------------------------------------------------------------
		// Public interface:

		public static function grab(key:String):String
		{
			return _RM_INSTANCE.getString(_RESOURCE_BUNDLE_NAME, key);
		}

		//----------------------------------------------------------------------
	}
}
