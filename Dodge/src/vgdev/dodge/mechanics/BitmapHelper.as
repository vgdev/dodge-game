package vgdev.dodge.mechanics 
{
	import flash.display.Bitmap;

	/**
	 * Static class
	 * Holds embedded bitmaps and makes them available
	 * @author Alexander Huynh
	 */
	public class BitmapHelper 
	{
		// TODO make it work
		
		[Embed(source = "../../../img/doge.png")]
		public static var Bitmap_Doge:Class;
		
		public function BitmapHelper() 
		{
		}
		
		public static function getBitmap(className:Class):Bitmap
		{
			return (new className() as Bitmap);
		}
	}
}