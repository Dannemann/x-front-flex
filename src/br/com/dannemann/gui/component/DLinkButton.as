package br.com.dannemann.gui.component
{
	import br.com.dannemann.gui.effect.DEffectBlueGlowAnimatedFilter1;
	import br.com.dannemann.gui.util.DUtilEffect;

	import mx.controls.LinkButton;

	public class DLinkButton extends LinkButton implements DComponent
	{
		public function DLinkButton()
		{
			DUtilEffect.addEffectsTo_RollOVerOut(this, new DEffectBlueGlowAnimatedFilter1(), null);
		}
	}
}
