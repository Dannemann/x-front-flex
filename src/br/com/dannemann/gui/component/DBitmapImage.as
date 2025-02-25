package br.com.dannemann.gui.component
{

	import spark.primitives.BitmapImage;

	public final class DBitmapImage extends BitmapImage implements DComponent
	{
		public function DBitmapImage(source:Object=null)
		{
			this.source = source;
		}
	}
}
