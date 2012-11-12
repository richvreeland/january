package january
{
	public class Asset
	{
		// MAPS /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		[Embed(source = "../assets/maps/level.txt", 	mimeType = "application/octet-stream")] public static const LEVEL_MAP	 : Class;
		[Embed(source = "../assets/maps/trees.txt", 	mimeType = "application/octet-stream")] public static const TREE_MAP	 : Class;
		[Embed(source = "../assets/maps/backtrees.txt", mimeType = "application/octet-stream")] public static const BACKTREE_MAP : Class;
		
		// SPRITES //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		[Embed(source = "../assets/art/ground.png")] 											public static const GROUND		 : Class;
		[Embed(source = "../assets/art/trees.png")] 											public static const TREES	 	 : Class;
		[Embed(source = "../assets/art/backtrees.png")] 										public static const BACK_TREES	 : Class;
		[Embed(source = "../assets/art/sky.png")] 												public static const SKY			 : Class;
		[Embed(source = "../assets/art/hills.png")] 											public static const MOUNTAIN	 : Class;
		[Embed(source = "../assets/art/cabin.png")]												public static const HOUSE		 : Class;
		
		// SOUNDS ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		[Embed(source = "../assets/audio/ambience.swf", symbol = "snow_01.aif")] 				public static const AMBIENCE	 : Class;
		[Embed(source = "../assets/audio/door_open.mp3")] 						 				public static const DOOR_OPEN	 : Class;
		[Embed(source = "../assets/audio/door_close.mp3")] 										public static const DOOR_CLOSE	 : Class;
	}
}