package january
{
	import flash.utils.getDefinitionByName;
	
	import january.snowflakes.*;
	
	import org.flixel.*;
	
	public class Snowflake extends FlxSprite
	{		
		// List of classes for getDefinitionByName() to use
		Chord; Large; Octave; Small; Pedal; Key;
		
		/** The type of snowflake in question. */
		public static var type : String;
		
		public static var windX : Number = 0;
		public static var windY : Number = 0;
		
		/** Whether or not pedal point mode is on. */
		public static var pedalPointMode : Boolean = false;
		
		public static var headway : Number;
		
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
			
			exists = true;
		}
		
		public static function manage() : void
		{				
			if (Helpers.chanceRoll(75))
				type = "Small";
			else if (Helpers.chanceRoll(5))
				type = "Key";
			else if (Helpers.chanceRoll(5))
				type = "Octave";
			else if (Helpers.chanceRoll(1))
				type = "Chord";
			else if (Helpers.chanceRoll(10))
				type = "Pedal";
			else
				type = "Large";
			
			// use strings above to instantiate proper Snowflake Subclass.
			var SubClass : Class = getDefinitionByName( "january.snowflakes." + type ) as Class;	
			var flake : Object = PlayState.snow.recycle(SubClass) as SubClass;
			flake.spawn();
			
		}
		
		public function get velocityX():Number
		{
			return velocity.x;
		}
		
		override public function update():void
		{
			//////////////
			// MOVEMENT //
			//////////////
			
			velocity.y = 10 + windY;
			velocity.x = (Math.sin(y / 5) * 5) - 5 + windX;
			
			super.update();
			
			///////////////
			// COLLISION //
			///////////////
			
			if (y > FlxG.height || x < (0 - width)) kill();			
		}
		
		public function onLick():void
		{			
			Music.generate(noteVolume, x);
			super.kill();
		}
	}
}