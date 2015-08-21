package vgdev.dodge
{
	import flash.events.Event;
	import vgdev.dodge.mechanics.ObstacleManager;
	import vgdev.dodge.mechanics.ObstacleTimeline;
	import vgdev.dodge.props.ABST_Obstacle;
	import vgdev.dodge.props.Player;
	import vgdev.dodge.mechanics.TimeScale;
	
	/**
	 * Primary game container and controller.
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
		
		public var gameActive:Boolean = true;		// TODO change later

		/**
		 * A MovieClip containing all of a Dodge level.
		 * @param	eng			A reference to the Engine.
		 */
		public function ContainerGame(eng:Engine)
		{
			super();
			engine = eng;
			game = new SWC_Game();
			addChild(game);
			for (var i:int = 0; i < 100; i++)
				game.mc_bg.addChild(new StarTemp());
				
			player = new Player(this);
			game.addChild(player.mc_object);
			
			// TODO make better later
			obstacleTimeline = new ObstacleTimeline();
			
			var ONE:int = 60;
			var TWO:int = 180;
			var THREE:int = 270;
			var FOUR:int = 500;
			var FIVE:int = 700;
			
			// TODO JSON
			// demo level 1
			/*obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":100, "y":100}), ONE);
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
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x": -200, "y":200, "scale":5, "circle":true, "spawn":60 } ), FIVE + 200);*/
			
			// demo level 2
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
			
			// demo level 3
			/*obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":0, "scale":1, "image": "doge",  "active":60}), ONE);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-250, "y":-100, "scale":4, "image": "doge",  "spawn":60, "active":60}), ONE + 30);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":250, "y":-150, "scale":2, "image": "doge"}), ONE + 60);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":180, "y":-50, "scale":2, "image": "doge"}), ONE + 75);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":120, "y":20, "scale":3, "image": "doge"}), ONE + 90);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":50, "y":80, "scale":3, "image": "doge"}), ONE + 105);*/
			
			
			obstacleManager = new ObstacleManager(this, obstacleTimeline);
		}

		/**
		 * called by Engine every frame
		 * @return		completed, true if this container is done
		 */
		override public function step():Boolean
		{
			if (gameActive)
			{
				player.step();
			}
			obstacleManager.step();
			
			game.scaleX = game.scaleY = .95 + TimeScale.s_scale * .05;
			
			return completed;			// return the state of the container (if true, it is done)
		}

		/**
		 * Clean-up code
		 * 
		 * @param	e	the captured Event, unused
		 */
		protected function destroy(e:Event):void
		{
			//removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			if (game && contains(game))
				removeChild(game);
			game = null;

			engine = null;
		}
	}
}
