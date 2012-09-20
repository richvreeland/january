package january
{			
	import january.snowflakes.*;
	import january.colorlayers.*;
	
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
		[Embed(source = "../assets/audio/ambience.swf", symbol = "snow_01.aif")] protected var _ambience: Class;
		[Embed(source = "../assets/audio/door_open.mp3")] 						 protected var _doorOpen: Class;
		[Embed(source = "../assets/audio/door_close.mp3")] 						 protected var _doorClose:Class;
		
		public static var HUDkey  : FlxText;
		public static var HUDnote : FlxText;
		public static var HUDevent: FlxText;
		
		public static var dusk:  Dusk;
		public static var haze:  Haze;
		public static var night: Night;
		public static var black: Black;
		
		public static var storyData:  StoryData;
		public static var strings: 	  Array;
		public static var textOutput: Text;
		
		protected var _ground: FlxTilemap;
		protected var _trees : FlxTilemap;
		protected var _sky 	 : FlxSprite;
		
		public static var player: Player;
		public static var snow 	: FlxGroup;
		
		protected var _spawnTimer: FlxDelay;
		protected var _resetTime: int;
		
		override public function create():void
		{					
			//	Kill Mouse, Initialize Score.
			FlxG.mouse.hide();
			FlxG.score = 0;
			
			//	Play Background Audio
			FlxG.play(_ambience, 2, 0, true).fadeIn(1);
			
			//	Set Background Color
			FlxG.bgColor = 0xFFd8e3e5;
			
			//	Build Skymap		
				_sky = new FlxSprite(0, 0, _skyImg);
				_sky.scrollFactor.x = 0;
				_sky.velocity.x = -2;
			add(_sky);
			
			//	Build Tilemap
				_ground = new FlxTilemap();
				_ground.loadMap(new _levelMap, _groundImg, 16);
			add(_ground);
			
			//	Build Treemap
				_trees = new FlxTilemap();
				_trees.y = 83;
				_trees.scrollFactor.x = 0.25;
				_trees.loadMap(new _treeMap, _treeImg, 51, 15);
			add(_trees);
			
			// Add Feedback Text
				textOutput = new Text();
			add(textOutput);
			
			// Draw Player
				player = new Player();
			add(player);
						
			// Create Snow
				snow = new FlxGroup();
			add(snow);
			
			// Create Backgrounds (keep order in tact for proper blending)
				dusk  = new Dusk();
				haze  = new Haze();
				night = new Night();
				black = new Black();
			add(dusk);
			add(haze);
			add(night);
			add(black);
			
			// Add HUD
			addHUD();
			
			// Prepare Story
			storyData = new StoryData();
			  strings = storyData.toString().split("\n");
			
			// Start Spawn Timer
			_spawnTimer = new FlxDelay(6000);
			_spawnTimer.start();
			
			super.create();
		}
		
		override public function update():void
		{											
			// Spawn snowflakes when timer expires.
			_spawnTimer.callback =
				function():void
				{				
					if (textOutput.storyOver == false && FlxG.score == 0)
						_spawnTimer.reset(12000);
					else
					{
						_spawnTimer.reset(_resetTime);
						
						if (_resetTime < 25)
							_resetTime = 25;
					}
					
					Snowflake.manage();
				}
			
			super.update();	
			
			// Loop Sky Background
			if (_sky.x < -716) _sky.x = 0;
			
			// Toggle HUD
			toggleHUD();
			
			// Collision Check
			FlxG.overlap(snow, player, onLick);
		}
		
		/**
		 * Called when the overlap check for snow and player passes.
		 * Runs the various onLick functions!
		 */
		public function onLick(SnowRef: Snowflake, PlayerRef: Player):void
		{
			if (FlxG.keys.UP || FlxG.keys.W)
			{
				SnowRef.onLick();
				textOutput.onLick(SnowRef.type);
				haze.onLick();
				dusk.onLick();
				night.onLick();
				
				_resetTime = 500 - (FlxG.score * 4);
			}		
		}
		
		/**
		 * Instantiates HUD.
		 */
		public function addHUD() : void
		{				
			// Add Last Note Text
			HUDnote = new FlxText(10, 8, 256, "Note: ");
			HUDnote.alignment = "left";
			add(HUDnote);
			
			// Add Event Text
			HUDevent = new FlxText(125, 8, 256, "Event: ");
			HUDevent.alignment = "left";
			add(HUDevent);
			
			// Add Key Text
			HUDkey = new FlxText(225, 8, 256, "Key: ");
			HUDkey.alignment = "left";
			add(HUDkey);
			
			// Hide HUD by default.
			HUDkey.exists 	= false;
			HUDnote.exists 	= false;
			HUDevent.exists = false;
		}
		
		/**
		 * Turns HUD on or off.
		 */ 
		public function toggleHUD() : void
		{
			if(FlxG.keys.justPressed("H") == true)
			{
				HUDkey.exists   = !HUDkey.exists;
				HUDnote.exists  = !HUDnote.exists;
				HUDevent.exists = !HUDevent.exists;
			}
			
		}
		


	}
}