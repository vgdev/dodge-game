package vgdev.dodge.props 
{
	import vgdev.dodge.ContainerGame;
	import vgdev.dodge.mechanics.TimeScale;
	
	/**
	 * Sticky telegraph
	 * @author Alexander Huynh
	 */
	public class OBST_Targeted extends ABST_Obstacle 
	{
		private var velocity:Number;
		
		public function OBST_Targeted(_cg:ContainerGame, _params:Object) 
		{
			super(_cg, _params);
			velocity = setParam("velocity", 1);
		}
		
		/**
		 * Updates the obstacle
		 * @return		true if the obstacle is done and should be cleaned up
		 */
		override public function step():Boolean
		{
			// increase the counter by '1 frame', modified by the current time scale
			currentTime += TimeScale.s_scale;
			
			switch (currentState)
			{
				case STATE_WAIT:
					break;
				case STATE_SPAWN:
					updatePosition();
					mc_object.tele.scaleX = mc_object.tele.scaleY = currentTime / spawnTime;
					mc_object.rotation = getAngle(mc_object.x, mc_object.y, cg.player.mc_object.x, cg.player.mc_object.y) + 0;		// changed
					trace(mc_object.rotation);
					if (currentTime >= spawnTime)
					{
						currentState = STATE_ACTIVE;
						currentTime = 0;
						mc_object.tele.scaleX = mc_object.tele.scaleY = 1;
						mc_object.alpha = 1;
						dx = velocity * Math.cos(degreesToRadians(mc_object.rotation));		// changed
						dy = velocity * Math.sin(degreesToRadians(mc_object.rotation));		// changed
					}
					break;
				case STATE_ACTIVE:
					updatePosition();
					if (currentTime >= activeTime)
					{
						currentState = STATE_DESPAWN;
						currentTime = 0;
					}
					else
					{
						checkCollision();
					}
					break;
				case STATE_DESPAWN:
					mc_object.alpha = 1 - (currentTime / despawnTime);
					if (currentTime >= despawnTime)
					{
						currentState = STATE_DEAD;
						completed = true;
						mc_object.visible = false;
					}
					break;
			}
			
			return completed;
		}
		
		// changed
		protected function getAngle(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return radiansToDegrees(Math.atan2(dy,dx));
		}
		
		// changed
		protected function radiansToDegrees(radians:Number):Number
		{
			return radians * 57.296;
		}
		
		// changed
		protected function degreesToRadians(degrees:Number):Number
		{
			return degrees * .0175;
		}
		
	}

}