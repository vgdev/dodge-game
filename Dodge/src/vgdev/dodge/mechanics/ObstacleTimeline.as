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
		public var frameNow:int = 0;
		
		public function ObstacleTimeline() 
		{
			timeline = new Object();
		}
		
		public function addObstacle(obstacle:ABST_Obstacle, frame:int):void
		{
			if (timeline[frame] == null)
				timeline[frame] = [];
			timeline[frame].push(obstacle);
		}
		
		public function step():Array
		{
			return timeline[frameNow++];
		}
	}
}