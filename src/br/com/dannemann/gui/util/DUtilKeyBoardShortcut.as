package br.com.dannemann.gui.util
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	import mx.core.UIComponent;

	public final class DUtilKeyBoardShortcut
	{
		public static function charCodeToChar(num:int):String
		{
			if (num >= 0 && num <= 26)
				return "abcdefghijklmnopqrstuvwxyz".charAt(num - 1);
			else if (num >= 49 && num <= 59)
				return String(num - 48);
			else
				return num.toString();
		}

		public static function listen_Ctrl_Plus_AnyKey_do(component:UIComponent, theKeyCodeLowercased:String, theKeyCodeUppercased:String, functionToExecute:Function):void
		{
			component.addEventListener(
				KeyboardEvent.KEY_DOWN,
				function (event:KeyboardEvent):void
				{
					if (theKeyCodeLowercased == null)
					{
						if (event.ctrlKey && event.charCode == uint(theKeyCodeUppercased))
							functionToExecute(event);
					}
					else if (theKeyCodeUppercased == null)
					{
						if (event.ctrlKey && event.charCode == uint(theKeyCodeLowercased))
							functionToExecute(event);
					}
					else
						if (event.ctrlKey && (event.charCode == uint(theKeyCodeLowercased) || event.charCode == uint(theKeyCodeUppercased)))
							functionToExecute(event);
				}
			);
		}

		// TODO: MUDAR TIPOS PARA INT E VERIFICAR O CHARCODE E KEYCODE.
		public static function listen_Ctrl_Plus_AnyKey_doOnStage(stage:Stage, theKeyCodeLowercased:String, theKeyCodeUppercased:String, functionToExecute:Function):void
		{
			stage.addEventListener(
				KeyboardEvent.KEY_DOWN,
				function (event:KeyboardEvent):void
				{
					if (theKeyCodeLowercased == null)
					{
						if (event.ctrlKey && event.charCode == uint(theKeyCodeUppercased))
							functionToExecute(event);
					}
					else if (theKeyCodeUppercased == null)
					{
						if (event.ctrlKey && event.charCode == uint(theKeyCodeLowercased))
							functionToExecute(event);
					}
					else
						if (event.ctrlKey && (event.charCode == uint(theKeyCodeLowercased) || event.charCode == uint(theKeyCodeUppercased)))
							functionToExecute(event);
				}
			);
		}

		public static function listen_Ctrl_Shift_Plus_AnyKey_doOnStage(stage:Stage, theKeyCodeLowercased:String, theKeyCodeUppercased:String, functionToExecute:Function):void
		{
			stage.addEventListener(
				KeyboardEvent.KEY_DOWN,
				function (event:KeyboardEvent):void
				{
					if (theKeyCodeLowercased == null)
					{
						if (event.ctrlKey && event.shiftKey && event.charCode == uint(theKeyCodeUppercased))
							functionToExecute(event);
					}
					else if (theKeyCodeUppercased == null)
					{
						if (event.ctrlKey && event.shiftKey && event.charCode == uint(theKeyCodeLowercased))
							functionToExecute(event);
					}
					else
						if (event.ctrlKey && event.shiftKey && (event.charCode == uint(theKeyCodeLowercased) || event.charCode == uint(theKeyCodeUppercased)))
							functionToExecute(event);
				}
			);
		}
	}
}
