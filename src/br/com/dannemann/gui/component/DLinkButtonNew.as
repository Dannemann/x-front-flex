package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;

	public final class DLinkButtonNew extends DLinkButton
	{
		public function DLinkButtonNew()
		{
			label = StrConsts.getRMString(28);
			setStyle(StrConsts._FLEX_STYLE_PROPERTY_ICON, StrConsts._IMG_NEW);
		}
	}
}
