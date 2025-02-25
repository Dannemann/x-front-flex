package br.com.dannemann.gui.effect
{
	import spark.effects.Fade;

	public final class DEffectFadeIn2 extends Fade
	{
		public function DEffectFadeIn2(target:Object=null, duration:int=300)
		{
			alphaFrom = .3;
			alphaTo = 1;
			this.duration = duration;
			this.target = target;
		}
	}
}
