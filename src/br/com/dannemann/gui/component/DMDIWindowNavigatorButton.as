package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.component.container.mdi.containers.MDIWindow;
	import br.com.dannemann.gui.library.DIconLibrary;

	public final class DMDIWindowNavigatorButton extends DLinkButton
	{
		public var _mdiWindowRelative:MDIWindow;

		public function DMDIWindowNavigatorButton(mdiWindowRelative:MDIWindow)
		{
			_mdiWindowRelative = mdiWindowRelative;

			setStyle(StrConsts._FLEX_STYLE_PROPERTY_ICON, DIconLibrary.APPLICATION_FORM);
		}
	}
}
