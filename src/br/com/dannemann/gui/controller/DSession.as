package br.com.dannemann.gui.controller
{
	import br.com.dannemann.gui.domain.StrConsts;

	public final class DSession
	{
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// -------------------------------------------------------------------------
		// Fields:

		private static var tenant:String;
		public static var _localeTag:String;
		
		
		
		public static var _id:String; // TODO: ONLY WORKING WITH SINGLE ID USERS.
		public static var _username:String;
		
		
		
		
		public static var _dasEntitiesDescriptors:Array;
		public static var _entitiesDescriptors:Array;
		public static var _fullyCachedDataProviders:Object;

		
		
		public static var _root:Boolean;

		public static var _applicationDomain:String
		public static var _applicationPathOnServer:String;

		public static const _dCRUDFormCache:Object = new Object();
		public static const _imageCache:Object = new Object();
		public static const _imageByteArrayCache:Object = new Object();

		// -------------------------------------------------------------------------
		// Populate me:

		// TODO: CHANGE THE PARAMETERS ORDER.
		public static function populate1(id:String, username:String, tenant:String, applicationDomain:String):void
		{
			_id = id;
			_username = username;
			DSession.tenant = tenant;
			_applicationDomain = applicationDomain;
		}
		
		public static function populate2(tenant:String, id:String, username:String, applicationDomain:String, localeTag:String="en_US"):void
		{
			DSession.tenant = tenant;
			_id = id;
			_username = username;
			_localeTag = localeTag;
		}
		
		// -------------------------------------------------------------------------
		// Features:
		
		public static function get _tenant():String
		{
			return tenant;
		}

		
		
		
		
		
		
		
		
		
		// -------------------------------------------------------------------------
		// Server paths related:

		public static function getEnterpriseFolderURL():String
		{
			if (_root)
				return _applicationDomain + StrConsts._STR_enterprise_WITH_SLASHES;
			else
				return _applicationDomain + StrConsts._STR_enterprise_WITH_SLASHES + DSession._tenant + StrConsts._CHAR_FORWARD_SLASH;
		}

		public static function getEnterpriseFolderPhysicalPath():String
		{
			if (_root)
				return _applicationPathOnServer + StrConsts._STR_enterprise_WITH_SLASHES;
			else
				return _applicationPathOnServer + StrConsts._STR_enterprise_WITH_SLASHES + DSession._tenant + StrConsts._CHAR_FORWARD_SLASH;
		}

		// -------------------------------------------------------------------------
		// Checkers:

		public static function checkApplicationDomain():void
		{
			if (!_applicationDomain)
				throw new Error(StrConsts.getRMString2("500222"));
		}

		public static function checkApplicationPathOnServer():void
		{
			if (!_applicationPathOnServer)
				throw new Error(StrConsts.getRMString2("500221"));
		}

		public static function checkEnterprise():void
		{
			if (!_tenant)
				throw new Error(StrConsts.getRMString2("500220"));
		}

		// -------------------------------------------------------------------------
		// Generic public methods:

		public static function getEntityDescriptor(entityCompleteName:String):EntityDescriptor
		{
			if (entityCompleteName.indexOf("br.com.dannemann.das") == 0)
			{
				if (_dasEntitiesDescriptors)
					return _dasEntitiesDescriptors[entityCompleteName];
			}
			else
			{
				if (_entitiesDescriptors)
					return _entitiesDescriptors[entityCompleteName];
			}

			return null;
		}

		public static function signOut():void
		{
			DSession.tenant = null;
			_localeTag = null;
			_id = null;
			_username = null;
			_applicationDomain = null;
			_applicationPathOnServer = null;
			_root = false;
		}
		
		// -------------------------------------------------------------------------
	}
}
