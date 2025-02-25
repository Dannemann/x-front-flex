package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;

	public final class DLinkButtonDelete extends DLinkButton
	{
		public function DLinkButtonDelete()
		{
			label = StrConsts.getRMString(40);
			setStyle(StrConsts._FLEX_STYLE_PROPERTY_ICON, StrConsts._IMG_DELETE);
		}
	}
}
