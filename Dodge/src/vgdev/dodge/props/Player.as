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
	 * Instance of the player
	 * @author Alexander Huynh
	 */
	public class Player extends ABST_Prop
	{
		// keys for use in keysDown
		private const RIGHT:int = 0;
		private const UP:int = 1;
		private const LEFT:int = 2;
		private const DOWN:int = 3;
		private const TIME:int = 10;
		
		/// Map of key states
		private var keysDown:Object = {UP:false, LEFT:false, RIGHT:false, DOWN:false, TIME:false};
		
		private var speedLimitX:Number = 12;
		private var speedLimitY:Number = 12;
		private var thrust:Number = 3;				// movement power
		private var friction:Number = .6;			// speed reduction per frame
		private var haltThreshold:Number = .02;		// reduce speed to 0 if speed is lower than (this amount * speedLimit)
		private var thrustBonus:Number = 2;
		private var frictionBonus:Number = 2;
		
		public var alive:Boolean = true;			// if the player is alive and playable
		
		private var timePointsMax:int = 60;
		private var timePoints:int = 60;
		
		private var actualScore:int = 0;
		private var displayedScore:int = 0;
		private const CHANGE_SCORE:int = 5;
		
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
		
		/**
		 * Update the player
		 * @return		true if the player is dead
		 */
		override public function step():Boolean
		{
			if (!alive)
				return completed;
			
			updateVelocity();
			updatePosition();
			
			// handle time scale based on if the time scale key is down or not
			if (keysDown[TIME])
			{
				if (timePoints > 0)
					TimeScale.slowDown();
				else
					TimeScale.speedUp();
				changeTimePoints( -1);
			}
			else
			{
				TimeScale.speedUp();
				changeTimePoints(1);
			}
			
			return completed;
		}
		
		/**
		 * Update the player's x and y position based on its dx and dy
		 */
		private function updatePosition():void
		{
			mc_object.x = changeWithLimit(mc_object.x, dx, -400, 400);
			mc_object.y = changeWithLimit(mc_object.y, dy, -300, 300);
			
			trace("PLAYER COORDINATES: (" + mc_object.x + "," + mc_object.y + ")");
		}
		
		/**
		 * Update the player's dx and dy based on what keys are down
		 */
		private function updateVelocity():void
		{
			// apply thrust
			for (var i:int = 0; i < 4; i++)
				if (keysDown[i])
					applyMovement(i, thrust);
			
			// apply friction - friction is increased if time scale is not normal (1)
			if (!keysDown[LEFT] && !keysDown[[RIGHT]])
			{
				dx -= (dx * friction * TimeScale.s_scale) * (TimeScale.s_scale == 1 ? 1 : frictionBonus);
				if (Math.abs(dx) < speedLimitX * haltThreshold)
					dx = 0;
			}
			if (!keysDown[UP] && !keysDown[DOWN])
			{
				dy -= (dy * friction * TimeScale.s_scale) * (TimeScale.s_scale == 1 ? 1 : frictionBonus);
				if (Math.abs(dy) < speedLimitY * haltThreshold)
					dy = 0;
			}
		}
		
		/**
		 * Changes the displayed score to more accurately reflect the player's current score
		 */
		private function updateScore():void
		{
			if (actualScore > displayedScore)
				displayedScore += Math.min(actualScore - displayedScore, CHANGE_SCORE);
			else if (actualScore < displayedScore)
				displayedScore -= Math.min(actualScore - displayedScore, CHANGE_SCORE);
		}
		
		/**
		 * Changes the player's velocity, and updates the graphic's rotation
		 * Movement speed bonus if time scale is not normal (1)
		 * @param	direction		Direction to apply velocity change (UP, DOWN, LEFT, RIGHT)
		 * @param	amount			Amount to change velocity by
		 */
		public function applyMovement(direction:int, amount:Number):void
		{
			switch (direction)
			{
				case UP:
					dy = changeWithLimit(dy, -amount * (TimeScale.s_scale == 1 ? 1 : thrustBonus), -speedLimitY, speedLimitY);
					if (keysDown[RIGHT])
						mc_object.rotation = -45;
					else if (keysDown[LEFT])
						mc_object.rotation = -135;
					else
						mc_object.rotation = -90;
				break;
				case DOWN:
					dy = changeWithLimit(dy, amount * (TimeScale.s_scale == 1 ? 1 : thrustBonus), -speedLimitY, speedLimitY);
					if (keysDown[RIGHT])
						mc_object.rotation = 45;
					else if (keysDown[LEFT])
						mc_object.rotation = 135;
					else
						mc_object.rotation = 90;
				break;
				case LEFT:
					dx = changeWithLimit(dx, -amount * (TimeScale.s_scale == 1 ? 1 : thrustBonus), -speedLimitX, speedLimitX);
					if (keysDown[UP])
						mc_object.rotation = -135;
					else if (keysDown[DOWN])
						mc_object.rotation = 135;
					else
						mc_object.rotation = 180;
				break;
				case RIGHT:
					dx = changeWithLimit(dx, amount * (TimeScale.s_scale == 1 ? 1 : thrustBonus), -speedLimitX, speedLimitX);
					if (keysDown[UP])
						mc_object.rotation = 135;
					else if (keysDown[DOWN])
						mc_object.rotation = -135;
					else
						mc_object.rotation = 0;
				break;
			}
		}
		
		/**
		 * Update state of keys when a key is pressed
		 * @param	e		KeyboardEvent with info
		 */
		public function downKeyboard(e:KeyboardEvent):void
		{
			if (!alive) return;
			
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
				case Keyboard.SHIFT:
					keysDown[TIME] = true;
				break;
			}
		}
		
		/**
		 * Update state of keys when a key is released
		 * @param	e		KeyboardEvent with info
		 */
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
				case Keyboard.SHIFT:
					keysDown[TIME] = false;
				break;
			}
		}
		
		/**
		 * Changes timePoints by the given amount
		 * @param	tp		amount to change timePoints by
		 */
		public function changeTimePoints(tp:int):void
		{
			timePoints += tp;
			if (timePoints < 0)
				timePoints = 0;
			else if (timePoints > timePointsMax)
				timePoints = timePointsMax;
		}
		
		/**
		 * Kill the player
		 * Only works if the player is alive
		 */
		public function kill():void
		{
			if (!alive) return;
			alive = false;
			
			mc_object.play();
			
			cg.gameActive = false;
			dx = dx = 0;
		}
		
		/**
		 * Get the velocity of the player
		 * @return		A point containing (dx, dy)
		 */
		public function getd():Point
		{
			return new Point(dx, dy);
		}
		
		/**
		 * Get the player's score to be displayer
		 * @return		An int representing the score value to be displayed
		 */
		public function getScore():int
		{
			return displayedScore;
		}
		
		/**
		 * Changes the actualScore variable by a given integer
		 * @param	s		value to change actualScore by
		 */
		public function addScore(s:int):void
		{
			actualScore += s;
		}
		
	}
}