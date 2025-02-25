package br.com.dannemann.gui.filter
{
	import spark.filters.ColorMatrixFilter;

	public final class DFilterRed extends ColorMatrixFilter
	{
		public const _bwMatrix:Array = [ 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 9, 1, 0, 0 ];

		public function DFilterRed()
		{
			matrix = _bwMatrix;
		}
	}
}
