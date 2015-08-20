package vgdev.dodge
{
	import flash.events.Event;
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
		}

		/**
		 * called by Engine every frame
		 * @return		completed, true if this container is done
		 */
		override public function step():Boolean
		{			
			player.step();
			
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
