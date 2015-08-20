package vgdev.dodge 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * ...
	 * @author Alexander Huynh
	 */
	public class Engine extends MovieClip
	{
		private const STAGE_WIDTH:int = 800;
		private const STAGE_HEIGHT:int = 600;
		
		private const STATE_MENU:int = 0;
		private const STATE_GAME:int = 1;
		
		private var gameState:int = STATE_MENU;
		private var container:MovieClip;
		
		public function Engine() 
		{
			addEventListener(Event.ENTER_FRAME, step);					// primary game loop firer
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			trace("ENGINE: Constructor");
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
			
			switchToContainer(new ContainerMenu(this), STAGE_WIDTH / 2, STAGE_HEIGHT / 2);
		}
		
		/**
		 * Primary game loop event firer. Steps the current container, and advances
		 * to the next one if the current container is complete.
		 * 
		 * @param	e	the captured Event, unused
		 */
		public function step(e:Event):void
		{
			if (container.step())
			{
				switch (gameState)			// determine which new container to go to next
				{
					case STATE_MENU:
						switchToContainer(new ContainerGame(this), STAGE_WIDTH / 2, STAGE_HEIGHT / 2);
						gameState = STATE_GAME;
					break;
					case STATE_GAME:
						switchToContainer(new ContainerMenu(this), STAGE_WIDTH / 2, STAGE_HEIGHT / 2);
						gameState = STATE_MENU;
					break;
				}
			}
		}
		
		private function switchToContainer(containerNew:ABST_Container, offX:Number = 0, offY:Number = 0):void
		{
			if (container && contains(container))
			{
				removeChild(container);
				container = null;
			}
			trace(offX + " " + offY);
			container = containerNew;
			container.x += offX;
			container.y += offY;
			addChild(container);
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