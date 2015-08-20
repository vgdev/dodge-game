package vgdev.dodge.mechanics 
{
	import vgdev.dodge.props.ABST_Obstacle;
	
	/**
	 * ...
	 * @author Alexander Huynh
	 */
	public class ObstacleTimeline 
	{
		public var timeline:Object;
		public var canActivate:Object;
		public var frameNow:Number = 0;
		
		public function ObstacleTimeline() 
		{
			timeline = new Object();
			canActivate = new Object();
		}
		
		public function addObstacle(obstacle:ABST_Obstacle, frame:int):void
		{
			if (timeline[frame] == null)
				timeline[frame] = [];
			timeline[frame].push(obstacle);
			canActivate[frame] = true;
		}
		
		public function step():Array
		{
			frameNow += TimeScale.s_scale;
			if (canActivate[int(frameNow)])
			{
				canActivate[int(frameNow)] = false;
				return timeline[int(frameNow)];
			}
			return null;
		}
	}
}