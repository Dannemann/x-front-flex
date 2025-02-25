package br.com.dannemann.gui.effect
{
	import spark.effects.Fade;

	public final class DEffectFadeOut1 extends Fade
	{
		public function DEffectFadeOut1(target:Object=null, duration:int=300)
		{
			alphaFrom = 1;
			alphaTo = 0;
			this.duration = duration;
			this.target = target;
		}
	}
}
