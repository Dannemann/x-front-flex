package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.library.DIconLibrary48;

	import flash.display.Sprite;

	import mx.controls.Alert;
	import mx.core.FlexGlobals;

	public final class DConfirmActionAlert implements DComponent
	{
		public static function show(message:String, closeHandler:Function):void
		{
			const alert:Alert = Alert.show(
				message,
				StrConsts.getRMString(48),
				Alert.YES | Alert.NO,
				FlexGlobals.topLevelApplication as Sprite,
				closeHandler,
				DIconLibrary48.WARNING,
				Alert.NO);

			alert.setStyle(StrConsts._FLEX_STYLE_PROPERTY_BACKGROUND_COLOR, 0xFFFFFF);
			alert.setStyle(StrConsts._FLEX_STYLE_PROPERTY_BACKGROUND_ALPHA, 0.50);
			alert.setStyle(StrConsts._FLEX_STYLE_PROPERTY_BORDER_COLOR, 0xFFFFFF);
			alert.setStyle(StrConsts._FLEX_STYLE_PROPERTY_BORDER_ALPHA, 0.75);
			alert.setStyle(StrConsts._FLEX_STYLE_PROPERTY_COLOR, 0x000000);
		}
	}
}
