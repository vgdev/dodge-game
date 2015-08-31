package vgdev.dodge.props 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import vgdev.dodge.ContainerGame;
	import vgdev.dodge.mechanics.TimeScale;
	
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
		
		// TODO remove temporary code
		[Embed(source = "../../../../img/doge.png")]
		public static var Bitmap_Doge:Class;
		
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
				if (_params["circle"])
					mc_object.graphics.drawCircle(0, 0, 50);
				else
					mc_object.graphics.drawRect( -50, -50, 100, 100);
				mc_object.graphics.endFill();
				
				mc_object.tele.graphics.lineStyle(1, 0xFF0000, 1);
				mc_object.tele.graphics.beginFill(0xFF0000, .7);
				if (_params["circle"])
					mc_object.tele.graphics.drawCircle(0, 0, 50);
				else
					mc_object.tele.graphics.drawRect( -50, -50, 100, 100);
				mc_object.tele.graphics.endFill();
			}
			else
			{
				isBitmap = true;
				//trace("Adding: " + (new Bitmap_Doge()));
				//_params["image"].x -= _params["image"].width * .5;		// center the image
				//_params["image"].y -= _params["image"].height * .5;
				var img:Bitmap = new Bitmap_Doge();
				bitmapData = img.bitmapData;
				img.x -= img.width * .5;
				img.y -= img.height * .5;
				mc_object.addChild(img);
				img = new Bitmap_Doge();
				img.x -= img.width * .5;
				img.y -= img.height * .5;
				mc_object.tele.addChild(img);
			}
			
			// TODO read and set params from _params object
			spawnTime = setParam("spawn", spawnTime);
			activeTime = setParam("active", activeTime);
			mc_object.x = setParam("x", 0);
			mc_object.y = setParam("y", 0);
			dx = setParam("dx", 0);
			dy = setParam("dy", 0);
			mc_object.rotation = setParam("rot", 0);
			mc_object.scaleX = mc_object.scaleY = setParam("scale", 1);
			mc_object.scaleX = setParam("scaleX", mc_object.scaleX);
			mc_object.scaleY = setParam("scaleY", mc_object.scaleY);
			
			mc_object.visible = false;
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
				break;
				case STATE_DESPAWN:
					mc_object.alpha = 1 - (currentTime / despawnTime);
					if (currentTime >= despawnTime)
					{
						currentState = STATE_DEAD;
						completed = true;
					}
				break;
			}
			
			return completed;
		}
		
		/**
		 * Move the obstacle's x and y according to its dx and dy
		 */
		protected function updatePosition():void
		{
			mc_object.x = changeWithLimit(mc_object.x, dx);
			mc_object.y = changeWithLimit(mc_object.y, dy);
		}
	}
}