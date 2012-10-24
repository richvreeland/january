package january
{
	public class Global
	{	
		//CONSTANTS
		
		/** Initial Score. */
		public static const SCORE_INIT				:int = 0;
		/** Initial Camera X Position. */
		public static const CAMERA_X_INIT			:int = 420;	//2450 for End of Level.		
		/** Initial Player X Position. */
		public static const PLAYER_X_INIT			:int = CAMERA_X_INIT + 25;
		/** Time before first Snowflake spawns. */
		public static const	SPAWNRATE_INIT			:int = 6000;
		/** Time between Snowflake spawns when Score is Zero. */
		public static const SPAWNRATE_ATZERO		:int = 12000;
		/** Time between Snowflake spawns after Exiting the House. */
		public static const SPAWNRATE_ATEXITHOUSE	:int = 8000;
		/** Rate at which the time between Snowflake spawns is decremented by. */
		public static const SPAWNRATE_DECREMENTER	:int = 8;
		/** The minimum amount of time allowed between Snowflake spawns. */
		public static const	SPAWNRATE_MINIMUM		:int = 20;
		/** The number of seconds to hold alpha before beginning to fade. */
		public static const ALPHA_LIFESPAN			:int = 1;
		/** The default color for fireflies in Record mode. */
		public static const RECORD_COLOR			:uint = 0xFA0013;
		/** The default color for fireflies in Playback mode. */
		public static const PLAYBACK_COLOR			:uint = 0x64E000;
		
		//VARIABLES
		
		/** Whether or not the player has exited the house. */
		public static var	newGame: Boolean;
		/** The amount of time between Snowflake spawns. */
		public static var	spawnRate				:int = 275;
		/** The gutter size, used to keep text off screen edges. */
		public static const textGutter				:int = 1;
	}
}