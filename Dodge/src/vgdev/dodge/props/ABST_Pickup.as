package vgdev.dodge.props 
{
	import vgdev.dodge.ContainerGame;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import vgdev.dodge.mechanics.TimeScale;
	import vgdev.dodge.mechanics.HitTester;
	
	/**
	 * Abstract class representing a pickup or powerup
	 * @author Alexander Huynh
	 */
	public class ABST_Pickup extends ABST_Collidable
	{
		
		protected var effectType:String = "score";
		protected var effectAmount:int = 0;
		
		public function ABST_Pickup(_cg:ContainerGame, _params:Object)
		{
			super(_cg, _params);
			
			effectType = setParam("effect", effectType);
			effectAmount = setParam("amount", effectAmount);
			
			if (!_params["image"])
			{
				mc_object.graphics.lineStyle(1, 0x00FF00, 1);
				mc_object.graphics.beginFill(0x00FF00, .5);
				mc_object.graphics.drawCircle(0, 0, 10);
				mc_object.graphics.endFill();
				cg.game.container_telegraphs.addChild(mc_object);
			}
			else
			{
				isBitmap = true;
				var imgClass:Class;
				switch (_params["image"])
				{
					default:			trace("ERROR in ABST_Obstacle: Image " + _params["image"] + " not found!");
				}
				var img:Bitmap = new imgClass();
				bitmapData = img.bitmapData;
				//img.x -= img.width * .5;
				//img.y -= img.height * .5;
				mc_object.addChild(img);
				img = new imgClass();
				//img.x -= img.width * .5;
				//img.y -= img.height * .5;
				mc_object.tele.addChild(img);
			}
			
			//mc_object.x = setParam("x", 0);
			//mc_object.y = setParam("y", 0);
		}
		
		/**
		 * Check for collision with the Player
		 * If there is a collision, activates the effect of the powerup
		 */
		override protected function checkCollision():Boolean
		{
			if (super.checkCollision())
			{
				// this is also rather clunky; make better animation, like the pickup explodes or something?
				// idk, maybe TODO something with this later
				currentTime = activeTime;
				activateEffects();
				trace("Yes! Pickup obtained!");
			}
			return true;
		}
		
		/**
		 * Activates the pickup's effects: "TP+", "score+", etc.
		 */
		protected function activateEffects():void
		{
			switch (effectType)
			{
				case "hard_reset":
					cg.endStage();
					break;
				case "tp":
					cg.player.changeTimePoints(effectAmount);
					break;
				case "score":
					cg.player.addScore(effectAmount);
					break;
				default:
					trace("WARNING: No instantiated effect for " + effectType + "!");
			}
		}
		
	}
}