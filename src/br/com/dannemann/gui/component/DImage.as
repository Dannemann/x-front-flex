package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.util.DUtilImage;

	import mx.controls.Image;

	public final class DImage extends Image implements DComponent
	{
		public var _useBlackAndWhiteForDisabledMode:Boolean = true;

		public function DImage(source:Object=null)
		{
			this.source = source;
		}

		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;

			if (_useBlackAndWhiteForDisabledMode)
				if (value)
					DUtilImage.removeAllFilters(this);
				else
					DUtilImage.filterBlackAndWhite(this);
		}
	}
}
