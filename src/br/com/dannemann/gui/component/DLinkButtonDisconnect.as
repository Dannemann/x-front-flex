package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;

	public final class DLinkButtonDisconnect extends DLinkButton
	{
		public function DLinkButtonDisconnect()
		{
			label = StrConsts.getRMString(89);
			setStyle(StrConsts._FLEX_STYLE_PROPERTY_ICON, StrConsts._IMG_GLOBE_DISCONNECTED);
		}
	}
}
