package january
{
	import org.flixel.*;
	
	/** This class lets you perform flashes and fades, similar to FlxG.flash / FlxG.fade.
	 * BUT, you can do it from ANYWHERE in the draw order!
	 * 
	 */
	public class ColorLayer extends FlxSprite
	{
		/** The duration of the given effect. */
		protected var _delay:Number;
		
		/** The desired alpha value when the effect is done, on a scale of 0 - 1. */
		protected var _desiredAlpha:Number;
		
		/** Whether the instance of ColorLayer is on or not. */
		protected var _layerOn:Boolean;
		
		/**
		 * Create a new ColorLayer and set it to fill the screen, but hide it.
		 */
		public function ColorLayer():void
		{
			super();
			makeGraphic(FlxG.width, FlxG.height, 0xFFFFFF, true);
			scrollFactor.x = scrollFactor.y = 0;
			alpha = 0;
			exists = false;
		}
		
		public function onLick():void
		{			
		}
		
		/**
		 * fade() is a color fade over time, with support for alpha and blending
		 *  
		 * @param Color			Starting color of the fade effect.
		 * @param Duration		Duration of the fade effect.
		 * @param Blend			Set a blend mode, eg. 'multiply'
		 */		
		final protected function fade (Color : uint, Duration : Number = 1, Blend : String = null) : void
		{
			fill(Color);
			_delay = Duration;
			blend = Blend;
			exists = true;
		}
		
		/**
		 * flash() lets you flash a color, which fades over time. Also supports blend modes.
		 *  
		 * @param Color			Starting color of the flash effect.
		 * @param Duration		Duration of the flash effect.
		 * @param Blend			Set a blend mode, eg. 'multiply'
		 */	
		final protected function flash ( Color : uint, Duration : Number = 1, Blend : String = null) : void
		{
			fill(Color);
			_delay = Duration;
			blend = Blend;
			alpha = 1;
			exists = true;
		}
		
		/**
		 * Check for alpha value. If it's reach it's desired result, stop the effect. 
		 */
		override public function update():void
		{
			if (_desiredAlpha == 0)
			{
				alpha -= FlxG.elapsed/_delay;	
				
				if (alpha <= _desiredAlpha)
					alpha = _desiredAlpha;
			}
			else
			{				
				alpha += FlxG.elapsed/_delay;
				
				if (alpha >= _desiredAlpha)
					alpha = _desiredAlpha;
			}
			
		}
		
	}
	
}