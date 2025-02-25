package br.com.dannemann.gui.util
{
	import flash.events.MouseEvent;

	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.effects.Effect;
	import mx.effects.Move;
	import mx.effects.Sequence;
	import mx.events.EffectEvent;

	public final class DUtilEffect
	{
		// TODO: REMOVE THIS METHOD!!!
		public static function addEffectsTo_RollOVerOut(component:UIComponent, effectIn:Effect, effectOut:Effect, target:UIComponent=null):void
		{
			component.addEventListener(
				MouseEvent.ROLL_OVER,
				function (event:MouseEvent):void
				{
					effectIn.target = target ? target : component;
					effectIn.play();
				}, false, 0, true);

			component.addEventListener(
				MouseEvent.ROLL_OUT,
				function (event:MouseEvent):void
				{
					if (effectOut)
					{
						effectOut.target = target ? target : component;
						effectOut.play();
					}
					else
						effectIn.end();
				}, false, 0, true);
		}

		public static function shakeContainer(window:Container):void
		{
			const shakeEffect:Sequence = new Sequence();
			shakeEffect.addEventListener(EffectEvent.EFFECT_END, focusTarget);
			var move:Move;

			for (var i:uint = 0, j:int = 10; i < 6; i++)
			{
				move = new Move();
				move.duration = 45;

				switch (i)
				{
					case 0:
						move.xBy = 5;
						break;
					case 5:
						move.xBy = -5;
						break;
					default:
						move.xBy = j * -1;
						j *= -1;
						break;
				}

				shakeEffect.addChild(move);
			}

			shakeEffect.play([window]);

			function focusTarget(e:EffectEvent):void
			{
				window.removeEventListener(EffectEvent.EFFECT_END, focusTarget);
			}
		}
	}
}
