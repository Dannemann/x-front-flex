package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;

	public final class DLinkButtonExecute extends DLinkButton
	{
		public function DLinkButtonExecute()
		{
			label = StrConsts.getRMString(11);
			setStyle(StrConsts._FLEX_STYLE_PROPERTY_ICON, StrConsts._IMG_EXECUTE);
		}
	}
}
