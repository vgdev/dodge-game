package vgdev.dodge.props 
{
	import flash.display.MovieClip;
	import vgdev.dodge.ContainerGame;

	/**
	 * An abstract class containing functionality useful to all game objects.
	 * @author 	Alexander Huynh
	 */
	class ABST_Prop 
	{
		/// A reference to the active instance of ContainerGame.
		protected var cg:ContainerGame;
		
		/// The MovieClip associated with this object. (The actual graphic on the stage.)
		public var mc_object:MovieClip;
		
		protected var completed:Boolean = false;

		/**
		 * Should only be called through super(), never instantiated.
		 * @param	_cg			The active instance of ContainerGame.
		 */
		public function ABST_Prop(_cg:ContainerGame) 
		{
			cg = _cg;
		}
		
		public function step():Boolean
		{
			return completed;
		}
		
		/**
		 * Returns a random Number between min and max, inclusive.
		 * @param	min		The lower bound
		 * @param	max		The upper bound
		 * @return			A random Number between min and max
		 */
		protected function getRand(min:Number, max:Number):Number   
		{  
			return Math.random() * (max - min + 1) + min;  
		}
		
		protected function changeWithLimit(original:Number, change:Number,
										   limLow:Number = int.MAX_VALUE, limHigh:Number = int.MAX_VALUE):Number
		{
			original += change;
			if (original < limLow)
				original = limLow;
			else if (original > limHigh)
				original = limHigh;
			return original;
		}
	}
}