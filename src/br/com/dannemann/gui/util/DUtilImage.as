package br.com.dannemann.gui.util
{
	import br.com.dannemann.gui.filter.DFilterBlackAndWhite;
	import br.com.dannemann.gui.filter.DFilterRed;
	
	import mx.controls.Image;

	public final class DUtilImage
	{
		public static function filterBlackAndWhite(image:Image):void
		{
			image.filters = [ new DFilterBlackAndWhite() ];
		}

		public static function filterRed(image:Image):void
		{
			image.filters = [ new DFilterRed() ];
		}

		public static function removeAllFilters(image:Image):void
		{
			image.filters = [];
		}
	}
}
