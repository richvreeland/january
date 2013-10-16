package january.snowflakes
{
	import flash.utils.*;	
	import january.*;
	import january.music.*;
	import org.flixel.*;
	
	public class Octave extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/octave.png")] private var sprite: Class;
		
		/** Default volume level for the octave tone (not the default note). */
		public static const VOLUME: Number = Note.MAX_VOLUME * 0.33;
		/** The probability weight for spawning this flake type. */
		public static const WEIGHT: Number = 3.5;
		
		public function Octave():void
		{
			super();
			
			loadGraphic(sprite);
			
			windY = 14;
			volume = Helper.rand(Note.MAX_VOLUME * 0.33, Note.MAX_VOLUME * 0.83);
			
			pedalAllowed = true;
		}
		
		public override function onLick():void
		{
			super.onLick();
			
			playNote();	
			playOctave();
		}
		
		private function playOctave():void
		{		
			var octaveTone: Class;
			
			outerLoop: for (var i:int = 0; i <= Note.DATABASE.length - 1; i++)
			{								
				if (Note.lastAbsolute == Note.DATABASE[i])
				{
					while (octaveTone == null)
						octaveTone = Note.DATABASE[i + Helper.pickFrom(12, -12)] as Class;
					
					break outerLoop;
				}
			}
			
			var octave:FlxSound;
			
			if (timbre == "Primary")
				octave = FlxG.loadSound(octaveTone, Octave.VOLUME, -1*pan);
			else
			{
				var modifiedNote: Class = getDefinitionByName("_" + getQualifiedClassName(octaveTone) ) as Class;
				octave = FlxG.loadSound(modifiedNote, Octave.VOLUME/_volumeMod, -1*pan);
			}
			
			Game.flamNotes.push(octave);
			Game.flamTimer.start();
			
			inStaccato(octave);
			
			// LOGS
			Note.lastOctave = octaveTone;
		}
	}
}