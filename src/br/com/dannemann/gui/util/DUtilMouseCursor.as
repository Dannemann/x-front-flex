package br.com.dannemann.gui.util
{
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;

	public final class DUtilMouseCursor
	{
		public static function moveComponentToMouse(component:UIComponent, gap:uint=10):void
		{
			component.move(FlexGlobals.topLevelApplication.mouseX + gap, FlexGlobals.topLevelApplication.mouseY + gap);
		}
	}
}
