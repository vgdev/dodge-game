package vgdev.dodge.mechanics 
{
	import vgdev.dodge.props.ABST_Obstacle;
	
	/**
	 * Keeps track of the obstacles to be spawned in a level
	 * @author Alexander Huynh
	 */
	public class ObstacleTimeline 
	{
		// 30 frames == 1 second; starting frame is 0
		
		/// Map of frame number to Array of obstacles to be spawned on that frame
		public var timeline:Object;
		
		/// Map of frame number to Boolean, indicating if there are things that can be spawned on this frame
		public var canActivate:Object;
		
		/// Current frame
		public var frameNow:Number;
		
		/// Frame with the last obstacle(s), used to help determine when the stage has ended
		public var highestFrame:int;
		
		public function ObstacleTimeline() 
		{
			reset();
		}
		
		/**
		 * Clears all saved obstacles and time information.
		 */
		public function reset():void
		{
			timeline = new Object();
			canActivate = new Object();
			frameNow = 0;
			highestFrame = 0;
		}
		
		/**
		 * Prepare the given obstacle to be spawned on the given frame
		 * @param	obstacle		The Obstacle to be spawned
		 * @param	frame			The frame on which to spawn
		 */
		public function addObstacle(obstacle:ABST_Obstacle, frame:int):void
		{
			if (timeline[frame] == null)
				timeline[frame] = [];
			timeline[frame].push(obstacle);
			canActivate[frame] = true;
			
			if (frame > highestFrame)
				highestFrame = frame;
		}
		
		/**
		 * Update the current frame and check for obstacles to spawn
		 * @return		An Array of obstacles to spawn on the current frame, or null if none
		 */
		public function step():Array
		{
			// NOTE: will properly spawn if time scale is < 1, but could skip if time scale is > 1
			
			frameNow += TimeScale.s_scale;
			if (canActivate[int(frameNow)])
			{
				canActivate[int(frameNow)] = false;		// don't spawn this frame again
				return timeline[int(frameNow)];
			}
			return null;
		}
		
		/**
		 * Helper to determine if all obstacles have finished spawning
		 * @return		true if no more obstacles are going to spawn
		 */
		public function gameComplete():Boolean
		{
			// TODO inspect and fix?
			return frameNow >= highestFrame + 60;
		}
	}
}