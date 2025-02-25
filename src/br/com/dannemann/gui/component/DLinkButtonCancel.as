package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;

	public final class DLinkButtonCancel extends DLinkButton
	{
		public function DLinkButtonCancel()
		{
			label = StrConsts.getRMString(12);
			setStyle(StrConsts._FLEX_STYLE_PROPERTY_ICON, StrConsts._IMG_CANCEL);
		}
	}
}
