package br.com.dannemann.gui.util
{
	import br.com.dannemann.gui.component.container.mdi.containers.MDIWindow;

	import flash.display.Sprite;

	import mx.core.FlexGlobals;
	import mx.core.UIComponent;

	import spark.components.VGroup;
	import spark.primitives.supportClasses.GraphicElement;

	public final class DUtilComponent
	{
		public static function centralizeComponent(component:UIComponent, parentContainer:Sprite=null):void
		{
			if (!parentContainer)
				parentContainer = FlexGlobals.topLevelApplication as Sprite;

			component.x = parentContainer.x + (parentContainer.width / 2) - (component.width / 2);
			component.y = parentContainer.y + (parentContainer.height / 2) - (component.height / 2);
		}

		public static function padding_BottomLeftRightTop_VGroup(vGroup:VGroup, value:int):void
		{
			vGroup.paddingBottom = value;
			vGroup.paddingLeft = value;
			vGroup.paddingRight = value;
			vGroup.paddingTop = value;
		}

		public static function widthHeightTo100Percent(uiComponent:UIComponent):void
		{
			uiComponent.percentWidth = 100;
			uiComponent.percentHeight = 100;
		}

		public static function widthHeightTo100Percent2(graphicElement:GraphicElement):void
		{
			graphicElement.percentWidth = 100;
			graphicElement.percentHeight = 100;
		}

		public static function widthTo100PercentDefaultBehavior(uiComponent:UIComponent):void
		{
			if (uiComponent.width == 0 && isNaN(uiComponent.percentWidth))
				uiComponent.percentWidth = 100;
		}

		public static function heightTo100PercentDefaultBehavior(uiComponent:UIComponent):void
		{
			if (uiComponent.height == 0 && isNaN(uiComponent.percentHeight))
				uiComponent.percentHeight = 100;
		}

		public static function widthHeightTo100PercentDefaultBehavior(uiComponent:UIComponent):void
		{
			if (uiComponent.width == 0 && uiComponent.height == 0 && isNaN(uiComponent.percentWidth) && isNaN(uiComponent.percentHeight))
			{
				uiComponent.percentWidth = 100;
				uiComponent.percentHeight = 100;
			}
		}

		public static function findMyParentMDIWindow(component:UIComponent):MDIWindow
		{
			var p:UIComponent = component;
			while (p)
				if (p is MDIWindow)
					return p as MDIWindow;
				else
					p = p.parent as UIComponent;

			return null;
		}
	}
}
