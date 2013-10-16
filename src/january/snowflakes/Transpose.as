package january.snowflakes
{
	import flash.utils.*;
	import january.*;
	import january.music.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Transpose extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/transpose.png")] private var sprite : Class;
		
		public function Transpose()
		{
			super();
			
			loadGraphic(sprite, true, false, 5, 6);
			
			windY = 15;
			
			addAnimation("default", [0,1,2,3,4,3,2,1], 3, true);
			
			volume = Helper.rand(Note.MAX_VOLUME * 0.33, Note.MAX_VOLUME * 0.83);
		}
		
		public override function onLick():void
		{			
			super.onLick();
			
			Mode.change();
			Key.change();
			fadeOutDissonance();
			playNote();
			playChord();
		}
		
		public override function update():void
		{
			super.update();
			
			play("default");
		}
		
		private function fadeOutDissonance():void
		{
			var sound:FlxSound;
			var g:uint = 0;
			
			var i:Object = Intervals.loadout;
			
			// Run through all sounds.
			outerLoop: while (g < FlxG.sounds.length)
			{
				sound = FlxG.sounds.members[g++] as FlxSound;
				
				// If the sound has volume,
				if (sound != null && sound.active == true)
				{
					// Compare to current key notes.
					for each (var note:Class in i)
					{
						if (sound.classType == note)
							continue outerLoop;
						
						if (sound.classType == getDefinitionByName("_" + getQualifiedClassName(note) ) as Class)
							continue outerLoop;
					}
					
					// If a note made it this far, it's not in the current key, so fade it out. 
					sound.fadeOut(0.2);	
				}
			}
		}
		
	}
	
}