package br.com.dannemann.gui.effect
{
	import mx.effects.Zoom;

	public final class DEffectZoomIn1 extends Zoom
	{
		public function DEffectZoomIn1(target:Object=null)
		{
			duration = 500;
			zoomHeightTo = 0;
			this.target = target;
		}
	}
}
