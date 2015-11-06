package vgdev.dodge.props 
{
	import vgdev.dodge.ContainerGame;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import vgdev.dodge.mechanics.TimeScale;
	import vgdev.dodge.mechanics.HitTester;
	import flash.geom.Point;
	
	public class ABST_Collidable extends ABST_Prop
	{
		
		/// Frames to show the telegraph - cannot interact during this time
		public var spawnTime:int = 30;
		
		/// Frames to keep the telegraph as active - player can interact at this time
		public var activeTime:int = 3;
		
		/// Frames to fade the telegraph - cannot interact during this time
		public var despawnTime:int = 10;
		
		/// Current frame counter
		public var currentTime:Number = 0;
		
		// state machine constants
		public const STATE_WAIT:int = 0;
		public const STATE_SPAWN:int = 1;
		public const STATE_ACTIVE:int = 2;
		public const STATE_DESPAWN:int = 3;
		public const STATE_DEAD:int = 4;
		
		public var currentState:int = STATE_WAIT;
		
		/// Flash drawing object to check collisions with
		public var hitbox:MovieClip;
				
		public function ABST_Collidable(_cg:ContainerGame, _params:Object) 
		{
			super(_cg);
			params = _params;
			
			// set up mc_object
			mc_object = new MovieClip();
			mc_object.tele = new MovieClip();		// the 'expanding' warning part of the obstacle
			mc_object.addChild(mc_object.tele);
			
			// read and set params from _params object
			spawnTime = setParam("spawn", spawnTime);
			activeTime = setParam("active", activeTime);
			mc_object.x = setParam("x", 0);
			mc_object.y = setParam("y", 0);
			dx = setParam("dx", 0);
			dy = setParam("dy", 0);
			dr = setParam("dr", 0);
			mc_object.rotation = setParam("rot", 0);
			mc_object.scaleX = mc_object.scaleY = setParam("scale", 1);
			mc_object.scaleX = setParam("scaleX", mc_object.scaleX);
			mc_object.scaleY = setParam("scaleY", mc_object.scaleY);
			
			mc_object.visible = false;
		}
		
		/**
		 * Starts the telegraph
		 */
		public function activate():void
		{			
			mc_object.visible = true;
			
			currentState = STATE_SPAWN;
			currentTime = 0;
			
			mc_object.alpha = .2;		// TODO remove temporary
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
					if (currentTime >= spawnTime)
					{
						currentState = STATE_ACTIVE;
						currentTime = 0;
						mc_object.tele.scaleX = mc_object.tele.scaleY = 1;
						mc_object.alpha = 1;
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
		
		/**
		 * Check for collision with the Player
		 */
		protected function checkCollision():Boolean
		{			
			var ptPlayer:Point = cg.localToGlobal(new Point(cg.player.mc_object.x + 0, cg.player.mc_object.y + 0));
			if (mc_object.hitTestObject(cg.player.mc_object))
			{
				if (hitbox && hitbox.hitTestPoint(ptPlayer.x, ptPlayer.y, true))
				{
					return true;
				}
			}
			return false;
		}
	}
}