package br.com.dannemann.gui.component.container
{
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import mx.containers.Canvas;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	
	import spark.components.Application;
	import spark.components.HGroup;
	import spark.layouts.HorizontalAlign;
	
	import br.com.dannemann.gui.bean.DBeanCRUDDescriptor;
	import br.com.dannemann.gui.bean.DBeanMenu;
	import br.com.dannemann.gui.component.DMDIWindowNavigator;
	import br.com.dannemann.gui.component.DNotificator;
	import br.com.dannemann.gui.component.DSimpleMemoryGraph;
	import br.com.dannemann.gui.component.container.mdi.containers.MDIWindow;
	import br.com.dannemann.gui.component.container.mdi.effects.effectsLib.MDIVistaEffects;
	import br.com.dannemann.gui.component.container.mdi.events.MDIWindowEvent;
	import br.com.dannemann.gui.component.container.mdi.managers.MDIManager;
	import br.com.dannemann.gui.component.input.complex.DCRUDForm;
	import br.com.dannemann.gui.controller.DSession;
	import br.com.dannemann.gui.controller.EntityDescriptor;
	import br.com.dannemann.gui.controller.ServerVarsDecoder;
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.effect.DEffectFadeIn1;
	import br.com.dannemann.gui.effect.DEffectFadeOut1;
	import br.com.dannemann.gui.library.DIconLibrary;
	import br.com.dannemann.gui.util.DUtilComponent;
	import br.com.dannemann.gui.util.DUtilFocus;
	import br.com.dannemann.gui.util.DUtilKeyBoardShortcut;

	[ResourceBundle("xfront_flex_locale")]

	public class DApplication extends Application implements DContainer
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		public const _openedModulesAndMDIWindows:Object = new Object(); // TODO: USAR APENAS "_openedModulesAndMDIWindows" OU "_dMDIWindowNavigatorWindowDict"!!!

		// Memory manager:

		public var _memoryManagerWrapper:HGroup;

		// MDIWindow navigator:

		public const _dMDIWindowNavigator:DMDIWindowNavigator = new DMDIWindowNavigator();
		public const _dMDIWindowNavigatorWindowDict:Dictionary = new Dictionary(); // TODO: USAR APENAS "_openedModulesAndMDIWindows" OU "_dMDIWindowNavigatorWindowDict"!!!

		private const _dMDIWindowNavigatorFadeInEffect:DEffectFadeIn1 = new DEffectFadeIn1();
		private const _dMDIWindowNavigatorFadeOutEffect:DEffectFadeOut1 = new DEffectFadeOut1();

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		//----------------------------------------------------------------------
		// Class Overrides:

		override protected function createChildren():void
		{
			super.createChildren();

			_dMDIWindowNavigatorFadeInEffect.alphaFrom = 0;
			_dMDIWindowNavigatorFadeInEffect.alphaTo = .3;
			_dMDIWindowNavigatorFadeOutEffect.alphaFrom = .3;
			_dMDIWindowNavigatorFadeOutEffect.alphaTo = 0;

			MDIManager.global.effects = new MDIVistaEffects();
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Public interface:

		public function loadModule(beanMDIWinModule:DBeanMenu):void
		{
			if (!beanMDIWinModule._swf)
				DNotificator.showError2(" ### DApplication.loadModule(): Não foi informado um módulo SWF a ser carregado. Contate o suporte técnico!");

			// TODO: Será que o módulo vai parar de aparecer transparente porque eu estou passando o moduleFactory?
			// TODO: Será que faz manter uma referência para a aplicaçãoe assim não ser coletado pelo GC?
			const moduleInfo:IModuleInfo = ModuleManager.getModule(beanMDIWinModule._swf);
			moduleInfo.data = beanMDIWinModule;
			moduleInfo.addEventListener(ModuleEvent.READY, onModuleLoaded);
			moduleInfo.addEventListener(ModuleEvent.ERROR, onModuleError);

			_openedModulesAndMDIWindows[beanMDIWinModule._swf] = moduleInfo;

			moduleInfo.load(new ApplicationDomain(ApplicationDomain.currentDomain), null, null, moduleFactory);
		}

		public function addMDIWindow(dBeanMenu:DBeanMenu):void
		{
			if (_openedModulesAndMDIWindows.hasOwnProperty(dBeanMenu._swf))
			{
				const focusOnExistingWindow:Function = function callback(item:MDIWindow, index:int, array:Array):Boolean
				{
					if (item.id == this)
					{
						bringMDIWindowToFront(item, false);
						return true;
					}

					return false;
				}

				MDIManager.global.windowList.some(focusOnExistingWindow, dBeanMenu._swf);
			}
			else
			{
				if (dBeanMenu._entityBeanClassName)
				{
					const crudDescriptor:DBeanCRUDDescriptor = dBeanMenu._entityBeanDescriptorsHandler._crudDescriptor;

					const mdiWindow:MDIWindow = createDefaultMDIWindow(dBeanMenu);
					mdiWindow.id = dBeanMenu._entityBeanClassName;
					mdiWindow.width = 810;
					mdiWindow.height = 650;
					mdiWindow.horizontalScrollPolicy = ScrollPolicy.OFF;

					var dDCRUDForm:DCRUDForm;

					// TODO: Ligar cachê de telas por parâmetro do sistema.
//					if (DSession._dCRUDFormCache && crudDescriptor._cachedCRUDForm && DSession._dCRUDFormCache.hasOwnProperty(crudDescriptor._className))
//						dDCRUDForm = DSession._dCRUDFormCache[crudDescriptor._className];
//					else
					{
						if (crudDescriptor._customCRUDForm)
							dDCRUDForm = new (getDefinitionByName(crudDescriptor._customCRUDForm) as Class)() as DCRUDForm;
						else
							dDCRUDForm = new DCRUDForm();

						dDCRUDForm._entityBeanDescriptorsHandler = dBeanMenu._entityBeanDescriptorsHandler;
						dDCRUDForm._mdiWindowParent = mdiWindow;
						dDCRUDForm.percentWidth = 100;
						dDCRUDForm.percentHeight = 100;

						if (DSession._dCRUDFormCache && crudDescriptor._cachedCRUDForm && (!DSession._dCRUDFormCache.hasOwnProperty(crudDescriptor._className)))
							DSession._dCRUDFormCache[crudDescriptor._className] = dDCRUDForm;
					}

					mdiWindow.addElement(dDCRUDForm);

					MDIManager.global.add(mdiWindow);

					_dMDIWindowNavigatorWindowDict[mdiWindow] = dBeanMenu;
					_openedModulesAndMDIWindows[mdiWindow.id] = mdiWindow;

					_dMDIWindowNavigator.updateNavigator();

					bringMDIWindowToFront(mdiWindow, false);
				}
				else
					loadModule(dBeanMenu);
			}
		}

		public function entityBeanDescriptorsHandlerToDBeanMenu(entityBeanDescriptorsHandler:EntityDescriptor):DBeanMenu
		{
			const dBeanMenu:DBeanMenu = new DBeanMenu();
			dBeanMenu._entityBeanClassName = entityBeanDescriptorsHandler._crudDescriptor._className;
			dBeanMenu._entityBeanDescriptorsHandler = entityBeanDescriptorsHandler;
			dBeanMenu.label = ServerVarsDecoder.replaceAllMessageDVars(entityBeanDescriptorsHandler._crudDescriptor._classNameFormatted);
			return dBeanMenu;
		}

		public function mountNewMenuDataProvider(entityBeanDescriptorsHandlers:Array, groupName:String, icon:Class=null):Array
		{
			const dBeanMenuRoot:DBeanMenu = new DBeanMenu();
			const numOfEntityBeanDescriptorsHandlers:int = entityBeanDescriptorsHandlers.length;
			const dBeanMenuMap:Object = new Object();
			var descriptorHandler:EntityDescriptor;
			var descriptorHandlerMenuNode:String;
			var dBeanMenu:DBeanMenu;
			var dBeanMenuParent:DBeanMenu;
			var nodeStr:String;
			var nodeStrNoVars:String;
			var splittedMenuNode:Array;
			var splittedMenuNodeLength:int;

			for (var i:int = 0; i < numOfEntityBeanDescriptorsHandlers; i++)
			{
				descriptorHandler = entityBeanDescriptorsHandlers[i];

				if (!descriptorHandler._crudDescriptor)
					continue;

				descriptorHandlerMenuNode = descriptorHandler._crudDescriptor._menuNode;

				if (descriptorHandlerMenuNode)
				{
					splittedMenuNode = descriptorHandlerMenuNode.split(StrConsts._CHAR_FORWARD_SLASH);
					splittedMenuNodeLength = splittedMenuNode.length;
					nodeStr = StrConsts._CHAR_EMPTY_STRING;
					nodeStrNoVars = StrConsts._CHAR_EMPTY_STRING;

					for (var j:int = 0; j < splittedMenuNodeLength; j++)
					{
						nodeStr = splittedMenuNode[j];
						nodeStrNoVars = ServerVarsDecoder.replaceAllMessageDVars(ServerVarsDecoder.removeAllNamedDVars(nodeStr));

						if (dBeanMenuMap[nodeStrNoVars])
							if ((dBeanMenuMap[nodeStrNoVars] as DBeanMenu).children)
							{
								dBeanMenuParent = dBeanMenuMap[nodeStrNoVars];

								if (ServerVarsDecoder.hasNamedDVarWithin(nodeStr, StrConsts._FLEX_STYLE_PROPERTY_ICON))
									dBeanMenuParent.icon = DIconLibrary[ServerVarsDecoder.getNamedDVarValue(nodeStr, StrConsts._FLEX_STYLE_PROPERTY_ICON)];

								continue;
							}

						dBeanMenu = new DBeanMenu();

						if (ServerVarsDecoder.hasNamedDVarWithin(nodeStr, StrConsts._FLEX_STYLE_PROPERTY_ICON))
						{
							dBeanMenu.icon = DIconLibrary[ServerVarsDecoder.getNamedDVarValue(nodeStr, StrConsts._FLEX_STYLE_PROPERTY_ICON)];
							nodeStr = ServerVarsDecoder.removeNamedDVar(nodeStr, StrConsts._FLEX_STYLE_PROPERTY_ICON);
						}

						dBeanMenu.label = nodeStrNoVars;

						if (!dBeanMenuParent)
						{
							dBeanMenu._parent = dBeanMenuRoot;
							dBeanMenuParent = dBeanMenu;

							if (dBeanMenuRoot.children)
								dBeanMenuRoot.children.push(dBeanMenu);
							else
								dBeanMenuRoot.children = [ dBeanMenu ];
						}
						else
							if (!dBeanMenuParent.children)
							{
								dBeanMenu._parent = dBeanMenuParent;
								dBeanMenuParent.children = [ dBeanMenu ];
								dBeanMenuParent = dBeanMenu;
							}
							else
							{
								dBeanMenu._parent = dBeanMenuParent;
								dBeanMenuParent.children.push(dBeanMenu);
								dBeanMenuParent = dBeanMenu;
							}

						dBeanMenuMap[nodeStrNoVars] = dBeanMenu;
					} // End of: for (var j:int = 0; j < splittedMenuNodeLength; j++).
				}

				dBeanMenu = new DBeanMenu();
				dBeanMenu._entityBeanClassName = descriptorHandler._crudDescriptor._className;
				dBeanMenu._entityBeanDescriptorsHandler = descriptorHandler;
				dBeanMenu.label = ServerVarsDecoder.replaceAllMessageDVars(descriptorHandler._crudDescriptor._classNameFormatted);

				if (descriptorHandler._crudDescriptor._menuIcon)
					dBeanMenu.icon = DIconLibrary[descriptorHandler._crudDescriptor._menuIcon];

				if (dBeanMenuParent)
				{
					if (dBeanMenuParent.children)
						dBeanMenuParent.children.push(dBeanMenu);
					else
						dBeanMenuParent.children = [ dBeanMenu ];
				}
				else
					if (dBeanMenuRoot.children)
						dBeanMenuRoot.children.push(dBeanMenu);
					else
						dBeanMenuRoot.children = [ dBeanMenu ];

				dBeanMenuParent = null;
			} // End of: for (var i:int = 0; i < numOfEntityBeanDescriptorsHandlers; i++).

			dBeanMenu = new DBeanMenu();
			dBeanMenu.label = groupName;
			dBeanMenu.children = dBeanMenuRoot.children;

			if (icon)
				dBeanMenu.icon = icon;


			const dBeanMenuConfig:DBeanMenu = new DBeanMenu();
			dBeanMenuConfig.label = StrConsts.getRMString(153);
//			dBeanMenu.children = [];
//			dBeanMenu.icon = DIconLibrary.s;

			return [ dBeanMenu ];
		}

		// TODO: ISSO TEM QUE FICAR NA MDIWINDOW!!!
		/*public function listen_ESC_manageClosing():void
		{
			stage.addEventListener(
				KeyboardEvent.KEY_DOWN,
				function (event:KeyboardEvent):void
				{
					if (event.charCode == Keyboard.ESCAPE)
					{
						const mdiWindow:MDIWindow = DUtilComponent.findMyParentMDIWindow(getFocus() as UIComponent) as MDIWindow;

						if (mdiWindow)
							mdiWindow.close();
					}
				}
			);
		}*/

		public function listen_CTRL_ALT_navigateOnOpenedWindows():void
		{
			_dMDIWindowNavigator.x = 4;
			_dMDIWindowNavigator.y = 3;

			addElement(_dMDIWindowNavigator);

			stage.addEventListener(
				KeyboardEvent.KEY_DOWN,
				function (event:KeyboardEvent):void
				{
					if (event.ctrlKey && event.altKey)
					{
						var focusedComp:Object = getFocus();

						if (focusedComp)
						{
							if (focusedComp is UIComponent)
								_dMDIWindowNavigator.next(DUtilComponent.findMyParentMDIWindow(focusedComp as UIComponent));
							else if (focusedComp is DisplayObject)
								_dMDIWindowNavigator.next(DUtilComponent.findMyParentMDIWindow(focusedComp.parent as UIComponent));
						}
					}
				}
			);
		}

		public function listen_CTRL_M_minimizeAllWindows():void
		{
			DUtilKeyBoardShortcut.listen_Ctrl_Plus_AnyKey_doOnStage(
				stage,
				"109", "77",
				function (event:KeyboardEvent):void
				{
					const openedWindows:Array = MDIManager.global.getOpenWindowList();
					const openedWindowsLength:int = openedWindows.length;
					for (var i:int = 0; i < openedWindowsLength; i++)
						(openedWindows[i] as MDIWindow).minimize();
				}
			);
		}

		public function deactivateFocusManagerForAllMdiWindows(butMe:MDIWindow=null):void
		{
			const windows:Array = MDIManager.global.windowList;
			const windowsLength:int = windows.length;
			for (var i:int = 0; i < windowsLength; i++)
				(windows[i] as MDIWindow).focusManager.deactivate();

			if (butMe)
				butMe.focusManager.activate();
		}

		public function bringMDIWindowToFront(mdiWindow:MDIWindow, focusNavigatorButton:Boolean=true):void
		{
			deactivateFocusManagerForAllMdiWindows(mdiWindow);

			if (mdiWindow.minimized)
				mdiWindow.unMinimize();

			_dMDIWindowNavigator.focusButton(mdiWindow, focusNavigatorButton);

			callLater(
				function ():void
				{
					MDIManager.global.bringToFront(mdiWindow);
					DUtilFocus.setFocusOnFirstDIGUIInputInMDIWindow(mdiWindow);
				}
			);
		}

		// Memory manager:

		public function addMemoryManager():void
		{
			if (!_memoryManagerWrapper)
			{
				_memoryManagerWrapper = new HGroup();
				_memoryManagerWrapper.bottom = 10;
				_memoryManagerWrapper.horizontalAlign = HorizontalAlign.RIGHT;
				_memoryManagerWrapper.percentWidth = 100;
				_memoryManagerWrapper.addElement(new DSimpleMemoryGraph());
				addElementAt(_memoryManagerWrapper, numElements);
			}
		}

		public function removeMemoryManager():void
		{
			if (_memoryManagerWrapper)
			{
				removeElement(_memoryManagerWrapper);
				_memoryManagerWrapper = null;
			}
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Private interface:

		private function onModuleLoaded(event:ModuleEvent):void
		{
			const moduleInfo:DBeanMenu = event.module.data as DBeanMenu;

			const moduleCreated:DModule = event.module.factory.create() as DModule;
			DUtilComponent.widthHeightTo100Percent(moduleCreated);
			moduleCreated.removeEventListener(ModuleEvent.READY, onModuleLoaded);
			moduleCreated.removeEventListener(ModuleEvent.ERROR, onModuleError);

			const mdiWindow:MDIWindow = createDefaultMDIWindow(moduleInfo);
			mdiWindow.addElement(moduleCreated);

			moduleCreated._mdiWindowParent = mdiWindow;

			MDIManager.global.add(mdiWindow);
		}

		private function onModuleError(event:ModuleEvent):void
		{
			const dModule:DModule = event.module as DModule;
			dModule.removeEventListener(ModuleEvent.READY, onModuleLoaded);
			dModule.removeEventListener(ModuleEvent.ERROR, onModuleError);
			delete _openedModulesAndMDIWindows[(event.module.data as DBeanMenu)._swf];
		}

		private function mdiFocusClickControler(event:MouseEvent):void
		{
			const mdiWindow:MDIWindow = event.currentTarget as MDIWindow;
			const clickedOne:* = event.target;

			deactivateFocusManagerForAllMdiWindows(mdiWindow);

			if ((clickedOne is Canvas) && (clickedOne.id == "MDIWindowTitleBar"))
				DUtilFocus.setFocusOnFirstDIGUIInputInMDIWindow(mdiWindow);

			event.updateAfterEvent();

			// TODO: TERMINAR ESTE MÉTODO!!!
			/*if ((clickedOne as Container) || (clickedOne as Group) || (clickedOne as SkinnableContainer))
				const mdiWindow:MDIWindow = event.currentTarget as MDIWindow;
				if (mdiWindow != DUtilComponent.findMyParentMDIWindow(getFocus() as UIComponent))*/
		}

		private function onMDIWindowClosed(event:MDIWindowEvent):void
		{
			const mdiWindow:MDIWindow = event.currentTarget as MDIWindow;
			mdiWindow.removeAllChildren();
			mdiWindow.removeAllElements();
			mdiWindow.removeEventListener(MouseEvent.CLICK, mdiFocusClickControler);
			mdiWindow.removeEventListener(MDIWindowEvent.CLOSE, onMDIWindowClosed);

			MDIManager.global.remove(mdiWindow);

			delete _openedModulesAndMDIWindows[mdiWindow.id];

			if (_dMDIWindowNavigator.stage)
				_dMDIWindowNavigator.updateNavigator();

			if (MDIManager.global.windowList.length == 0)
				setFocus(); // TODO: VERIFICAR SE ISTO ESTÁ FUNCIONANDO!!! QUE TAL COLOCAR O FOCO NO STAGE???
		}

		private function createDefaultMDIWindow(dBeanMenu:DBeanMenu):MDIWindow
		{
			const mdiWindow:MDIWindow = new MDIWindow();
			mdiWindow.id = dBeanMenu._swf;
			mdiWindow.title = dBeanMenu.label ? dBeanMenu.label : StrConsts._CHAR_EMPTY_STRING;
			mdiWindow.resizable = dBeanMenu._resizable;
			mdiWindow.setStyle(StrConsts._FLEX_STYLE_PROPERTY_BACKGROUND_COLOR, "0x" + StrConsts._COLOR_BLUE_SKY); // TODO: Configurável.
			mdiWindow.addEventListener(MouseEvent.CLICK, mdiFocusClickControler, false, 0, true);
			mdiWindow.addEventListener(MDIWindowEvent.CLOSE, onMDIWindowClosed, false, 0, true);
			return mdiWindow;
		}
		
		//----------------------------------------------------------------------
	}
}
