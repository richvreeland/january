package january
{			
	import flash.display.*;
	import flash.events.*;
	import january.colorlayers.*;
	import january.music.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Game extends FlxState
	{		
		// COLOR LAYERS //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** A color layer of haze. */
		private static var haze: Haze;
		/** A color layer that makes it night time. */
		public static var night: Night;
		/** A color layer used for fading to black. */
		private static var black: Black;
		
		// TILEMAPS //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Tilemap of ground tiles. */
		public static var ground: FlxTilemap;
		/** Tilemap of tree tiles. */
		private static var trees: FlxTilemap;
		/** Tilemap of trees in the far distance. */
		private static var backtrees: FlxTilemap;
		
		// SPRITES ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Sprite of the sky. */
		private static var sky: FlxSprite;
		/** Sprite of the distant mountain. */
		private static var mountain: FlxSprite;
		/** Sprite of the house on the left. */
		private static var houseLeft: FlxSprite;
		/** Sprite of the house on the right. */
		public static var houseRight: FlxSprite;		
		/** The player sprite. */
		public static var player: Player;
		/** All of the snowflakes. */
		public static var snow: FlxGroup;
		/** All of the "fireflies", which are the licked, illuminated snowflakes. */
		public static var fireflies: FlxGroup;		
		
		// TEXT-RELATED //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** The title sprite, which says "January". */
		public static var title: Title;
		/** The text sprite used to display number feedback. */
		public static var textOutput: Text;	
		/** The text sprite displayed at the end of the game.*/
		private static var gameOverText: FlxText;
		/** The "Save as MIDI" button. */
		public static var midiButton: Button = new Button();
		
		// MISCELLANEOUS /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** The timer for determining when to spawn snowflakes. */
		public static var spawnTimer: FlxDelay;
		/** The determined width of the game in full-screen mode. */
		public static var fullScreenWidth: uint;
		/** Whether or not the player is outside. */
		private static var outside: Boolean = true;
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Initialize game, create and add everything. */
		override public function create():void
		{					
			FlxG.stage.removeEventListener(MouseEvent.CLICK, fullScreen);
			FlxG.score = Global.SCORE_INIT;
			FlxG.volume = 1;		
			FlxG.playMusic(Asset.AMBIENCE, Global.NOTE_MAX_VOLUME * 6.66); FlxG.music.fadeIn(2);
			
			//	Build World		
				sky = new FlxSprite(0, 0, Asset.SKY);
				sky.scrollFactor.x = 0;
				sky.velocity.x = -2;
			add(sky);
				mountain = new FlxSprite(270, 72, Asset.MOUNTAIN);
				mountain.scrollFactor.x = 0.025;
			add(mountain);	
				backtrees = new FlxTilemap();
				backtrees.y = 89;
				backtrees.scrollFactor.x = 0.075;
				backtrees.loadMap(new Asset.BACKTREE_MAP , Asset.BACK_TREES, 13, 7);
			add(backtrees);		
				title = new Title();
			add(title); 			
				ground = new FlxTilemap();
				ground.loadMap(new Asset.LEVEL_MAP, Asset.GROUND, 16);
				ground.x = 0;
			add(ground);	
				trees = new FlxTilemap();
				trees.y = 83;
				trees.scrollFactor.x = 0.25;
				trees.loadMap(new Asset.TREE_MAP, Asset.TREES, 51, 13);
			add(trees);
			
			//	Set World Bounds, for optimization purposes.
			FlxG.worldBounds.x = 180;
			FlxG.worldBounds.width = ground.width;
			FlxG.worldBounds.y = 78;
			FlxG.worldBounds.height = FlxG.height - FlxG.worldBounds.y;	
			
			// Add Feedback Text
			textOutput = new Text(); add(textOutput);
			
			// Draw Player
			player = new Player(); add(player);
			
			//	Build Houses
				houseLeft = new FlxSprite(50, 16);
				houseLeft.loadGraphic(Asset.HOUSE,false,true);
				houseLeft.facing = FlxObject.LEFT;
			add(houseLeft);
				houseRight = new FlxSprite(2768, 16, Asset.HOUSE);
			add(houseRight);
			
			// Create Snow
			snow = new FlxGroup(); add(snow);
			
			// Add HUD
			HUD.init(); add(HUD.keysData); add(HUD.modeData); add(HUD.noteData);
			
			// Create Backgrounds (keep order in tact for proper blending)				
			haze   = new Haze();	add(haze);
			night  = new Night();	add(night);
			black  = new Black();	add(black);	
			
			// Add Fireflies.
			fireflies = new FlxGroup();	add(fireflies);		
			
			// Create Game Over Layer
				gameOverText = new FlxText(0, 0, 320, "");
				gameOverText.setFormat("frucade", 8, 0xFFFFFFFF);
				gameOverText.scrollFactor.x = 0;
				gameOverText.exists = false;
			add(gameOverText);
			add(midiButton);
			
			// Create Camera Lens and Rails (Lens Follows the Rails Object)													
			Camera.init(); add(Camera.rails); add(Camera.lens);	FlxG.resetCameras(Camera.lens);					
			
			// Start Spawn Timer
			spawnTimer = new FlxDelay(Global.SPAWNRATE_INIT);
			
			super.create();
		}
		
		/** Called every frame. */
		override public function update():void
		{											
			// Spawn snowflakes when timer expires.
			spawnTimer.callback =	function():void
									{				
										if (FlxG.score == 0)
											spawnTimer.reset(Global.SPAWNRATE_ATZERO);
										else
										{						
											if (Global.spawnRate <= Global.SPAWNRATE_MINIMUM)
												Global.spawnRate = Global.SPAWNRATE_MINIMUM;
											
											spawnTimer.reset(Global.spawnRate);
										}				
										Snowflake.manage();
									}	
				
			// Camera Behavior
			Camera.logic();
							
			super.update();	
			
			// Wait until player moves to spawn first snowflake.
			if ((FlxG.keys.RIGHT || FlxG.keys.D) && FlxG.score == Global.SCORE_INIT && spawnTimer.isRunning == false && Global.newGame == false)
				spawnTimer.start();
			
			// Loop Sky Background
			if (sky.x < -716) sky.x = 0;
			
			// Collision Check
			if (player.tongueUp) FlxG.overlap(snow, player, onLick);
			
			// Check for Player Entering House
			if (player.x > houseRight.x + 8) enterHouse();
			
			// Toggle HUD
			HUD.toggle();
			
			// Keep MIDI Timer in check, to get appropriate time values for logging.
			if (Note.lastAbsolute != null)
				MIDI.timer += FlxG.elapsed;
			if (MIDI.logged == true)
			{
				MIDI.timer = 0;
				MIDI.logged = false;
			}
		}
		
		/**
		 * Called when the overlap check for snow and player passes.
		 * Runs the various onLick functions!
		 */
		public function onLick(SnowRef: Snowflake, PlayerRef: Player):void
		{			
			SnowRef.onLick();
			SnowRef.fly();
			haze.onLick();
			night.onLick();
			
			Global.spawnRate -= Global.SPAWNRATE_DECREMENTER;
			
			// What to do on first snowlick of a "new" game.
			if (FlxG.score == 1)
			{
				if (Global.newGame == true)
					gameOver();
				else
				{
					player.play("tongueDown");
					player.tongueUp = false;
				}
			}
			
		}
		
		/** Called When Player "Enters House" */
		public function enterHouse():void
		{			
			if (outside == true)
			{
				FlxG.play(Asset.DOOR_OPEN, Global.NOTE_MAX_VOLUME * 0.5, 1);
				FlxG.music.fadeOut(1);
				player.tongueUp = false;
				outside = false;
			}
			
			black.alphaUp(1, 1, exitHouse, 2);
		}
		
		/** Called When Player "Exits House" */
		public function exitHouse():void
		{		
			if (outside == false)
			{
				Camera.rails.x = FlxG.worldBounds.x;
				Camera.rails.velocity.x = 0;
				player.x = houseLeft.x + 185;
				FlxG.play(Asset.DOOR_CLOSE, Global.NOTE_MAX_VOLUME * 0.5, -1);
				FlxG.music.fadeIn(1);
				haze.alphaDown(0,0);
				night.alphaDown(15,0);
				black.alphaDown(3);
				FlxG.score = 0;
				spawnTimer.reset(Global.SPAWNRATE_ATEXITHOUSE);
				outside = true;
				Global.newGame = true;
			}
		}
		
		/** Called when the game is over. Shows the game over layer. */
		public function gameOver():void
		{			
			FlxG.music.fadeOut(0.01);
			black.alphaUp(0.01);
			black.fill(0xFF75899C);
			
			//score stuff for save name and end title.
			var score:int = Global.scores["Large"];
			var kind:String = "Large";
			for (var item:* in Global.scores)
			{
				if (Global.scores[item] > score)
				{
					score = Global.scores[item];
					kind = item;
				}
			}
			
			if (kind == "Transpose")
				gameOverText.text = "You ate your way to " + score + " Key Changes.";
			else if (kind == "Harmony")
				gameOverText.text = "You thought it wise to add a harmony note " + score + " times.";
			else if (kind == "Chord")
				gameOverText.text = "You ate " + score + " Chords, which is an odd thing to do.";
			else if (kind == "Octave")
				gameOverText.text = "You heard you liked Octaves, so you put " + score + " Octaves on your notes.";
			else if (kind == "Vamp")
				gameOverText.text = "You vamped " + score + " times. For lack of a better word.";
			else
				gameOverText.text = "You ate a lot of snow. But it doesn't have to end here.";
			
			Global.mostLickedScore = score;
			Global.mostLickedType = kind;
			
			FlxG.mouse.show();
			gameOverText.x = (FlxG.width - gameOverText.realWidth) / 2; gameOverText.y = 30;
			midiButton.x = (FlxG.width - midiButton.width)/2;	midiButton.y = 90;
			gameOverText.exists = midiButton.exists = true;
			snow.kill(); player.kill();
			
			// Will start Camera.lens rails back up
			//Camera.rails.x += FlxG.width;
		}
		
		/** Called when switching to full-screen interactive mode. */
		public static function fullScreen(e:Event = null):void
		{	 
			if (FlxG.stage.displayState == StageDisplayState.NORMAL)
				FlxG.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;			 		
		}
		
		/** Called everytime the display is resized, ie. when toggling fullscreen mode. */
		public static function resize(e:Event = null):void
		{					
			// If We're in Full Screen Interactive Mode
			if (FlxG.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
			{			
				FlxCamera.defaultZoom = Math.floor(FlxG.stage.stageWidth / January.INIT_WIDTH) - 1;			
				fullScreenWidth = FlxG.stage.stageWidth / FlxCamera.defaultZoom;				
				FlxG.stage.align = StageAlign.LEFT;
				FlxG.width = fullScreenWidth;
				// use this if switching to fullscreen while in PlayState
				//Camera.rails.x += (fullScreenWidth - January.INIT_WIDTH);
			}
			else			
			{
				FlxG.width = January.INIT_WIDTH;
				FlxCamera.defaultZoom = January.INIT_ZOOM;			
				if (player.x < Camera.lens.scroll.x + January.INIT_WIDTH)
					Camera.rails.x -= (fullScreenWidth - January.INIT_WIDTH);
			}
			
			// if PlayState is the current state
			if (FlxG.state == FlxG.state as Game)
			{
				FlxG.resetCameras(Camera.lens = new FlxCamera(0, 0, FlxG.width + 1, FlxG.height));	
				Camera.lens.setBounds(FlxG.worldBounds.x, 0, FlxG.worldBounds.width, FlxG.height);
				Camera.lens.deadzone = new FlxRect(0, 0, FlxG.width + 1, FlxG.height);
				Camera.lens.target = Camera.rails;
				
				if (Global.newGame == true)
				{
					gameOverText.x = (FlxG.width - gameOverText.realWidth) / 2;
					midiButton.x = (FlxG.width - midiButton.width) / 2;
				}
				else
					midiButton.x = FlxG.width - midiButton.width - 3;
			}
			else
				FlxG.resetCameras(new FlxCamera(0, 0, FlxG.width + 1, FlxG.height));
		}
	}
}