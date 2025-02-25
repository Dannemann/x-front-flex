package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;

	public final class DLinkButtonSearch extends DLinkButton
	{
		public function DLinkButtonSearch()
		{
			label = StrConsts.getRMString(27);
			setStyle(StrConsts._FLEX_STYLE_PROPERTY_ICON, StrConsts._IMG_EXECUTE);
		}
	}
}
