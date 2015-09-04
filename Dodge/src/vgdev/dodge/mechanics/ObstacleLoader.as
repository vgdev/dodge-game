package vgdev.dodge.mechanics 
{
	import vgdev.dodge.ContainerGame;
	
	/**
	 * Helper to load a level's obstacles
	 * @author Alexander Huynh
	 */
	public class ObstacleLoader 
	{
		private var cg:ContainerGame;
		
		/// Map of Strings to seconds
		private var anchors:Object;
		
		public function ObstacleLoader(_cg:ContainerGame)
		{
			cg = _cg;
		}
		
		/**
		 * Resets and populates ObstacleLoader and ObstacleManager with obstacles
		 * @param	json		JSON of the level elements
		 * @return				if the level successfully loaded
		 */
		public function loadLevel(json:Object):Boolean
		{
			anchors = new Object();
			
			if (cg.obstacleManager)
				cg.obstacleManager.reset();
			if (cg.obstacleTimeline)
				cg.obstacleTimeline.reset();
			
			trace("[OL] Loading JSON: " + json);
				
			// set up anchors
			if (json["anchors"])
			{
				for each (var testObj:Number in json["anchors"])
				{
					try
					{
						trace(testObj);
					} catch (e:Error)
					{
						trace("ERROR: When setting up level, invalid anchor.\n" + e.getStackTrace());
					}
				}
			}
			
			// validate list of obstacles
			if (!json["obstacles"])
			{
				trace("ERROR: When setting up level, JSON file is missing \"obstacles\"!");
				return false;
			}
			
			return true;
		}
		
		/**
		 * Converts a second to a frame number
		 * @param	sec			A second value, such as 1 or 2.2
		 * @return				The corresponding frame number, such as 30 or 66
		 */
		private function toFrame(sec:Number):int
		{
			return sec * 30;
		}
	}
}