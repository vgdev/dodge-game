package vgdev.dodge.props 
{
	import flash.display.MovieClip;
	import vgdev.dodge.ContainerGame;
	/**
	 * ...
	 * @author Alexander Huynh
	 */
	public class ABST_Obstacle extends ABST_Prop
	{
		public var obstName:String;
		
		/// Frames to show the telegraph - no damage during this time
		public var spawnTime:int = 30;
		
		/// Frames to keep the telegraph as dangerous
		public var activeTime:int = 1;
		
		/// Frames to fade the telegraph - no damage during this time
		public var despawnTime:int = 10;
		
		/// Current counter
		public var currentTime:int = 0;
		
		protected const STATE_WAIT:int = 0;
		protected const STATE_SPAWN:int = 1;
		protected const STATE_ACTIVE:int = 2;
		protected const STATE_DESPAWN:int = 3;
		protected const STATE_DEAD:int = 4;
		
		public var currentState:int = STATE_WAIT;
		
		/// How many frames after the level starts to trigger this obstacle
		public var activationFrame:int;
		
		public function ABST_Obstacle(_cg:ContainerGame, _params:Object)
		{
			super(_cg);
			
			// TODO set up mc_object
			mc_object = new MovieClip();
			mc_object.graphics.lineStyle(1, 0xFFFFFF, 1);
			mc_object.graphics.beginFill(0xFFFFFF, .7);
			mc_object.graphics.drawRect( -50, -50, 100, 100);
			mc_object.graphics.endFill();
			cg.addChild(mc_object);
			
			mc_object.x = _params["x"];
			mc_object.y = _params["y"];
			
			mc_object.visible = false;
		}
		
		public function activate():void
		{
			trace("Activated");
			
			mc_object.visible = true;
			
			currentState = STATE_SPAWN;
			currentTime = 0;
			
			mc_object.alpha = .2;		// TODO remove temporary
		}
		
		override public function step():Boolean
		{
			switch (currentState)
			{
				case STATE_WAIT:
				break;
				case STATE_SPAWN:
					updatePosition();
					mc_object.alpha = .8 * (currentTime / spawnTime) + .2;		// TODO remove temporary
					if (++currentTime == spawnTime)
					{
						currentState = STATE_ACTIVE;
						currentTime = 0;
					}
				break;
				case STATE_ACTIVE:
					updatePosition();
					if (++currentTime == activeTime)
					{
						currentState = STATE_DESPAWN;
						currentTime = 0;
					}
				break;
				case STATE_DESPAWN:
					mc_object.alpha = 1 - (currentState / despawnTime);
					if (++currentTime == despawnTime)
					{
						currentState = STATE_DEAD;
						completed = true;
					}
				break;
			}
			
			return completed;
		}
		
		protected function updatePosition():void
		{
			mc_object.x = changeWithLimit(mc_object.x, dx, -400, 400);
			mc_object.y = changeWithLimit(mc_object.y, dy, -300, 300);
		}
	}
}