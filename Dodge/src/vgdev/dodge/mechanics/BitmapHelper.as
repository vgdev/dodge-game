package vgdev.dodge.mechanics 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Alexander Huynh
	 */
	public class BitmapHelper 
	{
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