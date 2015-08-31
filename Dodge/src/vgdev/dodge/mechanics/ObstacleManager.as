package vgdev.dodge.mechanics 
{
	import flash.geom.Point;
	import vgdev.dodge.ContainerGame;
	import vgdev.dodge.props.ABST_Obstacle;

	/**
	 * Manages and updates a level's Obstacles
	 * @author Alexander Huynh
	 */
	public class ObstacleManager 
	{
		private var cg:ContainerGame;
		private var timeline:ObstacleTimeline;
		
		/// A list of 'active' obstacles
		public var obstacles:Array = [];
		
		public function ObstacleManager(_cg:ContainerGame, _timeline:ObstacleTimeline)
		{
			cg = _cg;
			timeline = _timeline;
		}
		
		public function hasObstacles():Boolean
		{
			return obstacles.length == 0;
		}
		
		/**
		 * Updates all active obstacles
		 */
		public function step():void
		{
			var obstacle:ABST_Obstacle;
			var i:int;
			
			// check for obstacles to spawn
			var toSpawn:Array = timeline.step();
			if (cg.gameActive && toSpawn != null && toSpawn.length > 0)
			{
				for (i = toSpawn.length - 1; i >= 0; i--)		// spawn the obstacles associated with this frame
				{
					cg.game.container_telegraphs.addChild(toSpawn[i].mc_object);
					obstacles.push(toSpawn[i]);
					toSpawn[i].activate();
				}
			}
			
			var ptPlayer:Point = (new Point(cg.player.mc_object.x + 400, cg.player.mc_object.y + 300));
			
			// update the active obstacles
			for (i = obstacles.length - 1; i >= 0; i--)
			{
				obstacle = obstacles[i] as ABST_Obstacle;
				if (obstacle.step())								// update this obstacle and check if it is completed
				{
					if (cg.game.container_telegraphs.contains(obstacle.mc_object))
						cg.game.container_telegraphs.removeChild(obstacle.mc_object);
					obstacles.splice(i, 1);
					obstacle = null;
				}
				// player hit detection
				// TODO move to ABST_Obstacle and make not as ugly
				else if (cg.gameActive && obstacle.currentState == obstacle.STATE_ACTIVE)
				{
					var ptObst:Point = new Point(obstacle.mc_object.x, obstacle.mc_object.y);
					if (obstacle.mc_object.hitTestObject(cg.player.mc_object))
					{
						if ((!obstacle.isBitmap && obstacle.mc_object.hitTestPoint(ptPlayer.x, ptPlayer.y, true)) ||
							 HitTester.realHitTest(obstacle.mc_object, ptPlayer))
						{
							cg.player.kill();
						}
					}
				}
			}
			// end update active obstacles
		}
	}
}