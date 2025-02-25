package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;

	public class DLinkButtonConnect extends DLinkButton
	{
		public function DLinkButtonConnect()
		{
			label = StrConsts.getRMString(70);
			setStyle(StrConsts._FLEX_STYLE_PROPERTY_ICON, StrConsts._IMG_GLOBE_CONNECTED);
		}
	}
}
