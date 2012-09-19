package january
{	
	import january.snowflakes.*;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class PlayState extends FlxState
	{
		[Embed(source = "../assets/maps/level.txt", mimeType = "application/octet-stream")] protected var _levelMap: Class;
		[Embed(source = "../assets/maps/trees.txt", mimeType = "application/octet-stream")] protected var _treeMap : Class;
		[Embed(source = "../assets/maps/sky.txt", mimeType = "application/octet-stream")] 	protected var _skyMap  : Class;
		
		[Embed(source = "../assets/art/ground.png")] 	protected var _groundImg: Class;
		[Embed(source = "../assets/art/trees.png")] 	protected var _treeImg	: Class;
		[Embed(source = "../assets/art/sky.png")] 		protected var _skyImg	: Class;
		
		//SOUNDS
		[Embed(source = "../assets/audio/ambience.swf", symbol = "snow_01.aif")] protected var _ambience:Class;
		[Embed(source = "../assets/audio/door_open.mp3")] 						 protected var _doorOpen:Class;
		[Embed(source = "../assets/audio/door_close.mp3")] 						 protected var _doorClose:Class;
		
		protected var _ground: FlxTilemap;
		protected var _trees : FlxTilemap;
		protected var _sky 	 : FlxSprite;
		
		public static var player: Player;
		public static var snow 	: FlxGroup;
		
		protected var spawnTimer: FlxDelay;
		
		override public function create():void
		{					
			FlxG.mouse.hide();
			
			// Play Background Audio
			FlxG.play(_ambience, 2, 0, true).fadeIn(1);
			
			// Set Background Color
			FlxG.bgColor = 0xFFd8e3e5;
			
			// Build Skymap		
			_sky = new FlxSprite(0, 0, _skyImg);
			_sky.scrollFactor.x = 0;
			_sky.velocity.x = -5;
			add(_sky);
			
			// Build Tilemap
			_ground = new FlxTilemap();
			_ground.loadMap(new _levelMap, _groundImg, 16);
			add(_ground);
			
			// Build Treemap
			_trees = new FlxTilemap();
			_trees.y = 83;
			_trees.scrollFactor.x = 0.25;
			_trees.loadMap(new _treeMap, _treeImg, 51, 15);
			add(_trees);
			
			// Draw Player
			player = new Player();
			add(player);
						
			// Create Snow
			snow = new FlxGroup();
			add(snow);
			
			// Start Spawn Timer
			spawnTimer = new FlxDelay(50);
			spawnTimer.start();
			
			super.create();
		}
		
		override public function update():void
		{								
			// Spawn snowflakes when timer expires.
			spawnTimer.callback =
				function():void
				{
					Snowflake.manage();
					spawnTimer.reset(50);
				}
			
			super.update();
			
			// Collision Check
			FlxG.overlap(snow, player, player.onCollision);
			
			// Loop Sky Background
			if (_skyMap.x < -716) _skyMap.x = 0;

		}
		


	}
}