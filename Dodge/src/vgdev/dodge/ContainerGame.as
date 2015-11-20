package vgdev.dodge
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import vgdev.dodge.mechanics.ObstacleLoader;
	import vgdev.dodge.mechanics.ObstacleManager;
	import vgdev.dodge.mechanics.ObstacleTimeline;
	import vgdev.dodge.props.ABST_Prop;
	import vgdev.dodge.props.Player;
	import vgdev.dodge.mechanics.TimeScale;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	/**
	 * Primary game container and controller
	 * 
	 * @author Alexander Huynh
	 */
	public class ContainerGame extends ABST_Container
	{		
		public var engine:Engine;		// the game's Engine
		public var game:SWC_Game;		// the Game SWC, containing all the base assets
		private var anchor:Point;		// the starting coordinates of the game SWC
		
		public var player:Player;
		
		public var obstacleTimeline:ObstacleTimeline;
		public var obstacleManager:ObstacleManager;
		public var obstacleLoader:ObstacleLoader;
		
		public var gameActive:Boolean = true;
		public var gamePaused:Boolean = false;
		
		private var overCounter:int = 0;
		private var json:Object;					// level data
		private var isLastLevel:Boolean = false;

		/**
		 * A MovieClip containing all of a Dodge level
		 * @param	eng			A reference to the Engine
		 * @param	_json		Level data JSON object
		 */
		public function ContainerGame(eng:Engine, _json:Object, _isLastLevel:Boolean = false)
		{
			super();
			engine = eng;
			json = _json;
			isLastLevel = _isLastLevel;
			
			// set up the game MovieClip
			game = new SWC_Game();
			addChild(game);
			anchor = new Point(game.x, game.y);
			
			if (_json["meta"]["bg"] != null)
			{
				trace("Choosing background " + _json["meta"]["bg"]);
				game.mc_bg.gotoAndStop(_json["meta"]["bg"]);
			}
			
			game.mc_paused.visible = false;
			game.mc_paused.menuPaused.btn_resume.addEventListener(MouseEvent.CLICK, unpauseHelper);
			game.mc_paused.menuPaused.btn_restart.addEventListener(MouseEvent.CLICK, onRestart);
			game.mc_paused.menuPaused.btn_quit.addEventListener(MouseEvent.CLICK, onQuit);
			game.mc_paused.menuPaused.btn_resume.addEventListener(MouseEvent.MOUSE_OVER, overBtn);
			game.mc_paused.menuPaused.btn_restart.addEventListener(MouseEvent.MOUSE_OVER, overBtn);
			game.mc_paused.menuPaused.btn_quit.addEventListener(MouseEvent.MOUSE_OVER, overBtn);
			
			game.mc_over.visible = false;
			game.mc_over.menuOver.btn_restart.addEventListener(MouseEvent.CLICK, onRestart);
			game.mc_over.menuOver.btn_quit.addEventListener(MouseEvent.CLICK, onQuit);
			game.mc_over.menuOver.btn_next.addEventListener(MouseEvent.CLICK, onNext);
			game.mc_over.menuOver.btn_restart.addEventListener(MouseEvent.MOUSE_OVER, overBtn);
			game.mc_over.menuOver.btn_quit.addEventListener(MouseEvent.MOUSE_OVER, overBtn);
			game.mc_over.menuOver.btn_next.addEventListener(MouseEvent.MOUSE_OVER, overBtn);
			game.mc_over.menuOver.btn_next.visible = !isLastLevel;
			
			if (eng.currLevel != "Arrow Assault")
				for (var i:int = 0; i < 100; i++)
					game.mc_bg.addChild(new StarTemp());
				
			// set up the player
			player = new Player(this);
			game.container_player.addChild(player.mc_object);
			
			SoundManager.playBGM((eng.currLevel == "He's the Boss" ? "bgm_doge" : "bgm_main"));
			
			obstacleTimeline = new ObstacleTimeline();
			
			obstacleLoader = new ObstacleLoader(this);
			obstacleLoader.loadLevel(json);
			
			obstacleManager = new ObstacleManager(this, obstacleTimeline);
			engine.stage.addEventListener(KeyboardEvent.KEY_DOWN, downKeyboard);
			engine.stage.focus = engine.stage;
			
			// tutorial
			if (eng.currLevel == "Simple Dodge")
				game.mc_tutorial.gotoAndPlay("move");
			else if (eng.currLevel == "Slow it Down")
				game.mc_tutorial.gotoAndPlay("slow");
			else if (eng.currLevel == "Pick it Up")
				game.mc_tutorial.gotoAndPlay("pickups");
		}
		
		/**
		 * Helper to be called from ObstacleLoader
		 * @param	obst		the obstacle/pickup to add to the timeline
		 * @param	time		the frame to add the obstacle/pickup on
		 */
		public function addProp(prop:ABST_Prop, time:int):void
		{
			obstacleTimeline.addProp(prop, time);
		}
		
		/**
		 * Callback when a key is pressed; i.e. a key goes from NOT PRESSED to PRESSED
		 * @param	e		the associated KeyboardEvent; use e.keyCode
		 */
		private function downKeyboard(e:KeyboardEvent):void
		{			
			switch (e.keyCode)
			{
				case Keyboard.P:
					if (gamePaused && game.mc_paused.currentFrameLabel == "hold")
					{
						unpauseHelper(null);
					}
					else if (game.mc_paused.currentFrame == 1)
					{
						game.mc_paused.gotoAndPlay("in");
						gamePaused = true;
					}
				break;
				case Keyboard.R:
					onRestart(new MouseEvent(MouseEvent.CLICK));
				break;
			}
		}
		
		/**
		 * Plays the 'out' animation for the pause screen and readies the unpause helper
		 * @param	e		not used
		 */
		private function unpauseHelper(e:MouseEvent):void
		{
			game.mc_paused.gotoAndPlay("out");
			game.mc_paused.addEventListener(Event.ENTER_FRAME, unpause);
		}
		
		/**
		 * Callback used between the 'out' animation for the pause screen, and when it finishes animating
		 * Unpauses the game and removes the callback
		 * @param	e		not used
		 */
		private function unpause(e:Event):void
		{
			if (game.mc_paused.currentFrame == 1)
			{
				game.mc_paused.removeEventListener(Event.ENTER_FRAME, unpause);
				gamePaused = false;
			}
		}

		/**
		 * Called by Engine every frame to update the game
		 * @return		completed, true if this container is done
		 */
		override public function step():Boolean
		{
			if (gamePaused)
				return completed;
			// -- do the following only if the game is not paused
			
			// check if game over and needs to start the "Game Over" animation (once)
			if (!player.alive && overCounter < 45 && ++overCounter == 45)
			{
				game.mc_over.gotoAndPlay(1);
				game.mc_over.menuOver.btn_next.visible = false;
				return completed;
			}
			
			//  check if stage cleared and needs to start the "Stage Clear" animation (once)
			if (obstacleTimeline.gameComplete() && !obstacleManager.hasObstacles() && game.mc_over.currentFrame == 1)
			{
				game.mc_over.gotoAndPlay(1);
				game.mc_over.menuOver.gotext.gotoAndStop(2);
				return completed;
			}

			// helper to continue stepping the obstacles but not the player if the player dies
			if (gameActive)
			{
				player.step();
			}
			obstacleManager.step();
			
			// zoom and pan the game on the player if time is slowed
			game.scaleX = game.scaleY = 1 + (1 - TimeScale.s_scale) * .2;
			game.x = anchor.x - (1 - TimeScale.s_scale) * player.mc_object.x * .4;
			game.y = anchor.y - (1 - TimeScale.s_scale) * player.mc_object.y * .4;
			
			return completed;			// return the state of the container (if true, it is done)
		}
		
		/**
		 * Ends the current stage immediately
		 */
		public function endStage():void
		{
			obstacleManager.reset();
			obstacleTimeline.frameNow = obstacleTimeline.highestFrame;
		}

		/**
		 * Callback for the "Next" button in the pause menu
		 * Immediately quit the level and go to the next game state, defined in Engine
		 * @param	e		not used
		 */
		protected function onNext(e:MouseEvent):void
		{
			SoundManager.playSound("sfx_menuDown");
			engine.returnCode = engine.RET_NEXT;
			completed = true;
		}
		
		/**
		 * Callback for the "Restart" button in the pause menu
		 * Immediately restart the level
		 * Pass in null to this function to call it from places other than a callback
		 * @param	e		not used
		 */
		protected function onRestart(e:MouseEvent):void
		{
			SoundManager.playSound("sfx_menuDown");
			engine.returnCode = engine.RET_RESTART;
			completed = true;
		}
		
		/**
		 * Callback for the "Quit" button in the pause menu
		 * Immediately quit the level and go to the next game state, defined in Engine
		 * Pass in null to this function to call it from places other than a callback
		 * @param	e		not used
		 */
		protected function onQuit(e:MouseEvent):void
		{
			SoundManager.playSound("sfx_menuDown");
			completed = true;
		}
		
		protected function overBtn(e:MouseEvent):void
		{
			SoundManager.playSound("sfx_menuOver");
		}

		/**
		 * Clean-up code
		 * @param	e	the captured Event, unused
		 */
		protected function destroy(e:Event):void
		{			
			if (engine.stage.hasEventListener(KeyboardEvent.KEY_DOWN))
				engine.stage.removeEventListener(KeyboardEvent.KEY_DOWN, downKeyboard);
			
			if (game && contains(game))
				removeChild(game);
			game = null;

			engine = null;
		}
	}
}
