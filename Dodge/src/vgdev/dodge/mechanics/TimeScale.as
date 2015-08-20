package vgdev.dodge.mechanics 
{
	/**
	 * ...
	 * @author Alexander Huynh
	 */
	public class TimeScale
	{
		public static var s_scale:Number = 1;
		
		public function TimeScale() 
		{
		}
		
		public static function speedUp():void
		{
			s_scale *= 1.4;
			if (s_scale > 1)
				s_scale = 1;
		}
		
		public static function slowDown():void
		{
			s_scale *= .4;
			if (s_scale < .2)
				s_scale = .2;
		}
	}
}