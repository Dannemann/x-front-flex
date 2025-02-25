package br.com.dannemann.gui.controller
{
	import br.com.dannemann.gui.XFrontConfigurator;
	
	import mx.core.UIComponent;

	public final class DGUIServiceProxy
	{
		// Method names:

		public static const _getRegistry:String = "getRegistry";
		public static const _now:String = "now";
//		public static const _getAllDeployedDataSources:String = "getAllDeployedDataSources";
		public static const _searchCEPOnWebService:String = "searchCEPOnWebService";
		public static const _encrypt:String = "encrypt";
		public static const _getOnEnterpriseHomeFolder:String = "getOnEnterpriseHomeFolder";
		public static const _deleteOnEnterpriseHomeFolder:String = "deleteOnEnterpriseHomeFolder";

		// Complete method names:

//		public static function get __getRegistry():String
//		{
//			return DFxGUIParameters._webApplicationDFxDefaultService + "." + _getRegistry;
//		}

//		public static function get __now():String
//		{
//			return DFxGUIParameters._webApplicationDFxDefaultService + "." + _now;
//		}

//		public static function get __getAllDeployedDataSources():String
//		{
//			return DFxGUIParameters._webApplicationDFxDefaultService + "." + _getAllDeployedDataSources;
//		}

		public static function get __searchCEPOnWebService():String
		{
			return XFrontConfigurator._metaServiceDestination + "." + _searchCEPOnWebService;
		}

		public static function get __encrypt():String
		{
			return XFrontConfigurator._metaServiceDestination + "." + _encrypt;
		}

		public static function get __getOnEnterpriseHomeFolder():String
		{
			return XFrontConfigurator._metaServiceDestination + "." + _getOnEnterpriseHomeFolder;
		}

		public static function get __deleteOnEnterpriseHomeFolder():String
		{
			return XFrontConfigurator._metaServiceDestination + "." + _deleteOnEnterpriseHomeFolder;
		}

		// Calls with a new BlazeDS instance:

//		public static function getAllDeployedDataSources(callback:Function, caller:UIComponent=null):void
//		{
//			new BlazeDS().invoke(
//				__getAllDeployedDataSources,
//				null,
//				callback,
//				caller
//			);
//		}

		public static function getRegistry(application:String, callback:Function, caller:UIComponent=null):void
		{
			new BlazeDs().invoke3(
				XFrontConfigurator._metaServiceDestination,
				"getRegistry", // TODO: HARDCODED STRING.
				application,
				callback,
				caller
			);
		}

		public static function getOnEnterpriseHomeFolder(folder:String, callback:Function, file:String=null, caller:UIComponent=null):void
		{
			DSession.checkApplicationPathOnServer();
			DSession.checkEnterprise();

			new BlazeDs().invokeOld(
				__getOnEnterpriseHomeFolder,
				{
					applicationPathOnServer:DSession._applicationPathOnServer,
					enterprise:DSession._tenant,
					folder:folder,
					file:file
				},
				callback,
				caller);
		}

		//----------------------------------------------------------------------

		// TODO: Such a strange name for a method. Change this.
		public static function mountParams_deleteOnEnterpriseHomeFolder(folder:String, files:Array=null):Object
		{
			const params:Object = new Object();
			params.applicationPathOnServer = DSession._applicationPathOnServer;
			params.enterprise = DSession._tenant;
			params.folder = folder;
			params.files = files;
			return params;
		}
	}
}
