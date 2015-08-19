package vgdev.dodge 
{
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * ...
	 * @author Alexander Huynh
	 */
	public class Engine 
	{
		private const STATE_MENU = 0;
		private const STATE_GAME = 1;
		
		private var gameState:int = STATE_MENU;
		private var container:MovieClip;
		
		public function Engine() 
		{
			addEventListener(Event.ENTER_FRAME, step);					// primary game loop firer
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * Helper to init the global keyboard listener (quality buttons)
		 * 
		 * @param	e	the captured Event, unused
		 */
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			
			container = new ContainerMenu(this);
		}
		
		/**
		 * Primary game loop event firer. Steps the current container, and advances
		 * to the next one if the current container is complete.
		 * 
		 * @param	e	the captured Event, unused
		 */
		public function step(e:Event):void
		{
			switch (gameState)			// determine which new container to go to next
			{
				case 0:
					containerGame = new ContainerGame(this, level, true);
					gameState = 1;
					SoundManager.play("sfx_elevator");
					startBGM();
					addChildAt(containerGame, 0);
				break;
				case 1:
					if (retryFlag)
					{
						containerGame = new ContainerGame(this, level, false);
						addChildAt(containerGame, 0);
						startBGM();
					}
					else if (nextFlag)
					{
						
					}
				break;
			}		
		}
		
		private function switchToContainer(container:ABST_Container):void
		{
			if (container && contains(container))
				
		}
		
		/**
		 * Global keyboard listener, used to listen for quality hotkeys.
		 * 
		 * @param	e	the captured KeyboardEvent, used to find the pressed key
		 */
		/*private function onKeyPress(e:KeyboardEvent):void
		{
			if (!stage)
				return;
			if (e.keyCode == 76)		// -- l
				stage.quality = StageQuality.LOW;
			else if (e.keyCode == 77)	// -- m
				stage.quality = StageQuality.MEDIUM;
			else if (e.keyCode == 72)	// -- h
				stage.quality = StageQuality.HIGH;
		}*/
	}
}