package br.com.dannemann.gui.filter
{
	import spark.filters.ColorMatrixFilter;

	public final class DFilterBlackAndWhite extends ColorMatrixFilter
	{
		public const _rLum:Number = 0.2225;
		public const _gLum:Number = 0.7169;
		public const _bLum:Number = 0.0606;
		public const _bwMatrix:Array = [ _rLum, _gLum, _bLum, 0, 0, _rLum, _gLum, _bLum, 0, 0, _rLum, _gLum, _bLum, 0, 0, 0, 0, 0, 1, 0 ];

		public function DFilterBlackAndWhite()
		{
			matrix = _bwMatrix;
		}
	}
}
