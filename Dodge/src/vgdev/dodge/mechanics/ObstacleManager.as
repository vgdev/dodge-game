package vgdev.dodge.mechanics 
{
	import flash.geom.Point;
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
			if (cg.gameActive && toSpawn != null && toSpawn.length > 0)
			{
				for (i = toSpawn.length - 1; i >= 0; i--)
				{
					cg.game.addChild(toSpawn[i].mc_object);
					obstacles.push(toSpawn[i]);
					toSpawn[i].activate();
				}
			}
			
			var ptPlayer:Point = (new Point(cg.player.mc_object.x + 400, cg.player.mc_object.y + 300));
			
			for (i = obstacles.length - 1; i >= 0; i--)
			{
				obstacle = obstacles[i] as ABST_Obstacle;
				if (obstacle.step())
				{
					if (cg.game.contains(obstacle.mc_object))
						cg.game.removeChild(obstacle.mc_object);
					obstacles.splice(i, 1);
					obstacle = null;
				}
				else if (cg.gameActive && obstacle.currentState == obstacle.STATE_ACTIVE)
				{
					var ptObst:Point = new Point(obstacle.mc_object.x, obstacle.mc_object.y);
					if (obstacle.mc_object.hitTestObject(cg.player.mc_object))
					{
						if ((!obstacle.isBitmap && obstacle.mc_object.hitTestPoint(ptPlayer.x, ptPlayer.y, true)) ||
							 HitTester.realHitTest(obstacle.mc_object, ptPlayer))
						{
							cg.player.kill();
							//trace("DEAD " + cg.obstacleTimeline.frameNow);
						}
					}
				}
			}
		}
	}

}