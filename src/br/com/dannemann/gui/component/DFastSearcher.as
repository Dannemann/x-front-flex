package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.component.container.DSkinnableContainer;
	import br.com.dannemann.gui.component.container.DSkinnableContainerDefaultSkin;
	import br.com.dannemann.gui.component.input.DTextInputAutoComplete;
	import br.com.dannemann.gui.controller.EntityDescriptor;
	import br.com.dannemann.gui.controller.ServerVarsDecoder;
	import br.com.dannemann.gui.event.DFastSearcherEvent;
	import br.com.dannemann.gui.event.DTextInputAutoCompleteEvent;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.events.SandboxMouseEvent;
	import mx.managers.PopUpManager;

	import spark.effects.Move;

	// TODO: Esta classe deixa muito lixo se usada muitas vezes seguida (talvez, cerca de 200 KBs a cada chamada). Tornar este componente TOTALMENTE estático.
	public final class DFastSearcher extends DSkinnableContainer implements DComponent
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		[Bindable] public static var _dataProvider:ArrayCollection = new ArrayCollection();
		public static var _objectMap:Object = new Object();

		public static var _focusSaverComponent:UIComponent;
		public static var _executeOnOpen:Function;

		public static var locked:Boolean;
		public static function get _locked():Boolean
		{
			return locked;
		}
		public static function set _locked(isLocked:Boolean):void
		{
			locked = isLocked;

			if (locked)
				close();
		}

		private static var _instance:DFastSearcher;

		public static const _inputSearch:DTextInputAutoComplete = new DTextInputAutoComplete();
		_inputSearch.requireSelection = true;
		_inputSearch.addEventListener(
			KeyboardEvent.KEY_DOWN,
			function (event:KeyboardEvent):void
			{
				if (event.keyCode == Keyboard.ESCAPE)
					_inputSearch.callLater(close);
			}
		);
		_inputSearch.addEventListener(
			DTextInputAutoCompleteEvent.ON_SELECT,
			function (event:DTextInputAutoCompleteEvent):void
			{
				close();
			}
		);

		private static const _googleImage:DBitmapImage = new DBitmapImage(StrConsts._IMG_GOOGLE48);
		private static const _defaultMoveEffect:Move = new Move();
		_defaultMoveEffect.duration = 200;




		private static var _stage:Stage;

		public static var _effectsOn:Boolean = true;
		public static var _horizontalGap:uint = 5;
		public static var _verticalGap:uint = 5;

		public var _parent:Sprite;

		private var fastSearcherNotRemovedFromStage:Boolean = true;

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Constructor:

		public function DFastSearcher()
		{
			setStyle(StrConsts._FLEX_STYLE_PROPERTY_SKIN_CLASS, DSkinnableContainerDefaultSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true);
			addEventListener(FlexEvent.REMOVE, onRemove, false, 0, true);
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Overrides:

		//----------------------------------------------------------------------
		// Class Overrides:

		override protected function createChildren():void
		{
			super.createChildren();

			contentGroup.addElement(_googleImage);
			contentGroup.addElement(_inputSearch);
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Static main interface:

		// Public:

		public static function addDescriptors(entityBeanDescriptorsHandlers:Array):void
		{
			const entityBeanDescriptorsHandlersLength:int = entityBeanDescriptorsHandlers.length;
			var entityBeanDescriptorsHandler:EntityDescriptor;
			var classNameFormatted:String;
			for (var i:int = 0; i < entityBeanDescriptorsHandlersLength; i++)
			{
				entityBeanDescriptorsHandler = entityBeanDescriptorsHandlers[i] as EntityDescriptor;

				if (entityBeanDescriptorsHandler._crudDescriptor)
				{
					classNameFormatted = ServerVarsDecoder.replaceAllMessageDVars(entityBeanDescriptorsHandler._crudDescriptor._classNameFormatted);
					_dataProvider.addItem(classNameFormatted);
					_objectMap[classNameFormatted] = entityBeanDescriptorsHandler;
				}
			}
		}

		public static function addEventListener(type:String, listener:Function):void
		{
			if (type == DFastSearcherEvent.ON_SELECT)
				_inputSearch.addEventListener(
					DTextInputAutoCompleteEvent.ON_SELECT,
					function (event:DTextInputAutoCompleteEvent):void
					{
						listener(createNewDFastSearcherEvent(DFastSearcherEvent.ON_SELECT, event));
					}
				);
			else if (type == DFastSearcherEvent.ON_ENTER)
				_inputSearch.addEventListener(
					DTextInputAutoCompleteEvent.ON_ENTER,
					function (event:DTextInputAutoCompleteEvent):void
					{
						listener(createNewDFastSearcherEvent(DFastSearcherEvent.ON_ENTER, event));
					}
				);
		}

		public static function open(parent:Sprite=null):void
		{
			if (!locked && !_instance)
			{
				if (_executeOnOpen != null)
					_executeOnOpen();

				_inputSearch.dataProvider = _dataProvider;
				_inputSearch.reset();

				_instance = new DFastSearcher();
				_instance._parent = parent ? parent : FlexGlobals.topLevelApplication as Sprite;

				if (!_instance._parent)
				{
					_instance = null;
					return;
				}

				_instance.setStyle(StrConsts._FLEX_STYLE_PROPERTY_CREATION_COMPLETE_EFFECT, _defaultMoveEffect);
				_instance.setStyle(StrConsts._FLEX_STYLE_PROPERTY_REMOVED_EFFECT, _defaultMoveEffect);
				_instance.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, mouseOutsideHandler, false, 0, true);
				_instance.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE, mouseOutsideHandler, false, 0, true);
				_instance.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, mouseOutsideHandler, false, 0, true);
				_instance.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE, mouseOutsideHandler, false, 0, true);

				PopUpManager.addPopUp(_instance, _instance._parent, false);
			}
		}

		public static function close():void
		{
			if (_instance)
				PopUpManager.removePopUp(_instance);
		}

		public static function toogleShow(parent:Sprite=null):void
		{
			if (_instance)
				close();
			else
				open(parent);
		}

		public static function listen_openShortcut(stage:Stage):void
		{
			_stage = stage;
			_stage.addEventListener(
				KeyboardEvent.KEY_DOWN,
				function (event:KeyboardEvent):void
				{
					if (event.keyCode == Keyboard.F2)
						toogleShow();
				}
			);
		}

		// Private:

		private static function createNewDFastSearcherEvent(type:String, event:DTextInputAutoCompleteEvent=null):DFastSearcherEvent
		{
			const dFastSearcherEvent:DFastSearcherEvent = new DFastSearcherEvent(type);
			dFastSearcherEvent._selectedString = event._selectedString;
			dFastSearcherEvent._currentWritedText = event._currentWritedText;
			return dFastSearcherEvent;
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Private interface:

		// Event handlers:

		private function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);

			if (_parent)
			{
				moveToPositionIn(_parent);
				callLater(_inputSearch.setFocus);
			}
		}

		private function onRemove(event:FlexEvent):void
		{
			removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, mouseOutsideHandler);
			removeEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE, mouseOutsideHandler);
			removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, mouseOutsideHandler);
			removeEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE, mouseOutsideHandler);
			removeEventListener(FlexEvent.REMOVE, onRemove);

			if (fastSearcherNotRemovedFromStage)
			{
				moveToPositionOut(_parent);
				fastSearcherNotRemovedFromStage = false;
			}

			_inputSearch.reset();

			_instance = null;
			_parent = null;

			if (_focusSaverComponent)
				_focusSaverComponent.setFocus();
			else
				FlexGlobals.topLevelApplication.setFocus();
		}

		private static function mouseOutsideHandler(event:Event):void
		{
			if (event is FlexMouseEvent)
			{
				const e:FlexMouseEvent = event as FlexMouseEvent;

				if (_inputSearch.hitTestPoint(e.stageX, e.stageY))
					return;
			}

			close();
		}

		// Effects:

		private function moveToPositionIn(parent:DisplayObject=null):void
		{
			x = parent.x + _horizontalGap;
			y = parent.y + parent.height - (_verticalGap + height);
			_defaultMoveEffect.yFrom = parent.y + parent.height;
			_defaultMoveEffect.yTo = y;
		}

		private function moveToPositionOut(parent:DisplayObject=null):void
		{
			x = parent.x + _horizontalGap;
			_defaultMoveEffect.yFrom =y;
			y = parent.y + parent.height - (_verticalGap + height);
			_defaultMoveEffect.yTo = parent.y + parent.height;
		}

		//----------------------------------------------------------------------
	}
}
