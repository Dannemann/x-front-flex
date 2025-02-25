package br.com.dannemann.gui.component.adg
{
	import mx.controls.advancedDataGridClasses.AdvancedDataGridItemRenderer;

	public class DADGItemRenderer extends AdvancedDataGridItemRenderer
	{
		private const replaceStr:String = "<B><FONT COLOR='#B22222'>$&</FONT></B>";

		override public function validateProperties():void
		{
			super.validateProperties();

			if (listData && listData.label && styleName.hasOwnProperty("_filter"))
				htmlText = listData.label.replace(styleName._filter._searchExpression, replaceStr);
		}
	}
}
