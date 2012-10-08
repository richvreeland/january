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
		protected var _duration:Number;
		
		/** The desired alpha value when the effect is done, on a scale of 0 - 1. */
		protected var _desiredAlpha:Number;
		
		/** Whether the instance of ColorLayer is on or not. */
		protected var _layerOn:Boolean;
		
		protected var _fillColor:uint;
		
		public var start:Boolean;
		
		protected var _callbackDelay:Number = 0;
		protected var _callbackTimer:Number = 0;
		
		protected var _fadeOnComplete:Function;
		protected var _flashOnComplete:Function;
		
		/**
		 * Create a new ColorLayer and set it to fill the screen, but hide it.
		 */
		public function ColorLayer():void
		{
			super();
			makeGraphic(FlxG.width + 1, FlxG.height, 0xFFFFFFFF, true);
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
		final public function alphaUp (Duration: Number = 1, DesiredAlpha: Number = 1, OnComplete: Function = null, CallbackDelay: Number = 0): void
		{
			fill(_fillColor);
			_duration = Duration;
			_desiredAlpha = DesiredAlpha;
			_fadeOnComplete = OnComplete;
			_callbackDelay = CallbackDelay;
		
			exists = true;
		}
		
		/**
		 * flash() lets you flash a color, which fades over time. Also supports blend modes.
		 *  
		 * @param Color			Starting color of the flash effect.
		 * @param Duration		Duration of the flash effect.
		 * @param Blend			Set a blend mode, eg. 'multiply'
		 */	
		final public function alphaDown (Duration: Number = 1, DesiredAlpha: Number = 0, OnComplete: Function = null, CallbackDelay: Number = 0): void
		{
			fill(_fillColor);
			_duration = Duration;
			_desiredAlpha = DesiredAlpha;
			_flashOnComplete = OnComplete;
			_callbackDelay = CallbackDelay;

			exists = true;
		}
		
		/**
		 * Check for alpha value. If it's reach it's desired result, stop the effect. 
		 */
		override public function update():void
		{			
			if (alpha > _desiredAlpha)
				alpha -= FlxG.elapsed/_duration;
			else if (alpha < _desiredAlpha)
				alpha += FlxG.elapsed/_duration;
			else
			{								
				_callbackTimer += FlxG.elapsed;
				
				if (_callbackTimer > _callbackDelay)
				{
					if (_flashOnComplete != null)
						_flashOnComplete();
					if (_fadeOnComplete != null)
						_fadeOnComplete();
					_callbackTimer = _callbackDelay;
				}
			}
			
		}
		
	}
	
}