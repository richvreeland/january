package january
{
	import org.flixel.*;
	
	public class Title extends FlxSprite
	{
		[Embed(source="../assets/art/title.png")] private static var sprite: Class;
		
		private static var lifespan: Number = 2.5;
		
		public function Title():void
		{		
			super(x,y);	
			loadGraphic(sprite, true, false, 164, 42);
			y = 30;
			scrollFactor.x = 0;
			addAnimation("animation",[0,1,2,3,2,1],7,true);
			alpha = 0;
			visible = false;
		}
		
		override public function update():void
		{						
			x = (FlxG.width - width)/2;		
			
			if (FlxG.score > 0)
			{
				visible = true;
				play("animation");
				
				if (lifespan > 0)
				{
					alpha += FlxG.elapsed;
					lifespan -= FlxG.elapsed;
					if (alpha > 1)
						alpha = 1;
					if (lifespan <= 0)
						lifespan = 0;
				}
				else
					alpha -= FlxG.elapsed/4;
						
				if (alpha <= 0)
					kill();				
			}
			
			super.update();
		}
	}
}