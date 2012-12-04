package january.snowflakes
{
	import flash.utils.*;
	
	import january.*;
	import january.music.*;
	
	import org.flixel.*;
	
	public class Harmony extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/harmony.png")] private var sprite: Class;
		
		/* Score to introduce this flake at. */
		public static const INTRODUCE_AT: int = 25;
		/** Default volume level for the harmony tone (not the default note). */
		public static const VOLUME: Number = Note.MAX_VOLUME * 0.33;
		
		public function Harmony()
		{
			super();
			
			loadGraphic(sprite, true, false, 5, 5);
			offset.x = 1;
			offset.y = 1;
			
			windY = 13;
			volume = Helper.rand(Note.MAX_VOLUME * 0.33, Note.MAX_VOLUME * 0.83);
			
			addAnimation("default", [0,0,0,0,0,0,0,0,1,0,1], 6, true);
			addAnimation("firefly", [3,2,3,2,2,2,2,2,2,2,2], 6, true);
			
			pedalAllowed = true;
		}
		
		public override function onLick():void
		{			
			super.onLick();
			
			playNote();
			playHarmonyTone();
		}
		
		private function playHarmonyTone():void
		{					
			var harmonyTone: Class;
			var choices: Array = [];	
			var i:Object = Intervals.loadout;
			
				 if (Note.lastAbsolute == i.one1) choices = [i.thr1, i.fiv1, i.thr2, i.fiv2];
			else if (Note.lastAbsolute == i.two1) choices = [i.fiv1, i.sev1, i.fiv2];
			else if (Note.lastAbsolute == i.thr1) choices = [i.fiv1, i.one2];
			else if (Note.lastAbsolute == i.for1) choices = [i.fiv1, i.one2, i.two2];
			else if (Note.lastAbsolute == i.fiv1) choices = [i.thr1, i.sev1, i.thr2];
			else if (Note.lastAbsolute == i.six1) choices = [i.one2, i.thr2];
			else if (Note.lastAbsolute == i.sev1) choices = [i.thr1, i.fiv1, i.thr2];
			else if (Note.lastAbsolute == i.one2) choices = [i.fiv1, i.thr2, i.fiv2];
			else if (Note.lastAbsolute == i.two2) choices = [i.fiv1, i.fiv2, i.sev2];
			else if (Note.lastAbsolute == i.thr2) choices = [i.sev1, i.one2, i.fiv2, i.sev2, i.one3];
			else if (Note.lastAbsolute == i.for2) choices = [i.two2, i.fiv2, i.one3];
			else if (Note.lastAbsolute == i.fiv2) choices = [i.thr2, i.sev2, i.thr3];
			else if (Note.lastAbsolute == i.six2) choices = [i.one3, i.thr3];
			else if (Note.lastAbsolute == i.sev2) choices = [i.thr2, i.fiv2, i.thr3];
			else if (Note.lastAbsolute == i.one3) choices = [i.thr2, i.fiv2, i.thr3, i.fiv3];
			else if (Note.lastAbsolute == i.two3) choices = [i.fiv2, i.sev2, i.fiv3];
			else if (Note.lastAbsolute == i.thr3) choices = [i.sev2, i.one3, i.fiv3, i.sev3, i.one4];
			else if (Note.lastAbsolute == i.for3) choices = [i.two3, i.fiv3, i.one4];
			else if (Note.lastAbsolute == i.fiv3) choices = [i.thr3, i.sev3, i.one4];
			else if (Note.lastAbsolute == i.six3) choices = [i.thr3, i.one4];
			else if (Note.lastAbsolute == i.sev3) choices = [i.thr3, i.fiv3];
			else if (Note.lastAbsolute == i.one4) choices = [i.thr3, i.fiv3];
			else FlxG.log("lastAbsolute not available for Harmony");
			
			harmonyTone = choices[Helper.randInt(0, choices.length - 1)];
			
			var harmony:FlxSound;
			
			if (timbre == "Primary")
				harmony = FlxG.loadSound(harmonyTone, Harmony.VOLUME, -1*pan);
			else
			{
				var modifiedHarmony: Class = getDefinitionByName("_" + getQualifiedClassName(harmonyTone) ) as Class;
				harmony = FlxG.loadSound(modifiedHarmony, Harmony.VOLUME/_volumeMod, -1*pan);
			}
			
			Game.flamNotes.push(harmony);
			Game.flamTimer.start();
			
			// LOGS
			Note.lastHarmony = harmonyTone;
			MIDI.log(harmonyTone, Harmony.VOLUME);
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