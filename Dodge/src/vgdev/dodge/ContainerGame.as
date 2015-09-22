package vgdev.dodge
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import vgdev.dodge.mechanics.ObstacleLoader;
	import vgdev.dodge.mechanics.ObstacleManager;
	import vgdev.dodge.mechanics.ObstacleTimeline;
	import vgdev.dodge.props.ABST_Obstacle;
	import vgdev.dodge.props.Player;
	import vgdev.dodge.mechanics.TimeScale;
	import flash.events.MouseEvent;
	
	/**
	 * Primary game container and controller
	 * 
	 * @author Alexander Huynh
	 */
	public class ContainerGame extends ABST_Container
	{		
		public var engine:Engine;		// the game's Engine
		public var game:SWC_Game;		// the Game SWC, containing all the base assets
		
		public var player:Player;
		
		public var obstacleTimeline:ObstacleTimeline;
		public var obstacleManager:ObstacleManager;
		public var obstacleLoader:ObstacleLoader;
		
		public var gameActive:Boolean = true;		// TODO change later
		public var gamePaused:Boolean = false;
		
		private var overCounter:int = 0;
		private var json:Object;					// level data
		
		// TODO move to SoundManager class
		[Embed(source = "../../../bgm/BGM_WildstarVanguard.mp3")]
		private var bgm_main:Class;

		/**
		 * A MovieClip containing all of a Dodge level
		 * @param	eng			A reference to the Engine
		 * @param	_json		Level data JSON object
		 */
		public function ContainerGame(eng:Engine, _json:Object)
		{
			super();
			engine = eng;
			json = _json;
			
			// set up the game MovieClip
			game = new SWC_Game();
			addChild(game);
			
			game.mc_paused.visible = false;
			game.mc_paused.menuPaused.btn_resume.addEventListener(MouseEvent.CLICK, unpauseHelper);
			game.mc_paused.menuPaused.btn_restart.addEventListener(MouseEvent.CLICK, onRestart);
			game.mc_paused.menuPaused.btn_quit.addEventListener(MouseEvent.CLICK, onQuit);
			game.mc_over.visible = false;
			game.mc_over.menuOver.btn_restart.addEventListener(MouseEvent.CLICK, onRestart);
			game.mc_over.menuOver.btn_quit.addEventListener(MouseEvent.CLICK, onQuit);
			
			// TODO remove later, temporary background FX
			for (var i:int = 0; i < 100; i++)
				game.mc_bg.addChild(new StarTemp());
				
			// set up the player
			player = new Player(this);
			game.container_player.addChild(player.mc_object);
			
			// TODO change later
			SoundMixer.stopAll();
			//var bgm:Sound = new bgm_main();
			//bgm.play();
			
			// TODO make better later
			obstacleTimeline = new ObstacleTimeline();
			
			obstacleLoader = new ObstacleLoader(this);
			obstacleLoader.loadLevel(json);
			
			var ONE:int = 60;
			var TWO:int = 180;
			var THREE:int = 270;
			var FOUR:int = 500;
			var FIVE:int = 700;
			
			// TODO JSON
			// demo level 1
			if (false)
			{
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":100, "y":100}), ONE);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-100, "y":100}), ONE + 30);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, { "x":100, "y": -100} ), ONE + 60);
			
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":-200, "scale":2}), TWO);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":-200, "scale":4}), TWO + 30);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":100, "scale":2}), TWO + 60);
			
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":0, "scale":6, "circle":true, "spawn":60}), THREE);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":-200, "scale":6, "circle":true, "spawn":60}), THREE + 60);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":200, "scale":6, "circle":true, "spawn":60}), THREE + 60);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":-200, "scale":6, "circle":true, "spawn":60}), THREE + 120);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":200, "scale":6, "circle":true, "spawn":60}), THREE + 120);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":-200, "scale":5, "circle":true, "spawn":60}), THREE + 180);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":200, "scale":5, "circle":true, "spawn":60}), THREE + 180);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":-200, "scale":5, "circle":true, "spawn":60}), THREE + 180);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x": -200, "y":200, "scale":5, "circle":true, "spawn":60 } ), THREE + 180);
			
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":600, "y":-100, "dx":-5, "scale":3, "active":200}), FOUR);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-600, "y":100, "dx":5, "scale":3, "active":200}), FOUR);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":-400, "dy":5, "scale":3, "active":200}), FOUR + 90);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, { "x":200, "y":400, "dy": -5, "scale":3, "active":200 } ), FOUR + 90);
			
			
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":0, "scale":2, "circle":true}), FIVE);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-300, "y":0, "scale":2, "circle":true}), FIVE + 15);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":300, "y":0, "scale":2, "circle":true}), FIVE + 15);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":-200, "scale":3, "circle":true}), FIVE + 30);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":200, "scale":3, "circle":true}), FIVE + 30);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":0, "scale":6, "circle":true}), FIVE + 50);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":-200, "scale":2, "circle":true}), FIVE + 90);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-100, "y":-100, "scale":2, "circle":true}), FIVE + 100);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":0, "scale":2, "circle":true}), FIVE + 110);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":100, "y":100, "scale":2, "circle":true}), FIVE + 120);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":200, "scale":2, "circle":true}), FIVE + 130);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":-200, "scale":2, "circle":true}), FIVE + 150);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":100, "y":-100, "scale":2, "circle":true}), FIVE + 160);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":0, "scale":2, "circle":true}), FIVE + 170);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-100, "y":100, "scale":2, "circle":true}), FIVE + 180);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":200, "scale":2, "circle":true}), FIVE + 190);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":-200, "scale":5, "circle":true, "spawn":60}), FIVE + 200);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":200, "scale":5, "circle":true, "spawn":60}), FIVE + 200);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":-200, "scale":5, "circle":true, "spawn":60}), FIVE + 200);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, { "x": -200, "y":200, "scale":5, "circle":true, "spawn":60 } ), FIVE + 200);
			}
			
			// demo level 2
			if (false)
			{
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":-150, "scaleX":4, "scaleY":3}), ONE);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":150, "scaleX":4, "scaleY":3}), ONE);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":150, "scaleX":4, "scaleY":3}), ONE);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":-150, "scaleX":4, "scaleY":3}), ONE + 30);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":150, "scaleX":4, "scaleY":3}), ONE + 30);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":150, "scaleX":4, "scaleY":3}), ONE + 30);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":-150, "scaleX":4, "scaleY":3}), ONE + 60);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":-150, "scaleX":4, "scaleY":3}), ONE + 60);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":150, "scaleX":4, "scaleY":3}), ONE + 60);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":-150, "scaleX":4, "scaleY":3}), ONE + 90);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":-150, "scaleX":4, "scaleY":3}), ONE + 90);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":150, "scaleX":4, "scaleY":3}), ONE + 90);
			
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-300, "y":0, "scaleX": 2, "scaleY":6, "spawn":60}), TWO);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-150, "y":0, "scaleX": 2, "scaleY":6, "spawn":60}), TWO + 20);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":0, "scaleX": 2, "scaleY":6, "spawn":60}), TWO + 40);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":150, "y":0, "scaleX": 2, "scaleY":6, "spawn":60}), TWO + 60);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":300, "y":0, "scaleX": 2, "scaleY":6, "spawn":60}), TWO + 80);
			
			THREE = 340;
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":300, "y":0, "scaleX": 2, "scaleY":6, "spawn":60}), THREE);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":150, "y":0, "scaleX": 2, "scaleY":6, "spawn":60}), THREE + 20);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":0, "scaleX": 2, "scaleY":6, "spawn":60}), THREE + 40);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-150, "y":0, "scaleX": 2, "scaleY":6, "spawn":60}), THREE + 60);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-300, "y":0, "scaleX": 2, "scaleY":6, "spawn":60}), THREE + 80);
			
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-400, "y":-300, "scale":12, "circle":true, "spawn":60}), FOUR);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":400, "y":300, "scale":12, "circle":true, "spawn":60}), FOUR);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":400, "y":-300, "scale":12, "circle":true, "spawn":60}), FOUR + 60);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-400, "y":300, "scale":12, "circle":true, "spawn":60}), FOUR + 60);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":-300, "scale":8, "circle":true, "spawn":60}), FOUR + 120);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":300, "scale":8, "circle":true, "spawn":60}), FOUR + 120);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":400, "y":0, "scale":8, "circle":true, "spawn":60}), FOUR + 180);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-400, "y":0, "scale":8, "circle":true, "spawn":60}), FOUR + 180);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":-300, "scale":3, "circle":true, "spawn":60}), FOUR + 180);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, { "x":0, "y":300, "scale":3, "circle":true, "spawn":60 } ), FOUR + 180);
			}
			
			// demo level 3
			if (false)
			{
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":0, "scale":1, "image": "doge",  "active":60}), ONE);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-250, "y":-100, "scale":4, "image": "doge",  "spawn":60, "active":60}), ONE + 30);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":250, "y":-150, "scale":2, "image": "doge"}), ONE + 60);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":180, "y":-50, "scale":2, "image": "doge"}), ONE + 75);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":120, "y":20, "scale":3, "image": "doge"}), ONE + 90);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":50, "y":80, "scale":3, "image": "doge"}), ONE + 105);
			}
			
			obstacleManager = new ObstacleManager(this, obstacleTimeline);
			engine.stage.addEventListener(KeyboardEvent.KEY_DOWN, downKeyboard);
			engine.stage.focus = engine.stage;
		}
		
		/**
		 * Helper to be called from ObstacleLoader
		 * @param	obst		the obstacle to add to the timeline
		 * @param	time		the frame to add the obstacle on
		 */
		public function addObstacle(obst:ABST_Obstacle, time:int):void
		{
			obstacleTimeline.addObstacle(obst, time);
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
					// reset level
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
				trace("[CG] Starting Game Over");
				game.mc_over.gotoAndPlay(1);
				return completed;
			}
			
			//  check if stage cleared and needs to start the "Stage Clear" animation (once)
			if (obstacleTimeline.gameComplete() && !obstacleManager.hasObstacles() && game.mc_over.currentFrame == 1)
			{
				trace(obstacleManager.hasObstacles());
				trace("[CG] Starting Stage Clear");
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
			
			// TODO make better, shrink the game if time is slowed
			game.scaleX = game.scaleY = .95 + TimeScale.s_scale * .05;
			
			return completed;			// return the state of the container (if true, it is done)
		}
		
		/**
		 * Callback for the "Restart" button in the pause menu
		 * Immediately restart the level
		 * Pass in null to this function to call it from places other than a callback
		 * @param	e		not used
		 */
		protected function onRestart(e:MouseEvent):void
		{
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
			completed = true;
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
