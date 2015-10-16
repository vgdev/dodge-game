package vgdev.dodge.props 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import vgdev.dodge.ContainerGame;
	import vgdev.dodge.mechanics.TimeScale;
	import vgdev.dodge.mechanics.HitTester;
	
	/**
	 * Abstract class
	 * Contains functionality useful to all Obstacles
	 * @author Alexander Huynh, Zach Phillips
	 */
	public class ABST_Obstacle extends ABST_Collidable
	{
		// MC's holding the images
		private var imgBase:MovieClip;
		private var imgTele:MovieClip;
		
		public function ABST_Obstacle(_cg:ContainerGame, _params:Object)
		{
			super(_cg, _params);
			params = _params;
			
			if (!_params["image"])
			{
				mc_object.graphics.lineStyle(1, 0xFF0000, 1);
				mc_object.graphics.beginFill(0xFF0000, .2);
				if (_params["shape"] == "circle")
					mc_object.graphics.drawCircle(0, 0, 50);
				else
					mc_object.graphics.drawRect( -50, -50, 100, 100);
				mc_object.graphics.endFill();
				
				mc_object.tele.graphics.lineStyle(1, 0xFF0000, 1);
				mc_object.tele.graphics.beginFill(0xFF0000, .7);
				if (_params["shape"] == "circle")
					mc_object.tele.graphics.drawCircle(0, 0, 50);
				else
					mc_object.tele.graphics.drawRect( -50, -50, 100, 100);
				mc_object.tele.graphics.endFill();
				
				hitbox = mc_object;
			}
			else
			{
				imgBase = new SWC_Obstacle();
				imgTele = new SWC_Obstacle();

				imgBase.gotoAndStop(_params["image"]);
				imgTele.gotoAndStop(_params["image"]);
				
				imgBase.hitbox.visible = false;
				imgTele.hitbox.visible = false;
							
				mc_object.addChild(imgBase);
				mc_object.tele.addChild(imgTele);
				
				hitbox = imgBase.hitbox;
			}
			
			//trace("Obstacle added at " + mc_object.x + ", " + mc_object.y);
		}
		
		override protected function checkCollision():Boolean
		{
			if (super.checkCollision())
			{
				cg.player.kill();
				return true;
			}
			return false;
		}
		
		/**
		 * Move the obstacle's x and y according to its dx and dy
		 */
		override protected function updatePosition():void
		{
			mc_object.x = changeWithLimit(mc_object.x, dx);
			mc_object.y = changeWithLimit(mc_object.y, dy);
			mc_object.rotation = changeWithLimit(mc_object.rotation, dr);
		}
	}
}