package january
{			
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import january.colorlayers.*;
	
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
		[Embed(source = "../assets/art/hills.png")] 	private static var _hillsImg: Class;
		[Embed(source = "../assets/art/cabin.png")]		private static var _houseImg	: Class;
		
		//SOUNDS
		[Embed(source = "../assets/audio/ambience.swf", symbol = "snow_01.aif")] private static var _ambience: Class;
		[Embed(source = "../assets/audio/door_open.mp3")] 						 private static var _doorOpen: Class;
		[Embed(source = "../assets/audio/door_close.mp3")] 						 private static var _doorClose:Class;
		
		private static var haze:  Haze;
		public static var night: Night;
		private static var black: Black;

		public static var textOutput: Text;
		public static var controls: Controls;
		
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
		public static var snow: FlxGroup;
		public static var fireflies: FlxGroup;
		public static var residue: Residue;
		
		public static var camera: FlxCamera;
		public static var cameraRails: FlxSprite;
		
		private static var _spawnTimer: FlxDelay;
		
		[Embed(source="../assets/art/cursor.png")] private static var note : Class;
		
		private static var title: FlxText;
		private static var titleNote: FlxSprite;
		
		public static var fullScreenWidth: uint;
		
		override public function create():void
		{					
			FlxG.stage.removeEventListener(MouseEvent.CLICK, fullScreen);
			
			//	Kill Mouse, Initialize Score, Set Global Volume to 1.
			FlxG.mouse.hide();
			FlxG.score = Global.SCORE_INIT;
			FlxG.volume = 1;
			
			//	Play Background Audio
			FlxG.playMusic(_ambience, 2);
			FlxG.music.fadeIn(2);
			
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
			FlxG.worldBounds.width = ground.width;
			FlxG.worldBounds.y = 78;
			FlxG.worldBounds.height = FlxG.height - FlxG.worldBounds.y;
			
			//	Build Trees
			_backtrees = new FlxTilemap();
			_backtrees.y = 89;
			_backtrees.scrollFactor.x = 0.075;
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
			player = new Player();	add(player);

			//	Build Houses
			_houseLeft = new FlxSprite(50, 16);
			_houseLeft.loadGraphic(_houseImg,false,true);
			_houseLeft.facing = FlxObject.LEFT;
			add(_houseLeft);
			houseRight = new FlxSprite(2768, 16, _houseImg);
			add(houseRight);
						
			// Create Snow
			snow = new FlxGroup();	add(snow);
			
			// Add HUD
			HUD.init();
			add(HUD.keysData);
			add(HUD.modeData);
			add(HUD.noteData);
			
			// Create Backgrounds (keep order in tact for proper blending)				
			haze   = new Haze();	add(haze);
			night  = new Night();	add(night);
			black  = new Black();	add(black);
			
			// Add Fireflies.
			fireflies = new FlxGroup();	add(fireflies);
			
//				residue = new Residue();
//			add(residue);
//			
//				controls = new Controls();
//			add(controls);
			
			// Demo End Layer
				title = new FlxText(160, 53, 320, "fin");
				title.setFormat("frucade", 8, 0xFFFFFFFF);
				title.scrollFactor.x = 0;
				title.visible = false;
			add(title);
			
				titleNote = new FlxSprite(160, 70, note);
				titleNote.scrollFactor.x = 0;
				titleNote.visible = false;
			add(titleNote);
			
			// Create Camera and Camera Rails (Camera Follows Rails Object)													
				cameraRails = new FlxSprite(Global.CAMERA_X_INIT + FlxG.width + 1, FlxG.height - 1);		
				cameraRails.makeGraphic(1,1,0xFFFF0000);		
				cameraRails.maxVelocity.x = 9;
				cameraRails.visible = false;	
			add(cameraRails);
			
				camera = new FlxCamera(0, 0, FlxG.width + 1, FlxG.height);
				camera.setBounds(FlxG.worldBounds.x, 0, FlxG.worldBounds.width, FlxG.height);
				camera.deadzone = new FlxRect(0, 0, FlxG.width + 1, FlxG.height);
				camera.target = cameraRails;
			add(camera);		
			
			FlxG.resetCameras(camera);
			
			// Start Spawn Timer
			_spawnTimer = new FlxDelay(Global.SPAWNRATE_INIT);
			_spawnTimer.start();
			
			super.create();
		}
		
		override public function update():void
		{								
			// Spawn snowflakes when timer expires.
			_spawnTimer.callback =
				function():void
				{				
					if (FlxG.score == 0)
						_spawnTimer.reset(Global.SPAWNRATE_ATZERO);
					else
					{						
						if (Global.spawnRate <= Global.SPAWNRATE_MINIMUM)
							Global.spawnRate = Global.SPAWNRATE_MINIMUM;
						
						_spawnTimer.reset(Global.spawnRate);
					}
					
					Snowflake.manage();
				}
							
			super.update();	
			
			// Loop Sky Background
			if (_sky.x < -716) _sky.x = 0;
			
			// Toggle HUD
			HUD.toggle();
			
			// Collision Check
			FlxG.overlap(snow, player, onLick);
			
			// Check for Player Entering House
			if (player.x > houseRight.x + 5) enterHouse();
						
			// Camera Behavior
			cameraLogic();
		}
		
		/**
		 * Called when the overlap check for snow and player passes.
		 * Runs the various onLick functions!
		 */
		public function onLick(SnowRef: Snowflake, PlayerRef: Player):void
		{			
			if (FlxG.keys.UP || FlxG.keys.W || FlxG.keys.justReleased("UP") || FlxG.keys.justReleased("W"))
			{
				SnowRef.onLick();
				SnowRef.fly();
				//controls.onLick();
				//textOutput.onLick(SnowRef);
				//residue.onLick(SnowRef);
				haze.onLick();
				night.onLick();
				
				Global.spawnRate -= Global.SPAWNRATE_DECREMENTER;
				
				// What to do on first snowlick of a "new" game.
				if (FlxG.score == 1 && Global.newGame == true)
				{
					// demo end stuff
					FlxG.music.fadeOut(0.01);
					black.alphaUp(0.01);
					title.x = titleNote.x = FlxG.width/2 - 5;
					title.visible = titleNote.visible = true;
					snow.kill();
					player.kill();
					
					// Will start camera rails back up
					//cameraRails.x += FlxG.width;
				}
			}
			
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
					
					// Prevent the very last (super delayed) pixel movement of the camera lerp from happening.
					if (cameraRails.x > ground.width - 1)
						cameraRails.x = ground.width - 1;
					
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
				haze.alphaDown(0,0);
				night.alphaDown(15,0);
				black.alphaDown(3);
				FlxG.score = 0;
				_spawnTimer.reset(Global.SPAWNRATE_ATEXITHOUSE);
				_outside = true;
				Global.newGame = true;
			}
		}
		
		public static function fullScreen(e:Event = null):void
		{	 
			if (FlxG.stage.displayState == StageDisplayState.NORMAL)
				FlxG.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;			 		
		}
		
		public static function resize(e:Event = null):void
		{					
			if (FlxG.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
			{			
				FlxCamera.defaultZoom = Math.floor(FlxG.stage.stageWidth / January.INIT_WIDTH) - 1;
				
				fullScreenWidth = FlxG.stage.stageWidth / FlxCamera.defaultZoom;
				
				FlxG.stage.align = StageAlign.LEFT;
				FlxG.width = fullScreenWidth;
				// use this if switching to fullscreen while in PlayState
				//cameraRails.x += (fullScreenWidth - January.INIT_WIDTH);
			}
			else			
			{
				FlxG.width = January.INIT_WIDTH;
				FlxCamera.defaultZoom = January.INIT_ZOOM;
				
				if (player.x < camera.scroll.x + January.INIT_WIDTH)
					cameraRails.x -= (fullScreenWidth - January.INIT_WIDTH);
			}
			
			// if PlayState is the current state
			if (FlxG.state == FlxG.state as PlayState)
			{
				FlxG.resetCameras(camera = new FlxCamera(0, 0, FlxG.width + 1, FlxG.height));	
				camera.setBounds(FlxG.worldBounds.x, 0, FlxG.worldBounds.width, FlxG.height);
				camera.deadzone = new FlxRect(0, 0, FlxG.width + 1, FlxG.height);
				camera.target = cameraRails;
				
				title.x = titleNote.x = FlxG.width/2 - 5;
			}
			
		}

	}

}