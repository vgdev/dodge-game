package vgdev.dodge.props 
{
	import flash.display.MovieClip;
	import vgdev.dodge.ContainerGame;
	import vgdev.dodge.mechanics.TimeScale;
	
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
		public var activeTime:int = 3;
		
		/// Frames to fade the telegraph - no damage during this time
		public var despawnTime:int = 10;
		
		/// Current counter
		public var currentTime:Number = 0;
		
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
			mc_object.main = new MovieClip();
			mc_object.addChild(mc_object.main);
			mc_object.main.graphics.lineStyle(1, 0xFF0000, 1);
			mc_object.main.graphics.beginFill(0xFF0000, .2);
			if (_params["circle"])
				mc_object.main.graphics.drawCircle(0, 0, 50);
			else
				mc_object.main.graphics.drawRect( -50, -50, 100, 100);
			mc_object.main.graphics.endFill();
			
			mc_object.tele = new MovieClip();
			mc_object.addChild(mc_object.tele);
			mc_object.tele.graphics.lineStyle(1, 0xFF0000, 1);
			mc_object.tele.graphics.beginFill(0xFF0000, .7);
			if (_params["circle"])
				mc_object.tele.graphics.drawCircle(0, 0, 50);
			else
				mc_object.tele.graphics.drawRect( -50, -50, 100, 100);
			mc_object.tele.graphics.endFill();
			cg.addChild(mc_object);
			
			// TODO
			mc_object.x = _params["x"];
			mc_object.y = _params["y"];
			if (_params["scale"])
				mc_object.scaleX = mc_object.scaleY = _params["scale"];
			if (_params["spawn"])
				spawnTime = _params["spawn"];
			
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
				break;
				case STATE_DESPAWN:
					mc_object.alpha = 1 - (currentTime / despawnTime);
					if (currentTime >= despawnTime)
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