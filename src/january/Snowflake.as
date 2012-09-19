package january
{
	import flash.utils.getDefinitionByName;
	import january.snowflakes.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Snowflake extends FlxSprite
	{		
		// List of classes for getDefinitionByName() to use
		Chord; Large; Octave; Small; Wind; Key;
		
		/** The type of snowflake in question. */
		public static var type : String;
		
		/** The volume of the generated note */
		public var noteVolume : Number = 0;
		
		public function Snowflake():void
		{	
			super(x, y);		
			
			exists = false;
		}
		
		public function spawn():void
		{
			x = Math.random()*(FlxG.width);
			y = 0;
			
			exists = true;
		}
		
		public static function manage() : void
		{				
			if (FlxMath.chanceRoll(70))
				type = "Small";
			else if (FlxMath.chanceRoll(10))
				type = "Key";
			else if (FlxMath.chanceRoll(5))
				type = "Octave";
			else if (FlxMath.chanceRoll(2.5))
				type = "Chord";
			else if (FlxMath.chanceRoll(1))
				type = "Wind";
			else
				type = "Large";
			
			// use strings above to instantiate proper Snowflake Subclass.
			var SubClass : Class = getDefinitionByName( "january.snowflakes." + type ) as Class;	
			var flake : Object = PlayState.snow.recycle(SubClass) as SubClass;
			flake.spawn();
			
		}
		
		override public function update():void
		{
			//////////////
			// MOVEMENT //
			//////////////
			
			if (exists)
			{
				velocity.y = 10;
				velocity.x = (Math.sin(y / 5) * 5);
			}	
			
			super.update();
			
			///////////////
			// COLLISION //
			///////////////
			
			if (y > FlxG.height || x < 0) kill();			
		}
		
		public function onLick():void
		{
			Audio.generate(noteVolume, x);
			super.kill();
		}
	}
}