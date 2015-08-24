package vgdev.dodge.mechanics 
{
	/**
	 * Static class
	 * Controls the time scale multiplier
	 * @author Alexander Huynh
	 */
	public class TimeScale
	{
		/// The game's time scale - multiply movement values, etc. by this
		public static var s_scale:Number = 1;
		
		public function TimeScale() 
		{
			// Static class - do not instiantiate
		}
		
		/**
		 * Increase the time scale with an upper limit of 100%
		 */
		public static function speedUp():void
		{
			s_scale *= 1.4;
			if (s_scale > 1)
				s_scale = 1;
		}
		
		/**
		 * Decrease the time scale with a lower limit of 20%
		 */
		public static function slowDown():void
		{
			s_scale *= .4;
			if (s_scale < .2)
				s_scale = .2;
		}
	}
}