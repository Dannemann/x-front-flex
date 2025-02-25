package br.com.dannemann.gui.component
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.effects.Parallel;
	import mx.events.FlexEvent;
	import mx.managers.IFocusManager;
	import mx.managers.PopUpManager;
	
	import spark.components.Application;
	import spark.components.RichText;
	import spark.effects.Fade;
	import spark.effects.Move;
	import spark.primitives.BitmapImage;
	
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.domain.Msgs;
	import br.com.dannemann.gui.component.container.DSkinnableContainer;
	import br.com.dannemann.gui.component.container.DSkinnableContainerDefaultSkin;
	import br.com.dannemann.gui.library.DIconLibrary48;
	
	import flashx.textLayout.conversion.TextConverter;

	public class DNotificator extends DSkinnableContainer
	{
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Fields:

		public static const _NOTIFICATION_INFO:uint = 1;
		public static const _NOTIFICATION_HELP:uint = 2;
		public static const _NOTIFICATION_WARNING:uint = 3;
		public static const _NOTIFICATION_ERROR:uint = 4;

		public static const _NOTIFICATION_POSITION_BOTTOM_RIGHT:uint = 1;
		public static const _NOTIFICATION_POSITION_MIDDLE_RIGHT:uint = 2;
		public static const _NOTIFICATION_POSITION_TOP_RIGHT:uint = 3;
		public static const _NOTIFICATION_POSITION_TOP_CENTER:uint = 4;
		public static const _NOTIFICATION_POSITION_TOP_LEFT:uint = 5;
		public static const _NOTIFICATION_POSITION_MIDDLE_LEFT:uint = 6;
		public static const _NOTIFICATION_POSITION_BOTTOM_LEFT:uint = 7;
		public static const _NOTIFICATION_POSITION_BOTTOM_CENTER:uint = 8;
		public static const _NOTIFICATION_POSITION_CENTER:uint = 9;

		public static var _notStacked:Boolean;
		public static var _effectsOn:Boolean = true;
		public static var _horizontalGap:uint = 5;
		public static var _verticalGap:uint = 5;

		public var _message:RichText;
		public var _bitmapImage:BitmapImage;
		public var _parent:Sprite;
		public var _position:uint;
		public var _duration:uint;

		public static const _currentTimers:ArrayCollection = new ArrayCollection();
		public static const _defaultMoveEffect:Move = new Move();

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Constructor:

		public function DNotificator()
		{
			setStyle(StrConsts._FLEX_STYLE_PROPERTY_SKIN_CLASS, DSkinnableContainerDefaultSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, onNotificatorComplete);
			addEventListener(MouseEvent.CLICK, onClickNotificator);
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Public static main interface:

		public static function show(message:String, focusManager:IFocusManager=null, notificationType:uint=0, position:uint=1, parent:Sprite=null, duration:uint=5000):void
		{
			const notificator:DNotificator = new DNotificator();

			if (focusManager)
				notificator.focusManager = focusManager;
			else
			{
				var fm:IFocusManager;

				const stage:Stage = (FlexGlobals.topLevelApplication as Application).stage;

				if (stage)
				{
					const focused:UIComponent = stage.focus as UIComponent;

					if (focused)
						fm = focused.focusManager;
					else
						trace(" ### DNotificator.show: (stage.focus as UIComponent) == null");
				}
				else
					fm = (FlexGlobals.topLevelApplication as Application).focusManager;

				notificator.focusManager = fm;
			}

			const richTextMsg:RichText = new RichText();
			richTextMsg.percentWidth = 100;

			if (/<\w+>.*?<\/\w+>/s.test(message) || /<\w+\/>/s.test(message))
				richTextMsg.textFlow = TextConverter.importToFlow(message, TextConverter.TEXT_FIELD_HTML_FORMAT);
			else
				richTextMsg.text = message;

			notificator._message = richTextMsg;

			const bitmapImage:BitmapImage = new BitmapImage();

			switch (notificationType)
			{
				case DNotificator._NOTIFICATION_INFO:
					bitmapImage.source = StrConsts._IMG_INFO;
					break;
				case DNotificator._NOTIFICATION_HELP:
					bitmapImage.source = StrConsts._IMG_HELP;
					break;
				case DNotificator._NOTIFICATION_WARNING:
					bitmapImage.source = DIconLibrary48.WARNING;
					break;
				case DNotificator._NOTIFICATION_ERROR:
					bitmapImage.source = StrConsts._IMG_ERROR;
					break;
			}

			notificator._bitmapImage = bitmapImage;

			if (DNotificator._effectsOn)
			{
				const defaultFadeEffectIn:Fade = new Fade();
				defaultFadeEffectIn.alphaFrom = 0;
				defaultFadeEffectIn.alphaTo = 1;

				const defaultFadeEffectOut:Fade = new Fade();
				defaultFadeEffectOut.alphaTo = 0;

				const defaultParallelEffect:Parallel = new Parallel();
				defaultParallelEffect.addChild(defaultFadeEffectIn);
				defaultParallelEffect.addChild(DNotificator._defaultMoveEffect);

				notificator.setStyle(StrConsts._FLEX_STYLE_PROPERTY_CREATION_COMPLETE_EFFECT, defaultParallelEffect);
				notificator.setStyle(StrConsts._FLEX_STYLE_PROPERTY_REMOVED_EFFECT, defaultFadeEffectOut);
			}

			notificator._position = position;

			if (!parent)
				notificator._parent = FlexGlobals.topLevelApplication as Sprite;
			else
				notificator._parent = parent;

			notificator._duration = duration;

			PopUpManager.addPopUp(notificator, notificator._parent, false);
			DNotificatorStackManager.getInstance().add(notificator);
		}

		public static function showInfo(message:String, focusManager:IFocusManager=null, position:uint=DNotificator._NOTIFICATION_POSITION_TOP_CENTER, parent:Sprite=null, duration:uint=3500):void
		{
			show(message, focusManager, DNotificator._NOTIFICATION_INFO, position, parent, duration);
		}

		public static function showHelp(message:String, focusManager:IFocusManager=null, position:uint=DNotificator._NOTIFICATION_POSITION_TOP_CENTER, parent:Sprite=null, duration:uint=3500):void
		{
			show(message, focusManager, DNotificator._NOTIFICATION_HELP, position, parent, duration);
		}

		public static function showWarning(message:String, focusManager:IFocusManager=null, position:uint=DNotificator._NOTIFICATION_POSITION_TOP_CENTER, parent:Sprite=null, duration:uint=3500):void
		{
			show(message, focusManager, DNotificator._NOTIFICATION_WARNING, position, parent, duration);
		}

		public static function showError(message:String, errorCode:String=null, focusManager:IFocusManager=null, position:uint=DNotificator._NOTIFICATION_POSITION_TOP_CENTER, parent:Sprite=null, duration:uint=3500):void
		{
			if (errorCode)
				message = Msgs.grab("error") + " " + errorCode + ":\n\n" + message;

			show(message, focusManager, DNotificator._NOTIFICATION_ERROR, position, parent, duration);
		}

		public static function showError2(message:String, focusManager:IFocusManager=null, position:uint=DNotificator._NOTIFICATION_POSITION_TOP_CENTER, parent:Sprite=null, duration:uint=3500):void
		{
			show(message, focusManager, DNotificator._NOTIFICATION_ERROR, position, parent, duration);
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

			contentGroup.addElement(_bitmapImage);
			contentGroup.addElement(_message);
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Protected interface:

		//----------------------------------------------------------------------
		// Event handlers:

		protected function close_dNotificator(event:Event=null):void
		{
			if (event)
			{
				if (event is TimerEvent)
					(event.currentTarget as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE, close_dNotificator);
				else if (event is MouseEvent && event.type == MouseEvent.CLICK)
				{
					PopUpManager.removePopUp(this);
					DNotificatorStackManager.getInstance().remove();
					return;
				}
			}

			if (hitTestPoint(FlexGlobals.topLevelApplication.contentMouseX, FlexGlobals.topLevelApplication.contentMouseY))
				addEventListener(MouseEvent.ROLL_OUT, onRollOutNotificator);
			else
			{
				PopUpManager.removePopUp(this);
				DNotificatorStackManager.getInstance().remove();
			}
		}

		protected function onClickNotificator(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.CLICK, onClickNotificator);
			close_dNotificator(event);
		}

		//----------------------------------------------------------------------
		// Protected interface:

		protected function moveToPosition(parent:DisplayObject=null):void
		{
			var factor:int;

			if (_notStacked)
			{
				_notStacked = false;
				factor = 1;
			}
			else
				factor = DNotificatorStackManager.getInstance().stackTop;

			switch (_position)
			{
				case DNotificator._NOTIFICATION_POSITION_BOTTOM_RIGHT:
					x = parent.x + parent.width - width - _horizontalGap;
					y = parent.y + parent.height - (_horizontalGap + height) * factor;

					if (y < 0)
						DNotificatorStackManager.getInstance().resetStack();

					_defaultMoveEffect.yFrom = parent.y + parent.height;
					_defaultMoveEffect.yTo = y;
					break;
				case DNotificator._NOTIFICATION_POSITION_MIDDLE_RIGHT:
					x = parent.x + parent.width - _horizontalGap - width;
					y = parent.y + (parent.height - height) / 2;
					_defaultMoveEffect.xFrom = parent.width;
					_defaultMoveEffect.xTo = x
					break;
				case DNotificator._NOTIFICATION_POSITION_TOP_RIGHT:
					x = parent.x + parent.width - _horizontalGap - width;
					y = parent.y + (_verticalGap + height) * factor - height;

					if (y > parent.height - height)
						DNotificatorStackManager.getInstance().resetStack();

					_defaultMoveEffect.yFrom = parent.y - height;
					_defaultMoveEffect.yTo = y;
					break;
				case DNotificator._NOTIFICATION_POSITION_TOP_CENTER:
					x = parent.x + (parent.width - width) / 2;
					y = parent.y + (_verticalGap + height) * factor - height;

					if (y > parent.height - height)
						DNotificatorStackManager.getInstance().resetStack();

					_defaultMoveEffect.yFrom = parent.y - height;
					_defaultMoveEffect.yTo = y;
					break;
				case DNotificator._NOTIFICATION_POSITION_TOP_LEFT:
					x = parent.x + _horizontalGap;
					y = parent.y + (_verticalGap + height) * factor - height;

					if (y > parent.height - height)
						DNotificatorStackManager.getInstance().resetStack();

					_defaultMoveEffect.yFrom = parent.y - height;
					_defaultMoveEffect.yTo = y;
					break;
				case DNotificator._NOTIFICATION_POSITION_MIDDLE_LEFT:
					x = parent.x + _horizontalGap;
					y = parent.y + (parent.height - height) / 2;
					_defaultMoveEffect.xFrom = - width;
					_defaultMoveEffect.xTo = x;
					break;
				case DNotificator._NOTIFICATION_POSITION_BOTTOM_LEFT:
					x = parent.x + _horizontalGap;
					y = parent.y + parent.height - (_verticalGap + height) * factor;

					if (y < 0)
						DNotificatorStackManager.getInstance().resetStack();

					_defaultMoveEffect.yFrom = parent.y + parent.height;
					_defaultMoveEffect.yTo = y;
					break;
				case DNotificator._NOTIFICATION_POSITION_BOTTOM_CENTER:
					x = parent.x + (parent.width - width) / 2;
					y = parent.y + parent.height - (_verticalGap + height) * factor;

					if (y < 0)
						DNotificatorStackManager.getInstance().resetStack();

					_defaultMoveEffect.yFrom = parent.y + parent.height;
					_defaultMoveEffect.yTo = y;
					break;
				case DNotificator._NOTIFICATION_POSITION_CENTER:
					x = parent.x + (parent.width - width) / 2;
					y = parent.y + (parent.height - height) / 2;
					break;
			}
		}

		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Private interface:

		private function onNotificatorComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onNotificatorComplete);
			moveToPosition(_parent);

			if (_duration > 0)
			{
				const elapseTime:Timer = new Timer(_duration, 1);
				elapseTime.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				elapseTime.start();
				_currentTimers.addItem(elapseTime);
			}
		}

		private function onTimerComplete(event:TimerEvent):void
		{
			const elapseTime:Timer = event.currentTarget as Timer;
			elapseTime.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_currentTimers.removeItemAt(_currentTimers.getItemIndex(elapseTime));

			if (hitTestPoint(FlexGlobals.topLevelApplication.contentMouseX, FlexGlobals.topLevelApplication.contentMouseY))
				addEventListener(MouseEvent.ROLL_OUT, onRollOutNotificator);
			else
				close_dNotificator();
		}

		private function onRollOutNotificator(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.ROLL_OUT, onRollOutNotificator);
			const elapseTime:Timer = new Timer(2000, 1);
			elapseTime.addEventListener(TimerEvent.TIMER_COMPLETE, close_dNotificator);
			elapseTime.start();
		}

		//----------------------------------------------------------------------
	}
}
