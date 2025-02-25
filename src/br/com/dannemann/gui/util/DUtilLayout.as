package br.com.dannemann.gui.util
{
	import spark.layouts.VerticalLayout;

	public final class DUtilLayout
	{
		public static function newVerLayPadd5():VerticalLayout
		{
			const verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.paddingBottom = 5;
			verticalLayout.paddingLeft = 5;
			verticalLayout.paddingRight = 5;
			verticalLayout.paddingTop = 5;
			return verticalLayout;
		}
	}
}
