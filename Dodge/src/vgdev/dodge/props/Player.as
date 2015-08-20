package vgdev.dodge.props 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import vgdev.dodge.ContainerGame;
	import vgdev.dodge.mechanics.TimeScale;
	
	/**
	 * ...
	 * @author Alexander Huynh
	 */
	public class Player extends ABST_Prop
	{
		private const RIGHT:int = 0;
		private const UP:int = 1;
		private const LEFT:int = 2;
		private const DOWN:int = 3;
		
		private var dx:Number = 0;
		private var dy:Number = 0;
		
		private var keysDown:Object = {UP:false, LEFT:false, RIGHT:false, DOWN:false};
		
		private var speedLimitX:Number = 12;
		private var speedLimitY:Number = 12;
		private var thrust:Number = 3
		private var friction:Number = .6;
		private var haltThreshold:Number = .02;
		
		public function Player(_cg:ContainerGame)
		{
			super(_cg);
			mc_object = new SWC_player();
			
			mc_object.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * Helper to init the keyboard listener
		 * 
		 * @param	e	the captured Event, unused
		 */
		private function onAddedToStage(e:Event):void
		{
			mc_object.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			cg.stage.addEventListener(KeyboardEvent.KEY_DOWN, downKeyboard);
			cg.stage.addEventListener(KeyboardEvent.KEY_UP, upKeyboard);
		}
		
		override public function step():Boolean
		{
			updateVelocity();
			mc_object.x = changeWithLimit(mc_object.x, dx, -400, 400);
			mc_object.y = changeWithLimit(mc_object.y, dy, -300, 300);
			
			return completed;
		}
		
		public function downKeyboard(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.W:
					keysDown[UP] = true;
				break;
				case Keyboard.A:
					keysDown[LEFT] = true;
				break;
				case Keyboard.S:
					keysDown[DOWN] = true;
				break;
				case Keyboard.D:
					keysDown[RIGHT] = true;
				break;
			}
		}
		
		public function upKeyboard(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.W:
					keysDown[UP] = false;
				break;
				case Keyboard.A:
					keysDown[LEFT] = false;
				break;
				case Keyboard.S:
					keysDown[DOWN] = false;
				break;
				case Keyboard.D:
					keysDown[RIGHT] = false;
				break;
			}
		}
		
		private function updateVelocity():void
		{
			for (var i:int = 0; i < 4; i++)
				if (keysDown[i])
					applyMovement(i, thrust);
			
			if (!keysDown[LEFT] && !keysDown[[RIGHT]])
			{
				dx -= (dx * friction * TimeScale.s_scale);
				if (Math.abs(dx) < speedLimitX * haltThreshold)
					dx = 0;
			}
			if (!keysDown[UP] && !keysDown[DOWN])
			{
				dy -= (dy * friction * TimeScale.s_scale);
				if (Math.abs(dy) < speedLimitY * haltThreshold)
					dy = 0;
			}
		}
		
		public function applyMovement(direction:int, amount:Number):void
		{
			switch (direction)
			{
				case UP:
					dy = changeWithLimit(dy, -amount, -speedLimitY, speedLimitY);
					if (keysDown[RIGHT])
						mc_object.rotation = -45;
					else if (keysDown[LEFT])
						mc_object.rotation = -135;
					else
						mc_object.rotation = -90;
				break;
				case DOWN:
					dy = changeWithLimit(dy, amount, -speedLimitY, speedLimitY);
					if (keysDown[RIGHT])
						mc_object.rotation = 45;
					else if (keysDown[LEFT])
						mc_object.rotation = 135;
					else
						mc_object.rotation = 90;
				break;
				case LEFT:
					dx = changeWithLimit(dx, -amount, -speedLimitX, speedLimitX);
					if (keysDown[UP])
						mc_object.rotation = -135;
					else if (keysDown[DOWN])
						mc_object.rotation = 135;
					else
						mc_object.rotation = 180;
				break;
				case RIGHT:
					dx = changeWithLimit(dx, amount, -speedLimitX, speedLimitX);
					if (keysDown[UP])
						mc_object.rotation = 135;
					else if (keysDown[DOWN])
						mc_object.rotation = -135;
					else
						mc_object.rotation = 0;
				break;
			}
		}
		
		public function getd():Point
		{
			return new Point(dx, dy);
		}
	}
}