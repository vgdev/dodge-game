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
	public class ABST_Obstacle extends ABST_Prop
	{		
		/// Frames to show the telegraph - no damage during this time
		public var spawnTime:int = 30;
		
		/// Frames to keep the telegraph as dangerous
		public var activeTime:int = 3;
		
		/// Frames to fade the telegraph - no damage during this time
		public var despawnTime:int = 10;
		
		/// Current frame counter
		public var currentTime:Number = 0;
		
		// state machine constants
		public const STATE_WAIT:int = 0;
		public const STATE_SPAWN:int = 1;
		public const STATE_ACTIVE:int = 2;
		public const STATE_DESPAWN:int = 3;
		public const STATE_DEAD:int = 4;
		
		public var currentState:int = STATE_WAIT;
		
		// helpers to use if obstacle is a bitmap instead of just a drawing shape
		public var isBitmap:Boolean = false;
		public var bitmapData:BitmapData;
		
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
			super(_cg);
			params = _params;
			
			// set up mc_object
			mc_object = new MovieClip();
			mc_object.tele = new MovieClip();		// the 'expanding' warning part of the obstacle
			mc_object.addChild(mc_object.tele);
			
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
			
			// read and set params from _params object
			spawnTime = setParam("spawn", spawnTime);
			activeTime = setParam("active", activeTime);
			mc_object.x = setParam("x", 0);
			mc_object.y = setParam("y", 0);
			dx = setParam("dx", 0);
			dy = setParam("dy", 0);
			dr = setParam("dr", 0);
			mc_object.rotation = setParam("rot", 0);
			mc_object.scaleX = mc_object.scaleY = setParam("scale", 1);
			mc_object.scaleX = setParam("scaleX", mc_object.scaleX);
			mc_object.scaleY = setParam("scaleY", mc_object.scaleY);
			
			mc_object.visible = false;
			
			//trace("Obstacle added at " + mc_object.x + ", " + mc_object.y);
		}
		
		/**
		 * Starts the telegraph
		 */
		public function activate():void
		{			
			mc_object.visible = true;
			
			currentState = STATE_SPAWN;
			currentTime = 0;
			
			mc_object.alpha = .2;		// TODO remove temporary
		}
		
		/**
		 * Updates the obstacle
		 * @return		true if the obstacle is done and should be cleaned up
		 */
		override public function step():Boolean
		{
			// increase the counter by '1 frame', modified by the current time scale
			currentTime += TimeScale.s_scale;
			
			switch (currentState)
			{
				case STATE_WAIT:
				break;
				case STATE_SPAWN:
					updatePosition();
					mc_object.tele.scaleX = mc_object.tele.scaleY = currentTime / spawnTime;
					if (currentTime >= spawnTime)
					{
						currentState = STATE_ACTIVE;
						currentTime = 0;
						mc_object.tele.scaleX = mc_object.tele.scaleY = 1;
						mc_object.alpha = 1;
					}
				break;
				case STATE_ACTIVE:
					updatePosition();
					if (currentTime >= activeTime)
					{
						currentState = STATE_DESPAWN;
						currentTime = 0;
					}
					else
					{
						checkCollision();
					}
				break;
				case STATE_DESPAWN:
					mc_object.alpha = 1 - (currentTime / despawnTime);
					if (currentTime >= despawnTime)
					{
						currentState = STATE_DEAD;
						completed = true;
						mc_object.visible = false;
					}
				break;
			}
			
			return completed;
		}
		
		/**
		 * Check for collision with the Player
		 */
		protected function checkCollision():void
		{
			var ptPlayer:Point = (new Point(cg.player.mc_object.x + 400, cg.player.mc_object.y + 300));
			if (mc_object.hitTestObject(cg.player.mc_object))
			{
				// TODO fix me please
				if ((!isBitmap && mc_object.hitTestPoint(ptPlayer.x, ptPlayer.y, true)) ||
					 HitTester.realHitTest(mc_object, ptPlayer))
				{
					cg.player.kill();
					trace("DEAD");
				}
				else trace("ok");
			}
		}
		
		/**
		 * Move the obstacle's x and y according to its dx and dy
		 */
		protected function updatePosition():void
		{
			mc_object.x = changeWithLimit(mc_object.x, dx);
			mc_object.y = changeWithLimit(mc_object.y, dy);
			mc_object.rotation = changeWithLimit(mc_object.rotation, dr);
		}
	}
}