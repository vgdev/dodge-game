package vgdev.dodge
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * Main menu and level select screen.
	 * 
	 * @author Alexander Huynh
	 */
	public class ContainerMenu extends ABST_Container
	{
		public var eng:Engine;				// a reference to the Engine
		public var swc:SWC_MainMenu;		// the actual MovieClip
		
		/**
		 * A MovieClip handling the main menu.
		 * @param	_eng			A reference to the Engine.
		 */
		public function ContainerMenu(_eng:Engine)
		{			
			super();
			eng = _eng;
			
			// set up the MovieCllip
			swc = new SWC_ContainerMenu();
			addChild(swc);
			
			// set up the main menu
			swc.btn_start.addEventListener(MouseEvent.CLICK, onStart);
		}
		
		/**
		 * Called by the Start button in the main menu; starts the demo game
		 * @param	e		the captured MouseEvent, unused
		 */
		private function onStart(e:MouseEvent):void
		{
			completed = true;
		}

		/**
		 * Clean-up code
		 * 
		 * @param	e	the captured Event, unused
		 */
		protected function destroy(e:Event):void
		{
			//removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			swc.btn_start.removeEventListener(MouseEvent.CLICK, onStart);
			
			if (swc && contains(swc))
				removeChild(swc);
			swc = null;
			engine = null;
		}
	}
}
