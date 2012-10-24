package january.snowflakes
{
	import january.*;
	import january.music.*;
	
	public class Chord extends Snowflake
	{	
		[Embed(source="../assets/art/flakes/chord.png")] private var sprite: Class;
		
		public function Chord()
		{
			super();
			
			loadGraphic(sprite, true, false, 5, 5);
			
			_windY = 16;
			_pointValue = 1;
			
			addAnimation("default", [0,1,2,3], 3, true);
			addAnimation("licked" , [3,2,1,0], 3, true);
		}
		
		public override function onLick():void
		{
			super.onLick();
			
			Mode.change();
			playChord();
		}
		
		public override function update():void
		{
			super.update();
			
			if (_licked == false)
				play("default");
			else
				play("licked");
		}
	}
}