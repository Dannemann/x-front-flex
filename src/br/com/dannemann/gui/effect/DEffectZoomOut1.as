package br.com.dannemann.gui.effect
{
	import mx.effects.Zoom;

	public final class DEffectZoomOut1 extends Zoom
	{
		public function DEffectZoomOut1(target:Object=null)
		{
			duration = 500;
			zoomHeightTo = 1;
			this.target = target;
		}
	}
}
