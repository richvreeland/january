package january
{			
	import flash.display.*;
	import flash.events.*;
	
	import january.colorlayers.*;
	import january.snowflakes.*;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class PlayState extends FlxState
	{
		//MAPS
		[Embed(source = "../assets/maps/level.txt", mimeType = "application/octet-stream")] 	private static var _levelMap	: Class;
		[Embed(source = "../assets/maps/trees.txt", mimeType = "application/octet-stream")] 	private static var _treeMap 	: Class;
		[Embed(source = "../assets/maps/backtrees.txt", mimeType = "application/octet-stream")] private static var _backtreeMap : Class;
		
		//SPRITES
		[Embed(source = "../assets/art/ground.png")] 	private static var _groundImg	: Class;
		[Embed(source = "../assets/art/trees.png")] 	private static var _treeImg		: Class;
		[Embed(source = "../assets/art/backtrees.png")] private static var _backtreeImg	: Class;
		[Embed(source = "../assets/art/sky.png")] 		private static var _skyImg		: Class;
		[Embed(source = "../assets/art/hills.png")] 		private static var _hillsImg: Class;
		[Embed(source = "../assets/art/cabin.png")]		private static var _houseImg	: Class;
		
		[Embed(source="../assets/art/flakes/small.png")]private static var _pixel:Class;
		
		//SOUNDS
		[Embed(source = "../assets/audio/ambience.swf", symbol = "snow_01.aif")] private static var _ambience: Class;
		[Embed(source = "../assets/audio/door_open.mp3")] 						 private static var _doorOpen: Class;
		[Embed(source = "../assets/audio/door_close.mp3")] 						 private static var _doorClose:Class;
		
		public static var HUDkey  : FlxText;
		public static var HUDnote : FlxText;
		public static var HUDevent: FlxText;
		
		private static var haze:  Haze;
		private static var night: Night;
		private static var black: Black;
		
		public static var storyData:  StoryData;
		public static var strings: 	  Array;
		public static var textOutput: Text;
		
		public static var ground		: FlxTilemap;
		private static var _trees		: FlxTilemap;
		private static var _backtrees	: FlxTilemap;
		private static var _sky			: FlxSprite;
		private static var _hills		: FlxSprite;
		
		private static var _houseLeft : FlxSprite;
		public static var houseRight: FlxSprite;
		private static var _outside: Boolean = true;
		private static var _entered: Boolean;
		
		public static var player: Player;
		public static var tongue: Tongue;
		public static var snow: FlxGroup;
		
		public static var camera: FlxCamera;
		public static var cameraRails: FlxSprite;
		public static var startingX: Number = 420; //420; //2400 for End
		
		private static var _spawnTimer: FlxDelay;
		private static var _resetTime : int = 400;
		
		public static var newGame: Boolean;
		
		override public function create():void
		{					
			//	Kill Mouse, Initialize Score, Set Global Volume to 1.
			FlxG.mouse.hide();
			FlxG.score = 0;
			FlxG.volume = 1;
			
			//	Play Background Audio
			FlxG.playMusic(_ambience, 2);
			FlxG.music.fadeIn(1);
			
			//	Set Background Color
			FlxG.bgColor = 0xFFd8e3e5;
			
			//	Build Skymap		
				_sky = new FlxSprite(0, 0, _skyImg);
				_sky.scrollFactor.x = 0;
				_sky.velocity.x = -2;
			add(_sky);
			
			// Build Hills
			_hills = new FlxSprite(270, 72, _hillsImg);
			_hills.scrollFactor.x = 0.025;
			add(_hills);
			
			//	Build Tilemap
				ground = new FlxTilemap();
				ground.loadMap(new _levelMap, _groundImg, 16);
				ground.x = 0;
			add(ground);
			
			//	Set World Bounds, for optimization purposes.
			FlxG.worldBounds.x = 180;
			FlxG.worldBounds.width = ground.width;//- 160;
			FlxG.worldBounds.height = FlxG.height;
			
			//	Build Trees
				_backtrees = new FlxTilemap();
				_backtrees.y = 89;
				_backtrees.scrollFactor.x = 0.125;
				_backtrees.loadMap(new _backtreeMap, _backtreeImg, 13, 7);
			add(_backtrees);
			
				_trees = new FlxTilemap();
				_trees.y = 83;
				_trees.scrollFactor.x = 0.25;
				_trees.loadMap(new _treeMap, _treeImg, 51, 13);
			add(_trees);				
			
			// Add Feedback Text
				textOutput = new Text();
			add(textOutput);
			
			// Draw Player
				player = new Player();
			add(player);
				tongue = new Tongue();
			add(tongue);
			
			//	Build Houses
				_houseLeft = new FlxSprite(50, 16);
				_houseLeft.loadGraphic(_houseImg,false,true);
				_houseLeft.facing = FlxObject.LEFT;
			add(_houseLeft);
			
				houseRight = new FlxSprite(2768, 16, _houseImg);
			add(houseRight);
						
			// Create Snow
				snow = new FlxGroup();
			add(snow);
			
			// Create Backgrounds (keep order in tact for proper blending)				
				haze   = new Haze();
				night  = new Night();
				black  = new Black();
			add(haze);
			add(night);
			add(black);
			
			// Add HUD
			addHUD();
			
			// Create Camera and Camera Rails (Camera Follows Rails Object)													
				cameraRails = new FlxSprite(startingX + FlxG.width + 1, FlxG.height - 1);		
				cameraRails.makeGraphic(1,1,0xFFFF0000);		
				cameraRails.maxVelocity.x = 10;
				cameraRails.visible = false;	
			add(cameraRails);
			
				camera = new FlxCamera(0, 0, FlxG.width + 1, FlxG.height);
				camera.setBounds(FlxG.worldBounds.x, 0, FlxG.worldBounds.width, FlxG.height);
				camera.deadzone = new FlxRect(0, 0, FlxG.width + 1, FlxG.height);
				camera.target = cameraRails;
			add(camera);		
			
			FlxG.resetCameras(camera);
			
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
			//FlxG.log("Snowflakes: " + snow.length);
			
			// Spawn snowflakes when timer expires.
			_spawnTimer.callback =
				function():void
				{				
					if (FlxG.score == 0)
						_spawnTimer.reset(12000);
					else
					{						
						if (_resetTime <= 35)
							_resetTime = 35;
						
						_spawnTimer.reset(_resetTime);
					}
					
					Snowflake.manage();
				}
							
			super.update();	
			
			// Loop Sky Background
			if (_sky.x < -716) _sky.x = 0;
			
			// Toggle HUD
			toggleHUD();
			
			// Collision Check
			FlxG.overlap(snow, tongue, onLick);
			FlxG.overlap(snow, player, onIncidental);
			
			// Check for Player Entering House
			if (player.x > houseRight.x + 5) enterHouse();
						
			// Camera Behavior
			cameraLogic();	
		}
		
		/** Controls Camera Movement */
		private function cameraLogic():void
		{			
			if (FlxG.score > 0)
			{
				if (player.x <= camera.scroll.x + 25)
				{					
					cameraRails.acceleration.x = 0;								
					cameraRails.drag.x = 10;	
					
					if (cameraRails.velocity.x <= 0)											
					{														
						cameraRails.velocity.x = 0;														
						cameraRails.drag.x = 0;														
					}										
				}								
				else if (camera.scroll.x > ground.width - FlxG.width - 25)										
				{																				
					cameraRails.x -= (cameraRails.x - ground.width)/100;										
					cameraRails.velocity.x *= -2;	
					
					if (cameraRails.velocity.x <= 0)
						cameraRails.velocity.x = 0;										
				}	
				else if (FlxG.score > 0)	
				{
					cameraRails.acceleration.x = 10;
					
					if (cameraRails.velocity.x >= 10)
						cameraRails.acceleration.x = 0;
				}					
				
			}
			
		}
		
		/** Called When Player "Enters House" */
		public function enterHouse():void
		{			
				if (_outside == true)
				{
					FlxG.play(_doorOpen, 0.3, 1);
					FlxG.music.fadeOut(1);
					_outside = false;
				}
				
				black.alphaUp(1, 1, exitHouse, 2);
		}
		
		/** Called When Player "Exits House" */
		public function exitHouse():void
		{		
			if (_outside == false)
			{
				cameraRails.x = FlxG.worldBounds.x;
				player.x = _houseLeft.x + 185;
				FlxG.play(_doorClose, 0.3, -1);
				FlxG.music.fadeIn(1);
				haze.alphaDown(30,0);
				night.alphaDown(30,0);
				black.alphaDown(3);
				FlxG.score = 0;
				_spawnTimer.reset(12000);
				_outside = true;
				newGame = true;
			}
		}
		
		/**
		 * Called when the overlap check for snow and player passes.
		 * Runs the various onLick functions!
		 */
		public function onLick(SnowRef: Snowflake, TongueRef: FlxSprite):void
		{
			if (FlxG.keys.UP || FlxG.keys.W)
			{
				SnowRef.onLick();
				textOutput.onLick(SnowRef);
				haze.onLick();
				night.onLick();
				
				if (_resetTime >= 40)
					_resetTime -= 5;
				
				// Camera Hack, so that it starts up again if you've gone through the house.
				if (FlxG.score == 1 && player.x < startingX)
					cameraRails.x += FlxG.width;
				
				if (textOutput.text == "snow falls..." && _resetTime >= 55)
					_resetTime -= 20;
			}
				
		}
		
		public function onIncidental(SnowRef: Snowflake, PlayerRef: Player):void
		{
			if (FlxG.keys.UP == false && FlxG.keys.W == false)
				SnowRef.kill();
		}
		
		/**
		 * Instantiates HUD.
		 */
		public function addHUD() : void
		{				
			// Add Last Note Text
			HUDnote = new FlxText(6, -2, 256, "Note: ");
			HUDnote.scrollFactor.x = 0;
			HUDnote.font = "frucade";
			add(HUDnote);
			
			// Add Event Text
			HUDevent = new FlxText(2, 8, 256, "Event: ");
			HUDevent.scrollFactor.x = 0;
			HUDevent.font = "frucade";
			add(HUDevent);
			
			// Add Key Text
			HUDkey = new FlxText(11, 18, 256, "Key: ");
			HUDkey.scrollFactor.x = 0;
			HUDkey.font = "frucade";
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
			
//		public static function fullscreen(e:Event = null):void
//		{	 
//			if (FlxG.stage.displayState == StageDisplayState.NORMAL)
//				FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
//			 		
//		}
//		
//		public static function resize(e:Event = null):void
//		{
//			// Align the stage to the absolute center.
//			FlxG.stage.align = "";
//			
//			//FlxG.width = FlxG.stage.stageWidth / FlxCamera.defaultZoom;
//		}

	}

}