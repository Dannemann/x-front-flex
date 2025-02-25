package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.domain.StrConsts;

	public final class DLinkButtonSave extends DLinkButton
	{
		public function DLinkButtonSave(useUpdateLabel:Boolean=false)
		{
			toogleSaveUpdateLabels(useUpdateLabel);
			setStyle(StrConsts._FLEX_STYLE_PROPERTY_ICON, StrConsts._IMG_SAVE);
		}

		public function toogleSaveUpdateLabels(update:Boolean=false, labelForSave:String=null):void
		{
			if (update)
				label = StrConsts.getRMString(44);
			else
			{
				if (labelForSave)
					label = labelForSave;
				else
					label = StrConsts.getRMString(29);
			}
		}
	}
}
