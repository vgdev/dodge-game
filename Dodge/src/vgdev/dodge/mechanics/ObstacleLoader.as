package vgdev.dodge.mechanics 
{
	import vgdev.dodge.ContainerGame;
	import vgdev.dodge.props.ABST_Obstacle;
	import vgdev.dodge.props.ABST_Pickup;
	import vgdev.dodge.props.OBST_DelayedMovement;
	import vgdev.dodge.props.OBST_Targeted;
	
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
				for (var anchName:String in json["anchors"])
				{
					try
					{
						trace("Trying to get anchor " + anchName);
						anchors[anchName] = toFrame(json["anchors"][anchName]);
						trace("Time anchor '" + anchName + "' added for frame " + anchors[anchName]);
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
			else
			{
				for each (var obstacle:Object in json["obstacles"])
				{
					try
					{
						//trace("Obstacle has time " + obstacle["time"]);
						if (anchors[obstacle["time"]] != null)
						{
							var time:int = anchors[obstacle["time"]];
							if (obstacle["offset"])
								time += toFrame(obstacle["offset"]);
							if (obstacle["type"])
							{
								switch (obstacle["type"])
								{
									case "targeted":
										cg.addProp(new OBST_Targeted(cg, obstacle), time);
									break;
									case "delayed":
										cg.addProp(new OBST_DelayedMovement(cg, obstacle), time);
									break;
								}
							}
							else
								cg.addProp(new ABST_Obstacle(cg, obstacle), time);
						}
					} catch (e:Error)
					{
						trace("ERROR: When setting up level, invalid anchor.\n" + e.getStackTrace());
					}
				}
			}
			
			if (json["pickups"])
			{
				for each (var pickup:Object in json["pickups"])
				{
					try
					{
						trace("Pickup has time " + pickup["time"]);
						if (anchors[pickup["time"]] != null)
						{
							time = anchors[pickup["time"]];
							if (pickup["offset"])
								time += toFrame(pickup["offset"]);
							cg.addProp(new ABST_Pickup(cg, pickup), time);
						}
					} catch (e:Error)
					{
						trace("ERROR: When setting up level, invalid anchor.\n" + e.getStackTrace());
					}
				}
			}
			
			trace("[OL] Load completed without errors.");
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