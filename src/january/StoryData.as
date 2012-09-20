package january
{
	import flash.utils.ByteArray;
	
	[Embed(source="../assets/strings.txt", mimeType="application/octet-stream")]
	
	public class StoryData extends ByteArray
	{
		public function embedded_text():void
		{
		}
	}
}