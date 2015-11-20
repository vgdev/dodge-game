package vgdev.dodge 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * Primary game 'holder' and updater
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
		
		public const RET_NORMAL:int = 0;
		public const RET_RESTART:int = 1;
		public const RET_NEXT:int = 2;
		public var returnCode:int = RET_NORMAL;
		
		public var levels:Levels;
		public var currLevel:String;				// set by ContainerMenu; determines which level to load
		
		public function Engine() 
		{
			levels = new Levels();
			
			addEventListener(Event.ENTER_FRAME, step);					// primary game loop firer
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * Helper to init the global keyboard listener (quality buttons)
		 * @param	e	the captured Event, unused
		 */
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
			switchToContainer(new ContainerMenu(this), STAGE_WIDTH * .5, STAGE_HEIGHT * .5);
		}
		
		/**
		 * Primary game loop event firer. Steps the current container, and advances
		 * 	to the next one if the current container is complete
		 * @param	e	the captured Event, unused
		 */
		public function step(e:Event):void
		{
			if (container.step())
			{
				switch (gameState)			// determine which new container to go to next
				{
					case STATE_MENU:
						switchToContainer(new ContainerGame(this, levels.getLevel(currLevel), currLevel == "He's the Boss"), STAGE_WIDTH * .5, STAGE_HEIGHT * .5);
						gameState = STATE_GAME;
					break;
					case STATE_GAME:
						if (returnCode == RET_NORMAL)
						{
							switchToContainer(new ContainerMenu(this, true), STAGE_WIDTH * .5, STAGE_HEIGHT * .5);
							gameState = STATE_MENU;
						}
						else if (returnCode == RET_RESTART)
						{
							switchToContainer(new ContainerGame(this, levels.getLevel(currLevel), currLevel == "He's the Boss"), STAGE_WIDTH * .5, STAGE_HEIGHT * .5);
							gameState = STATE_GAME;
						}
						else if (returnCode == RET_NEXT)
						{
							currLevel = levels.getNextLevelName(currLevel);
							switchToContainer(new ContainerGame(this, levels.getLevel(currLevel), currLevel == "He's the Boss"), STAGE_WIDTH * .5, STAGE_HEIGHT * .5);
							gameState = STATE_GAME;
						}
					break;
				}
			}
		}
		
		/**
		 * Helper to switch from the current container to the new, given one
		 * @param	containerNew		The container to switch to
		 * @param	offX				Offset x to translate the new container by
		 * @param	offY				Offset y to translate the new container by
		 */
		private function switchToContainer(containerNew:ABST_Container, offX:Number = 0, offY:Number = 0):void
		{
			if (container && contains(container))
			{
				removeChild(container);
				container = null;
			}
			container = containerNew;
			container.x += offX;
			container.y += offY;
			addChild(container);
			
			returnCode = RET_NORMAL;
		}
		
		/**
		 * Global keyboard listener, used to listen for quality hotkeys.
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