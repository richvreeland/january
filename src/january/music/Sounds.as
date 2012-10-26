package january.music
{
	import org.flixel.*;
	
	public class Sounds extends FlxGroup
	{
		public function Sounds():void
		{
			super();
			
			maxSize = 4;
		}
		
		public function steal(ObjectClass:Class=null):FlxBasic
		{
			var basic:FlxSound;
			if(_maxSize > 0)
			{
				if(length < _maxSize)
				{
					if(ObjectClass == null)
						return null;
					return add(new ObjectClass() as FlxSound);
				}
				else
				{
					basic = members[_marker++];
					if(_marker >= _maxSize)
						_marker = 0;
					return basic;
				}
			}
			else
			{
				basic = getFirstAvailable() as FlxSound;
				if(basic != null)
					return basic;
				if(ObjectClass == null)
					return null;
				return add(new ObjectClass() as FlxSound);
			}
		}
	}
}