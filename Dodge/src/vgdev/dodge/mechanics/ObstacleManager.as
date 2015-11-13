package vgdev.dodge.mechanics 
{
	import flash.geom.Point;
	import vgdev.dodge.ContainerGame;
	import vgdev.dodge.props.ABST_Obstacle;
	import vgdev.dodge.props.ABST_Pickup;

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
		/// A list of 'active' pickups
		public var pickups:Array = [];
		
		public function ObstacleManager(_cg:ContainerGame, _timeline:ObstacleTimeline)
		{
			cg = _cg;
			timeline = _timeline;
		}
		
		public function hasObstacles():Boolean
		{
			return obstacles.length > 0;
		}
		
		/**
		 * Kills all obstacles
		 */
		public function reset():void
		{
			if (obstacles.length == 0)
				return;
			var obstacle:ABST_Obstacle;
			for (var i:int = obstacles.length - 1; i >= 0; i--)
			{
				obstacle = obstacles[i] as ABST_Obstacle;
				if (cg.game.container_telegraphs.contains(obstacle.mc_object))
					cg.game.container_telegraphs.removeChild(obstacle.mc_object);
				obstacle.currentState = obstacle.STATE_DEAD;
				obstacle = null;
			}
			obstacles = [];
		}
		
		/**
		 * Updates all active obstacles
		 */
		public function step():void
		{
			var i:int;
			
			// check for obstacles and pickups to spawn
			var toSpawn:Array = timeline.step();
			if (cg.gameActive && toSpawn != null && toSpawn.length > 0)
			{
				for (i = toSpawn.length - 1; i >= 0; i--)		// spawn the obstacles and pickups associated with this frame
				{
					cg.game.container_telegraphs.addChild(toSpawn[i].mc_object);
					if (toSpawn[i] is ABST_Obstacle)
						obstacles.push(toSpawn[i]);
					else if (toSpawn[i] is ABST_Pickup)
						pickups.push(toSpawn[i]);
					toSpawn[i].activate();
				}
			}
			
			var ptPlayer:Point = (new Point(cg.player.mc_object.x + 400, cg.player.mc_object.y + 300));
			
			// update the active obstacles
			var obstacle:ABST_Obstacle;
			for (i = obstacles.length - 1; i >= 0; i--)
			{
				obstacle = obstacles[i] as ABST_Obstacle;
				if (obstacle.step())								// update this obstacle and check if it is completed
				{
					if (cg.game.container_telegraphs.contains(obstacle.mc_object))
						cg.game.container_telegraphs.removeChild(obstacle.mc_object);
					obstacles.splice(i, 1);
					obstacle = null;
					//trace("[OM] Removed an obstacle");
				}
			}
			// end update active obstacles
			
			// update the active 
			var pickup:ABST_Pickup;
			for (i = pickups.length - 1; i >= 0; i--)
			{
				pickup = pickups[i] as ABST_Pickup;
				if (pickup.step())
				{
					if (cg.game.container_telegraphs.contains(pickup.mc_object))
						cg.game.container_telegraphs.removeChild(pickup.mc_object);
					pickups.splice(i, 1);
					pickup = null;
					//trace("[OM] Removed an pickup");
				}
			}
		}
	}
}