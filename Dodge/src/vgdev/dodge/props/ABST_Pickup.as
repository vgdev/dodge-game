package vgdev.dodge.props 
{
	import vgdev.dodge.ContainerGame;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import vgdev.dodge.mechanics.TimeScale;
	import vgdev.dodge.mechanics.HitTester;
	import vgdev.dodge.SoundManager;
	
	/**
	 * Abstract class representing a pickup or powerup
	 * @author Alexander Huynh, Zach Phillips
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
			
			mc_object.addChild(new SWC_Pickup());
			hitbox = mc_object;
			
			/*if (!_params["image"])
			{
				mc_object.graphics.lineStyle(1, 0x00FF00, 1);
				mc_object.graphics.beginFill(0x00FF00, .5);
				mc_object.graphics.drawCircle(0, 0, 10);
				mc_object.graphics.endFill();
				cg.game.container_telegraphs.addChild(mc_object);
				
				hitbox = mc_object;
			}
			else
			{
				// TODO
			}*/
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
				SoundManager.playSound("sfx_power");
				return true;
			}
			return false;
		}
		
		/**
		 * Activates the pickup's effects: "TP+", "score+", etc.
		 */
		protected function activateEffects():void
		{
			switch (effectType)
			{
				case "hard_reset":
					trace("Hard Reset acquired; ending stage");
					cg.endStage();
					break;
				case "tp":
					trace("TP acquired; adding TP x " + effectAmount);
					cg.player.changeTimePoints(effectAmount);
					break;
				case "score":
					trace("Score acquired; adding score x " + effectAmount);
					cg.player.addScore(effectAmount);
					break;
				default:
					trace("WARNING: No instantiated effect for " + effectType + "!");
			}
		}
		
	}
}