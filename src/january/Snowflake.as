package january
{
	import com.*;
	
	import flash.utils.*;
	
	import january.snowflakes.*;
	
	import org.flixel.*;
	
	public class Snowflake extends FlxSprite
	{		
		// List of classes for getDefinitionByName() to use
		Chord; Large; Octave; Small; Pedal; Key;
		
		/** The type of snowflake in question. */
		protected var _type: String;

		/** The point value of each snowflake */
		protected var _pointValue: int;
		
		public static var windX : Number = 0;
		public static var windY : Number = 0;
		
		/** Whether or not pedal point mode is on. */
		public static var pedalPointMode : Boolean = false;
		
		public static var headway : Number = 5;
		
		/** The volume of the generated note */
		public var noteVolume : Number = 0;
		
		public function Snowflake():void
		{	
			super(x, y);		
			
			exists = false;
		}
		
		public function spawn():void
		{
			headway = (-windX * 8);
			
			x = Math.random()*(FlxG.width + headway);
			y = 0;
				
			// Set _type to class name ie. "Small"
			_type = getQualifiedClassName(this);
			_type = _type.substring(20);
			
			exists = true;
		}
		
		public static function manage() : void
		{				
			// Snowflake spawning probabilities
			var _flakes		: Array = ["Small", "Large", "Octave", "Pedal", "Chord", "Key"];
			var _weights	: Array = [ 83    ,  10    ,  3      ,  2     ,  1.5   ,  0.5 ];
			
			// All Flakes are Spawned based on weighted probability, except for the first one.
			var _flake: String;
			if (FlxG.score == 0 && PlayState.textOutput.storyOver == false)
				_flake = "Small";
			else
			 	_flake = _flakes[Helpers.weightedChoice(_weights)];
			
			// use string above to instantiate proper Snowflake Subclass.
			var subClass : Class = getDefinitionByName( "january.snowflakes." + _flake ) as Class;	
			var flake : Object = PlayState.snow.recycle(subClass) as subClass;
			flake.spawn();
			
		}
		
		/** Getters let you access properties from outside, as if they were public! Read Only. */
		public function get type():String
		{
			return _type;
		}
		
		override public function update():void
		{
			//////////////
			// MOVEMENT //
			//////////////
			
			velocity.y = 10 + windY;
			velocity.x = (Math.sin(y / 5) * 5) - headway + windX;
			
			super.update();
			
			///////////////
			// COLLISION //
			///////////////
			
			if (y > FlxG.height || x < (0 - width))
				kill();			
		}
		
		public function onLick():void
		{						
			FlxG.score += _pointValue;
			
			super.kill();
		}
	}
}