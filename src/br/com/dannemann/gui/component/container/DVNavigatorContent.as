package br.com.dannemann.gui.component.container
{
	import br.com.dannemann.gui.domain.StrConsts;
	import br.com.dannemann.gui.effect.DEffectFadeIn1;

	import spark.components.NavigatorContent;
	import spark.layouts.VerticalLayout;

	public final class DVNavigatorContent extends NavigatorContent implements DContainer
	{
		public var _enableFadeEffectOnShow:Boolean;

		override protected function createChildren():void
		{
			super.createChildren();

			layout = new VerticalLayout();

			if (_enableFadeEffectOnShow)
				setStyle(StrConsts._FLEX_STYLE_PROPERTY_SHOW_EFFECT, new DEffectFadeIn1());
		}
	}
}
