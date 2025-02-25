package br.com.dannemann.gui.component
{
	import flash.events.KeyboardEvent;

	import mx.containers.TabNavigator;

	public final class DTabNavigator extends TabNavigator
	{
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			if (focusManager && focusManager.getFocus() == this)
				tabBar.dispatchEvent(event);
		}
	}
}
