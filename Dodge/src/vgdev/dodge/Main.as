package vgdev.dodge
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 *	Initial file to run - sets up stage and entry point
	 *	@author Alexander Huynh
	 */
	public class Main extends Sprite 
	{
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addChild(new Engine());
		}
	}
}