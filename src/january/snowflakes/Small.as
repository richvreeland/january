package january.snowflakes
{
	import january.*;
	import january.music.*;
	import org.flixel.*;

	public class Small extends Snowflake
	{	
		public function Small()
		{			
			super();
			
			makeGraphic(1, 1);
			
			windY = 10;
			volume = Helper.rand(Note.MAX_VOLUME * 0.33, Note.MAX_VOLUME * 0.83);
			
			pedalAllowed = true;
		}
		
		public override function onLick():void
		{							
			super.onLick();
			
			if (Game.onAutoPilot)
			{
				if (Helper.chanceRoll(5))
				{
					if (Playback.mode == "Repeat")
					{
						if (Helper.chanceRoll(50))
							Playback.write();
						else
							Playback.detour();
					}
					else if (FlxG.score > 0)
						Playback.repeat();
				}
			}
			
			if (Game.inImprovMode || Game.onAutoPilot)
			{
				if (Helper.chanceRoll(4)) Scale.toPentatonic();
				if (Helper.chanceRoll(4)) Playback.staccato();
				
				if (Pedal.mode == false && Helper.chanceRoll(2))
					Pedal.toggle();
				else if (Pedal.mode  && Helper.chanceRoll(5))
					Pedal.toggle();
			}
			
			if (Game.inImprovMode)
			{
				if (Helper.chanceRoll(1))		Mode.change();
				if (Helper.chanceRoll(0.25)) {	Mode.change(); Key.change(); }
			}
			
			playNote();
		}
	}
}