package vgdev.dodge.props 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import vgdev.dodge.ContainerGame;
	import vgdev.dodge.mechanics.TimeScale;
	import vgdev.dodge.mechanics.HitTester;
	
	/**
	 * Abstract class
	 * Contains functionality useful to all Obstacles
	 * @author Alexander Huynh
	 */
	public class ABST_Obstacle extends ABST_Collidable
	{
		
		// bitmap embedding
		[Embed(source = "../../../../img/doge.png")]
		public static var Bitmap_Doge:Class;
		[Embed(source = "../../../../img/orange.png")]
		public static var Bitmap_Orange:Class;
		/*[Embed(source="../../../../img/peach.png")]
		public static var Bitmap_Peach:Class;*/
		[Embed(source = "../../../../img/apple.png")]
		public static var Bitmap_Apple:Class;
		
		public function ABST_Obstacle(_cg:ContainerGame, _params:Object)
		{
			super(_cg, _params);
			params = _params;
			
			if (!_params["image"])
			{
				mc_object.graphics.lineStyle(1, 0xFF0000, 1);
				mc_object.graphics.beginFill(0xFF0000, .2);
				if (_params["shape"] == "circle")
					mc_object.graphics.drawCircle(0, 0, 50);
				else
					mc_object.graphics.drawRect( -50, -50, 100, 100);
				mc_object.graphics.endFill();
				
				mc_object.tele.graphics.lineStyle(1, 0xFF0000, 1);
				mc_object.tele.graphics.beginFill(0xFF0000, .7);
				if (_params["shape"] == "circle")
					mc_object.tele.graphics.drawCircle(0, 0, 50);
				else
					mc_object.tele.graphics.drawRect( -50, -50, 100, 100);
				mc_object.tele.graphics.endFill();
			}
			else
			{
				isBitmap = true;
				var imgClass:Class;
				switch (_params["image"])
				{
					case "doge":		imgClass = Bitmap_Doge;		break;
					case "apple":		imgClass = Bitmap_Apple;	break;
					case "orange":		imgClass = Bitmap_Orange;	break;
					//case "peach":		imgClass = Bitmap_Peach;	break;
					default:			trace("ERROR in ABST_Obstacle: Image " + _params["image"] + " not found!");
				}
				var img:Bitmap = new imgClass();
				bitmapData = img.bitmapData;
				//img.x -= img.width * .5;
				//img.y -= img.height * .5;
				mc_object.addChild(img);
				img = new imgClass();
				//img.x -= img.width * .5;
				//img.y -= img.height * .5;
				mc_object.tele.addChild(img);
			}
			
			//trace("Obstacle added at " + mc_object.x + ", " + mc_object.y);
		}
		
		/**
		 * Check for collision with the Player
		 */
		override protected function checkCollision():Boolean
		{
			if (super.checkCollision())
			{
				cg.player.kill();
				trace("DEAD");
			}
			return true;
		}
	}
}