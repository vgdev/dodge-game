package vgdev.dodge.props 
{
	import vgdev.dodge.ContainerGame;
	
	/**
	 * ...
	 * @author Alexander Huynh
	 */
	public class OBST_DelayedMovement extends ABST_Obstacle 
	{
		
		public function OBST_DelayedMovement(_cg:ContainerGame, _params:Object) 
		{
			super(_cg, _params);
			
		}
		
		/**
		 * Move the obstacle's x and y according to its dx and dy
		 */
		override protected function updatePosition():void
		{
			if (currentState == STATE_SPAWN || currentState == STATE_WAIT) return;
			mc_object.x = changeWithLimit(mc_object.x, dx);
			mc_object.y = changeWithLimit(mc_object.y, dy);
			mc_object.rotation = changeWithLimit(mc_object.rotation, dr);
		}
		
	}

}