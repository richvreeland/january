package january.snowflakes
{
	import flash.utils.*;	
	import january.*;
	import january.music.*;
	import org.flixel.*;
	
	public class Octave extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/octave.png")] private var sprite: Class;
		
		/* Score to introduce this flake at. */
		public static const INTRODUCE_AT: int = 10;
		/** Default volume level for the octave tone (not the default note). */
		public static const VOLUME: Number = Note.MAX_VOLUME * 0.33;
		/** The probability weight for spawning this flake type. */
		public static const WEIGHT: Number = 3.5;
		
		public function Octave():void
		{
			super();
			
			loadGraphic(sprite, false, false, 5, 5);
			offset.x = 1;
			offset.y = 1;
			
			windY = 14;
			volume = Helper.rand(Note.MAX_VOLUME * 0.33, Note.MAX_VOLUME * 0.83);
			
			addAnimation("default", [0],0,false);
			addAnimation("firefly", [1],0,false);
			
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
			
			// LOGS
			Note.lastOctave = octaveTone;
			MIDI.log(octaveTone, Octave.VOLUME);
		}
		
		protected override function spawn(flakeType:String, spawnX:Number=0):void
		{
			spawnX = Helper.randInt(Camera.lens.scroll.x + headwayX, Camera.anchor.x);
			
			super.spawn(flakeType, spawnX);
		}
		
		public override function update():void
		{
			super.update();
			
			if (licked == false)
				play("default");
			else
				play("firefly");
		}
	}
}