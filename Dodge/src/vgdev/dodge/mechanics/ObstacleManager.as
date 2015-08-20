package vgdev.dodge.mechanics 
{
	import vgdev.dodge.ContainerGame;
	import vgdev.dodge.props.ABST_Obstacle;
	/**
	 * ...
	 * @author Alexander Huynh
	 */
	public class ObstacleManager 
	{
		private var cg:ContainerGame;
		private var timeline:ObstacleTimeline;
		
		public var obstacles:Array = [];
		
		public function ObstacleManager(_cg:ContainerGame, _timeline:ObstacleTimeline)
		{
			cg = _cg;
			timeline = _timeline;
		}
		
		public function step():void
		{
			var obstacle:ABST_Obstacle;
			var i:int;
			
			var toSpawn:Array = timeline.step();
			if (toSpawn != null && toSpawn.length > 0)
			{
				for (i = toSpawn.length - 1; i >= 0; i--)
				{
					cg.addChild(toSpawn[i].mc_object);
					obstacles.push(toSpawn[i]);
					toSpawn[i].activate();
				}
			}
			
			for (i = obstacles.length - 1; i >= 0; i--)
			{
				obstacle = obstacles[i] as ABST_Obstacle;
				if (obstacle.step())
				{
					if (cg.contains(obstacle.mc_object))
						cg.removeChild(obstacle.mc_object);
					obstacles.splice(i, 1);
					obstacle = null;
				}
			}
		}
	}

}