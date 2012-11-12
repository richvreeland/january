package january
{
	import org.flixel.*;
	
	/** Color Layers are sprites whose alpha values can be faded from anywhere in the draw order. */
	public class ColorLayer extends FlxSprite
	{
		/** The duration of the given effect. */
		protected var duration		: Number;
		/** The desired alpha value when the effect is done, on a scale of 0 - 1. */
		protected var desiredAlpha	: Number;
		/** Whether the instance of ColorLayer is on or not. */
		public 	  var layerOn		: Boolean;
		/** Color to fill the layer with. */
		protected var fillColor		: uint;
		/** How long to wait before callback function. */
		protected var callbackDelay	: Number = 0;
		/** Callback timer. */
		protected var callbackTimer	: Number = 0;
		/** Callback Function called on complete of fade. */
		protected var alphaUpOnComplete:Function;
		/** Callback Function called on complete of flash. */
		protected var alphaDownOnComplete:Function;
		
		/** Create a new ColorLayer and set it to fill the screen, but hide it. */
		public function ColorLayer():void
		{
			super();
			makeGraphic(FlxG.width + 1, FlxG.height, 0xFFFFFFFF, true);
			scrollFactor.x = scrollFactor.y = 0;
			alpha = 0;
			exists = false;
		}
		
		/** Override this function in subclasses to use onLick event listener. */
		public function onLick():void {}
		
		/**	
		 * Fades the alpha value up, in the direction of 0 --> 1
		 * 
		 * @param Duration
		 * @param DesiredAlpha
		 * @param OnComplete
		 * @param CallbackDelay
		 */	
		final public function alphaUp (Duration: Number = 1, DesiredAlpha: Number = 1, OnComplete: Function = null, CallbackDelay: Number = 0): void
		{
			fill(fillColor);
			duration = Duration;
			desiredAlpha = DesiredAlpha;
			alphaUpOnComplete = OnComplete;
			callbackDelay = CallbackDelay;
			exists = true;
		}
		
		/**
		 * Fades the alpha value down, in the direction of 1 --> 0
		 * 
		 * @param Duration
		 * @param DesiredAlpha
		 * @param OnComplete
		 * @param CallbackDelay
		 */		
		final public function alphaDown (Duration: Number = 1, DesiredAlpha: Number = 0, OnComplete: Function = null, CallbackDelay: Number = 0): void
		{
			fill(fillColor);
			duration = Duration;
			desiredAlpha = DesiredAlpha;
			alphaDownOnComplete = OnComplete;
			callbackDelay = CallbackDelay;
			exists = true;
		}
		
		/** Check for alpha value. If it's reach it's desired result, stop the effect. */
		override public function update():void
		{			
			if (alpha > desiredAlpha)
				alpha -= FlxG.elapsed/duration;
			else if (alpha < desiredAlpha)
				alpha += FlxG.elapsed/duration;
			else
			{								
				callbackTimer += FlxG.elapsed;
				
				if (callbackTimer > callbackDelay)
				{
					if (alphaDownOnComplete != null)
						alphaDownOnComplete();
					if (alphaUpOnComplete != null)
						alphaUpOnComplete();
					callbackTimer = callbackDelay;
				}
			}	
		}
	}
}