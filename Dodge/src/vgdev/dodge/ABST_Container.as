package vgdev.dodge
{
	import flash.display.MovieClip;
	
	/**
	 * 	An Engine-steppable container
	 * 	ABSTRACT CLASS - do not instantiate
	 * 	@author Alexander Huynh
	 */
	public class ABST_Container extends MovieClip
	{
		protected var completed:Boolean;
		
		public function ABST_Container()
		{
			completed = false;
		}
		
		public function step():Boolean
		{
			return completed;
		}
	}
}
