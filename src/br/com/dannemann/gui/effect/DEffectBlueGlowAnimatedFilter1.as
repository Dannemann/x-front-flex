package br.com.dannemann.gui.effect
{
	import br.com.dannemann.gui.domain.StrConsts;
	
	import spark.effects.AnimateFilter;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.filters.GlowFilter;

	public final class DEffectBlueGlowAnimatedFilter1 extends AnimateFilter
	{
		public const _glowFilter:GlowFilter = new GlowFilter();
		public const _simpleMotionPath:SimpleMotionPath = new SimpleMotionPath();

		public function DEffectBlueGlowAnimatedFilter1(target:Object=null)
		{
			_glowFilter.blurX = 20;
			_glowFilter.blurY = 20;
			_glowFilter.color = 0x80FFFF;

			_simpleMotionPath.property = StrConsts._FLEX_STYLE_PROPERTY_ALPHA;
			_simpleMotionPath.valueFrom = 0;
			_simpleMotionPath.valueTo = 1;

			motionPaths = new Vector.<MotionPath>();
			motionPaths.push(_simpleMotionPath);
			bitmapFilter = _glowFilter; 
			duration = 600
			repeatCount = 0 
			repeatBehavior = StrConsts._FLEX_PROPERTY_REVERSE;
			
			this.target = target;
		}
	}
}
