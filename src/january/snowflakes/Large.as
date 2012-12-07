package january.snowflakes
{
	import january.*;
	import january.music.*;
	
	import org.flixel.*;
	
	public class Large extends Snowflake
	{
		[Embed(source="../assets/art/flakes/large.png")] private var sprite: Class;
		
		private static var switchedOff: Boolean;
		
		public function Large()
		{
			super();
					
			loadGraphic(sprite, true, false, 4, 4);
			offset.x = 1;
			offset.y = 1;
			
			windY = 10;
			volume = Helper.rand(Note.MAX_VOLUME * 0.5, Note.MAX_VOLUME * 0.75);
			
			addAnimation("default",[0],0,false);
			addAnimation("firefly",[1],0,false);
			
			pedalAllowed = true;
		}

		public override function onLick():void
		{			
			super.onLick();
			
			if (Note.lastRecorded != null)
				playNote();
			else
				playInitial();
		}
		
		protected override function spawn(flakeType: String, spawnX: Number = 0):void
		{
			if (FlxG.score == 0)
				spawnX = Camera.lens.scroll.x + FlxG.width/2;
			else
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
		
		/** Called only once. Plays the very first note. */
		private function playInitial():void
		{
			//FlxG.log("playInitial()");
			
			// PREPARE AND PLAY
			pan = 0;
			Intervals.populate();
			i = Intervals.loadout;
			Note.initial = i[Intervals.DATABASE[Helper.randInt(0, Intervals.DATABASE.length / 2)]];
			FlxG.play(Note.initial, volume);
			
			// LOGS
			Note.lastRecorded = Note.initial;
			Note.lastAbsolute = Note.lastRecorded;
			MIDI.log(Note.lastAbsolute, volume);
			HUD.logNote(volume, pan); HUD.logMode();
			
			// PUSH NOTE TO PLAYBACK SEQUENCE
			manageSequence();
		}
	}
}