package vgdev.dodge.props 
{
	import vgdev.dodge.ContainerGame;
	
	/**
	 * Abstract class representing a pickup or powerup
	 * @author Alexander Huynh
	 */
	public class ABST_Pickup extends ABST_Prop 
	{
		public function ABST_Pickup(_cg:ContainerGame)
		{
			super(_cg);

			mc_object = new MovieClip();
			mc_object.graphics.lineStyle(1, 0x00FF00, 1);
			mc_object.graphics.beginFill(0x00FF00, .2);
			mc_object.graphics.drawCircle(0, 0, 10);
			mc_object.graphics.endFill();
			cg.game.container_telegraphs.addChild(mc_object);
			
			mc_object.x = setParam("x", 0);
			mc_object.y = setParam("y", 0);
		}
		
		override public function step():Boolean
		{
			// TODO collision
			
			return completed;
		}
	}
}