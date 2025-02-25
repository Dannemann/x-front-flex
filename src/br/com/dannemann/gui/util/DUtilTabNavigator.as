package br.com.dannemann.gui.util
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import mx.containers.TabNavigator;

	public final class DUtilTabNavigator
	{
		// TODO: If all tabs are disabled, this will result in a infinite loop.
		public static function Ctrl_PLUS_Tab_changeTabNavIndex(_target:TabNavigator, event:KeyboardEvent):void
		{
			const tavNavNumEls:int = _target.numElements - 1;
			const currentTabNavIndex:int = _target.selectedIndex;
			var index:int;

			if (event.ctrlKey && event.shiftKey && event.keyCode == Keyboard.TAB)
			{
				index = currentTabNavIndex == 0 ? tavNavNumEls : currentTabNavIndex - 1;
				while (!_target.getTabAt(index).enabled)
					if (index == 0)
						index = tavNavNumEls;
					else
						index--;

				_target.selectedIndex = index;
			}
			else if (event.ctrlKey && event.keyCode == Keyboard.TAB)
			{
				index = currentTabNavIndex == tavNavNumEls ? 0 : currentTabNavIndex + 1;
				while (!_target.getTabAt(index).enabled)
					if (index == tavNavNumEls)
						index = 0;
					else
						index++;

				_target.selectedIndex = index;
			}
		}
	}
}
