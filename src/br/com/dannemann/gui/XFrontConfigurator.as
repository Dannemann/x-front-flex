package br.com.dannemann.gui
{
	import flash.utils.Dictionary;
	
	import mx.utils.ObjectProxy;
	
	import br.com.dannemann.gui.controller.DGUIServiceProxy;
	import br.com.dannemann.gui.controller.DSession;
	import br.com.dannemann.gui.controller.EntityDescriptor;

	public final class XFrontConfigurator
	{
		public static var _applicationName:String;
		public static var _applicationURL:String;
		public static var _applicationResourceBundle:String;
		public static var _metaServiceDestination:String;
		public static var _crudServiceDestination:String;

		// CRUD methods.
		public static var _findByIdMethod:String = "findById";
		public static var _findByExampleMethod:String = "findByExample";
		public static var _findAllMethod:String = "findAll";
		public static var _saveMethod:String = "save";
		public static var _deleteMethod:String = "delete";
		public static var _executeMethod:String = "execute";
		
		public static const _eagerDataProvider:Dictionary = new Dictionary();
		
		
		
		
		
		// CRUD destinations.
		public static var _genericCRUDDestination:String;

		// CRUD methods overrides.
		public static var _selectByExampleMethod:String = "findByExample";
		public static var _selectAllMethod:String = "findAll";
		public static var _insertOrUpdateMethod:String = "save";

		public static function getPersistenceService():String {
			if (_genericCRUDDestination)
				return _genericCRUDDestination;
			else
				return null;
		}
		
		// TODO: This method on DSession.
		public static function preinitializeApplication(callback:Function=null):void
		{
			DGUIServiceProxy.getRegistry(
				_applicationName,
				function (applicationRegistry:ObjectProxy):void
				{
					const appRegistry:Object = applicationRegistry.valueOf();
					const applicationPathOnServer:String = appRegistry["applicationPathOnServer"];
					const dasEntitiesDescriptors:Object = appRegistry["dasEntitiesDescriptors"];
					const entitiesDescriptors:Object = appRegistry["entitiesDescriptors"];
					const fullyCachedEntities:Array = appRegistry["fullyCachedEntities"];

					var keysList:Vector.<String>;
					var keyListLength:int;
					var dasKeysList:Vector.<String>;
					var dasKeyListLength:int;
					var key:String;
					var i:int;

					// Application path on server.

					DSession._applicationPathOnServer = applicationPathOnServer;

					// Entities descriptors.

					dasKeysList = new Vector.<String>();
					for (key in dasEntitiesDescriptors)
						dasKeysList.push(key);
					dasKeysList.sort(Array.CASEINSENSITIVE);
					dasKeyListLength = dasKeysList.length;

					keysList = new Vector.<String>();
					for (key in entitiesDescriptors)
						keysList.push(key);
					keysList.sort(Array.CASEINSENSITIVE);
					keyListLength = keysList.length;

					const sortedDescriptorsArray:Array = [];
					const dasSortedDescriptorsArray:Array = [];
					var className:String;
					var entityBeanDescriptorsHandler:EntityDescriptor;

					for (i = 0; i < dasKeyListLength; i++)
					{
						className = dasKeysList[i];
						entityBeanDescriptorsHandler = new EntityDescriptor(dasEntitiesDescriptors[className]);
						dasSortedDescriptorsArray.push(entityBeanDescriptorsHandler);
						dasSortedDescriptorsArray[className] = entityBeanDescriptorsHandler;
					}

					for (i = 0; i < keyListLength; i++)
					{
						className = keysList[i];
						entityBeanDescriptorsHandler = new EntityDescriptor(entitiesDescriptors[className]);
						sortedDescriptorsArray.push(entityBeanDescriptorsHandler);
						sortedDescriptorsArray[className] = entityBeanDescriptorsHandler;
					}

					DSession._dasEntitiesDescriptors = dasSortedDescriptorsArray;
					DSession._entitiesDescriptors = sortedDescriptorsArray;

					// Cached entities.

					DSession._fullyCachedDataProviders = new Object();

					if (fullyCachedEntities)
					{
						const fullyCachedEntitiesLength:int = fullyCachedEntities.length;
						for (i = 0; i < fullyCachedEntitiesLength; i++)
							DSession._fullyCachedDataProviders[fullyCachedEntities[i]] = null;
					}

					if (callback != null)
						callback();
				}
			);
		}
	}
}
