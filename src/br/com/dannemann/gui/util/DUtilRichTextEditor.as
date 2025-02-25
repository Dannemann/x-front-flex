package br.com.dannemann.gui.util
{
	import mx.controls.RichTextEditor;
	import mx.core.mx_internal;

	public final class DUtilRichTextEditor
	{
		public static function removeControlBar(rte:RichTextEditor, bottomPadding:int=10):void
		{
			rte.toolbar.removeChild(rte.alignButtons);
			rte.toolbar.removeChild(rte.bulletButton);
			rte.toolbar.removeChild(rte.linkTextInput);
			rte.toolbar.removeChild(rte.colorPicker);
			rte.toolbar.removeChild(rte.toolBar2);
			rte.toolbar.removeChild(rte.fontSizeCombo);
			rte.mx_internal::_controlBar.height = bottomPadding;
		}
	}
}
