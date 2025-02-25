package br.com.dannemann.gui.renderer
{
	import mx.controls.advancedDataGridClasses.AdvancedDataGridSortItemRenderer;

	public final class DRendererADGSortableHeadersWithNoNumbers extends AdvancedDataGridSortItemRenderer
	{
		override protected function childrenCreated():void
		{
			super.childrenCreated();

			removeChildAt(0);
		}
	}
}
