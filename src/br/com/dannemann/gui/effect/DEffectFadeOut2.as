package br.com.dannemann.gui.effect
{
	import spark.effects.Fade;

	public final class DEffectFadeOut2 extends Fade
	{
		public function DEffectFadeOut2(target:Object=null, duration:int=300)
		{
			alphaFrom = 1;
			alphaTo = .3;
			this.duration = duration;
			this.target = target;
		}
	}
}
