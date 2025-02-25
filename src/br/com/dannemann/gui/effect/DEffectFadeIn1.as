package br.com.dannemann.gui.effect
{
	import spark.effects.Fade;

	public final class DEffectFadeIn1 extends Fade
	{
		public function DEffectFadeIn1(target:Object=null, duration:int=300)
		{
			alphaFrom = 0;
			alphaTo = 1;
			this.duration = duration;
			this.target = target;
		}
	}
}
