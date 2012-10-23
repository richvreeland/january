package january
{
	public class Global
	{	
		public static const SCORE_INIT				:int = 1;
		
		public static const CAMERA_X_INIT			:int = 420;	//2450 for End of Level.
		
		public static const PLAYER_X_INIT			:int = CAMERA_X_INIT + 25;
		
		public static const	SPAWNRATE_INIT			:int = 6000;
		public static const SPAWNRATE_ATZERO		:int = 12000;
		public static const SPAWNRATE_ATEXITHOUSE	:int = 8000;
		
		public static var	newGame: Boolean;
		
		public static const SPAWNRATE_DECREMENTER	:int = 5;
		public static const	SPAWNRATE_MINIMUM		:int = 25;
		public static var	spawnRate				:int = 100;	//300
		
		/** The number of seconds to hold the text before it starts to fade. */
		public static const textLifespan			:int = 1;
		/** The gutter size, used to keep text off screen edges. */
		public static const textGutter				:int = 1;
		
	}
}