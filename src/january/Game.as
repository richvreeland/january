package january
{			
	import flash.display.*;
	import flash.events.*;
	import january.colorlayers.*;
	import january.snowflakes.*;
	import january.music.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Game extends FlxState
	{				
		// SCORE RELATED /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Initial Score. */
		private static const SCORE_INIT: int = 0;
		/** Scores of various Snowflakes. */
		public static var scores: Object = {"Large": 0, "Chord": 0, "Harmony": 0, "Octave": 0, "Transpose": 0, "Vamp": 0};
		/** The highest flake score. */
		public static var mostLickedScore: int = 0;
		/** The type of flake licked most. */
		public static var mostLickedType: String = "";
		
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
		private static var title: Title;
		/** The text sprite displayed at the end of the game.*/
		private static var gameOverText: FlxText;
		/** The feedback text for secret features. */
		public static var secretFeedback: Text;
		/** An array of strings depicting the various secrets. */
		private static var secrets: Array = [
			"Secret: H is for heuristics.",
			"Secret: M is for moving to mediums beyond.",
			"Secret: COMMA and DOT will help you plot.",
			"Secret: K is the key, or is it the keys?",
			"Secret: P is for pedaling, pedaling is the point.",
			"Secret: White lets you write. In a sense.",
			"Secret: Green is a repeating machine.",
			"Secret: The BRACKETS yield three styles.",
			"Secret: Yellow does as White does, but Green does not remember.",
			"Secret: Look back. Hear things differently.",
			"Secret: ENTER and RETURN, turn and turnabout.",
			"Secret: CONTROL is for control freaks.",
			"Secret: BACK to square one, SLASH what you've done."];
		
		// TIME-RELATED ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Time before first Snowflake spawns. */
		private static const SPAWNRATE_INIT: int = 6000;
		/** Time between Snowflake spawns when Score is Zero. */
		private static const SPAWNRATE_ATZERO: int = 12000;
		/** Time between Snowflake spawns after Exiting the House. */
		private static const SPAWNRATE_ATEXITHOUSE: int = 8000;
		/** Rate at which the time between Snowflake spawns is decremented by. */
		private static const SPAWNRATE_DECREMENTER: int = 3;
		/** The amount of time between Snowflake spawns. */
		private static var spawnRate: int = 300;
		/** Number which dictates minimum spawnRate. Higher = slower */
		private static var spawnRateMinMod: int = 16000;
		/** The minimum amount of time allowed between Snowflake spawns. Initialized in create(), recalculated on resize. */
		private static var spawnRateMinimum: int;
		/** The timer for determining when to spawn snowflakes. */
		private static var spawnTimer: FlxDelay;
		
		public static var flamTimer: FlxDelay;
		public static var flamNotes: Array = [];
		private static var flamRate: int = 25;
		private static var flamCounter: int = 0;
		
		// MISCELLANEOUS /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** The determined width of the game in full-screen mode. */
		private static var fullScreenWidth: uint;
		/** Whether or not the player is outside. */
		private static var outside: Boolean = true;
		/** Whether or not the player has exited the house. */
		public static var end: Boolean = false;
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Initialize game, create and add everything. */
		override public function create():void
		{					
			//FlxG.stage.removeEventListener(MouseEvent.CLICK, fullScreen);
			FlxG.score = SCORE_INIT;
			FlxG.volume = 1;		
			FlxG.playMusic(Ambience, Note.MAX_VOLUME / 5); FlxG.music.fadeIn(2);
			FlxG.sounds.maxSize = 32;
			
			// Set Channel 1 Instrument to Guitar
			MIDI.trackEvents.push(0);
			MIDI.trackEvents.push(193);
			MIDI.trackEvents.push(24);
			
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
			Playback.numbers = new Text(); add(Playback.numbers);
			secretFeedback = new Text(); add(secretFeedback);
			
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
			HUD.init(); add(HUD.chordData); add(HUD.modeData); add(HUD.noteData);
			
			// Create Backgrounds (keep order in tact for proper blending)				
			haze   = new Haze();	add(haze);
			night  = new Night();	add(night);
			black  = new Black();	add(black);	
			
			// Add Fireflies.
			//fireflies = new FlxGroup();	add(fireflies);	
			
			// Create Game Over Layer
				gameOverText = new FlxText(0, 0, 320, "");
				gameOverText.setFormat("frucade", 8, 0xFFFFFFFF);
				gameOverText.scrollFactor.x = 0;
				gameOverText.exists = false;
			add(gameOverText);
			add(HUD.midiButton);
			
			// Create Camera Lens and Rails (Lens Follows the Rails Object)													
			Camera.init(); add(Camera.anchor); add(Camera.lens);	FlxG.resetCameras(Camera.lens);					
			
			// Start Timers
			spawnRateMinimum = (1/FlxG.width) * spawnRateMinMod;
			spawnTimer = new FlxDelay(SPAWNRATE_INIT);
			
			flamTimer = new FlxDelay(flamRate);
			
			// Set Initial Mode to Ionian or Aeolian.
			Mode.index = Helper.pickFrom(0, 4);
			Mode.init();
			
			super.create();
		}
		
		/** Called every frame. */
		override public function update():void
		{																	
			// Timer callback, used to flam out notes in chords, etc. Awesome!
			flamTimer.callback = function():void
			{
				if (flamNotes[0] != null && flamCounter <= flamNotes.length - 1)
				{
					var note:FlxSound = flamNotes[flamCounter];
					note.play();
					MIDI.log(note.classType, note.volume);
					flamCounter++;
					flamTimer.reset(flamRate);
				}
				else
				{
					flamCounter = 0;
					flamNotes = [];
					flamTimer.abort();
				}
			}
			
			// Spawn snowflakes when timer expires.
			spawnTimer.callback = function():void
			{					
				if (FlxG.score == 0)
					spawnTimer.reset(SPAWNRATE_ATZERO);
				else
				{						
					if (spawnRate <= spawnRateMinimum)
						spawnRate = spawnRateMinimum;
					
					spawnTimer.reset(spawnRate);
				}				
				Snowflake.manage();
			}	
				
			// Camera Behavior
			Camera.logic();
							
			super.update();	
			
			// Wait until player moves to spawn first snowflake.
			if (FlxG.score == SCORE_INIT)
				if ((FlxG.keys.RIGHT || FlxG.keys.D) && spawnTimer.isRunning == false && end == false)
					spawnTimer.start();
			
			// Loop Sky Background
			if (sky.x < -716) sky.x = 0;
			
			// Collision Check
			if (player.tongueUp) FlxG.overlap(snow, player, onLick);
			
			// Check for Player Entering House
			if (player.x > houseRight.x + 8) enterHouse();
			
			// Key input checks for secret features!.
			if (FlxG.score > 0)
			{
				HUD.toggle(); Mode.cycle(); Key.toggle(); Pedal.toggle(); Playback.modes(); Playback.polarity(); Playback.resetRestart(); //Record.off();
			}
			
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
		 * Called when the player's tongue is up, and hits a snowflake.
		 *  
		 * @param SnowRef		The Snowflake licked.
		 * @param PlayerRef		The Player sprite.
		 * 
		 */
		public function onLick(SnowRef: Snowflake, PlayerRef: Player):void
		{			
			SnowRef.onLick();
			SnowRef.fly();
			haze.onLick();
			night.onLick();
			
			spawnRate -= SPAWNRATE_DECREMENTER;
			
			// What to do on first snowlick of a "new" game.
			if (FlxG.score == 1)
			{
				if (end == true)
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
				FlxG.play(Asset.DOOR_OPEN, Note.MAX_VOLUME * 0.5, 1);
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
				HUD.hide();
				Playback.numbers.kill();
				secretFeedback.kill();
				
				// Stop camera anchor and move it all the way to the beginning.
				Camera.anchor.x = FlxG.worldBounds.x;
				Camera.anchor.velocity.x = 0;
				
				player.x = houseLeft.x + 185;
				
				FlxG.play(Asset.DOOR_CLOSE, Note.MAX_VOLUME * 0.5, -1);
				FlxG.music.fadeIn(1);
				
				haze.alphaDown(0,0);
				night.alphaDown(15,0);
				black.alphaDown(3);
				
				FlxG.score = 0;
				
				spawnTimer.reset(SPAWNRATE_ATEXITHOUSE);
				
				outside = true;
				end = true;
			}
		}
		
		/** Called when the game is over. Shows the game over layer. */
		public function gameOver():void
		{			
			FlxG.stage.displayState = StageDisplayState.NORMAL;
			
			FlxG.music.fadeOut(0.01);
			black.alphaUp(0.01);
			black.fill(0xFF75899C);
			
			//score stuff for save name and end title.
			var score:int = scores["Large"];
			var kind:String = "Large";
			for (var item:* in scores)
			{
				if (scores[item] > score)
				{
					score = scores[item];
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

			mostLickedScore = score;
			mostLickedType = kind;
			
			if (Helper.chanceRoll(50))
				gameOverText.text = Helper.randomPull(secrets);
			
			FlxG.stage.addEventListener(MouseEvent.MOUSE_DOWN, MIDI.generate);
			
			FlxG.mouse.show();
			gameOverText.x = (FlxG.width - gameOverText.realWidth) / 2; gameOverText.y = 30;
			HUD.midiButton.x = (FlxG.width - HUD.midiButton.width)/2; HUD.midiButton.y = 90;
			gameOverText.exists = HUD.midiButton.exists = true;
			snow.kill(); player.kill();
			
			// Will start Camera.lens rails back up
			//Camera.anchor.x += FlxG.width;
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
				FlxCamera.defaultZoom = Math.floor(FlxG.stage.stageWidth / January.INIT_WIDTH); //- 1;			
				fullScreenWidth = FlxG.stage.stageWidth / FlxCamera.defaultZoom;
				FlxG.width = fullScreenWidth;
				FlxCoreUtils.gameContainer.y = (FlxG.stage.stageHeight - (FlxG.height * FlxCamera.defaultZoom)) / 2;
				// use this if switching to fullscreen while in PlayState
				//Camera.anchor.x += (fullScreenWidth - January.INIT_WIDTH);
			}
			else			
			{
				FlxG.width = January.INIT_WIDTH;
				FlxCamera.defaultZoom = January.INIT_ZOOM;
				FlxCoreUtils.gameContainer.y = 0;
				if (player.x < Camera.lens.scroll.x + January.INIT_WIDTH)
					Camera.anchor.x -= (fullScreenWidth - January.INIT_WIDTH);
			}
			
			// if PlayState is the current state
			if (FlxG.state == FlxG.state as Game)
			{
				FlxG.resetCameras(Camera.lens = new FlxCamera(0, 0, FlxG.width + 1, FlxG.height));	
				Camera.lens.setBounds(FlxG.worldBounds.x, 0, FlxG.worldBounds.width, FlxG.height);
				Camera.lens.deadzone = new FlxRect(0, 0, FlxG.width + 1, FlxG.height);
				Camera.lens.target = Camera.anchor;
				
				spawnRateMinimum = (1/FlxG.width) * spawnRateMinMod;
				
				if (end == true)
				{
					gameOverText.x = (FlxG.width - gameOverText.realWidth) / 2;
					HUD.midiButton.x = (FlxG.width - HUD.midiButton.width) / 2;
				}
				else
					HUD.midiButton.x = FlxG.width - HUD.midiButton.width - 3;
			}
			else
				FlxG.resetCameras(new FlxCamera(0, 0, FlxG.width + 1, FlxG.height));
		}
	}
}