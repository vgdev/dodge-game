package vgdev.dodge 
{	
	/**
	 * If JSON is not defined, set Project -> Properties -> Flash Player -> 11.6
	 * @author Alexander Huynh
	 */
	public class Levels 
	{
		[Embed(source = "../../../json/lvl_tutorial_01.json", mimeType = "application/octet-stream")]
		public var lvl_tutorial_01:Class;
		[Embed(source = "../../../json/lvl_tutorial_02.json", mimeType = "application/octet-stream")]
		public var lvl_tutorial_02:Class;
		[Embed(source = "../../../json/lvl_hallways.json", mimeType = "application/octet-stream")]
		public var lvl_hallways:Class;
		
		[Embed(source = "../../../json/lvl_tutorial.json", mimeType = "application/octet-stream")]
		public var lvl_tutorial:Class;
		[Embed(source="../../../json/lvl_test.json", mimeType="application/octet-stream")]
		public var lvl_test:Class;
		[Embed(source="../../../json/lvl_collisionTest.json", mimeType="application/octet-stream")]
		public var lvl_collisionTest:Class;
		[Embed(source="../../../json/lvl_pickupTest.json", mimeType="application/octet-stream")]
		public var lvl_pickupTest:Class;
		
		private var levels:Object;
		public var levelPages:Array = [];		// a 2D
		
		public function Levels() 
		{
			// TODO make JSON?
			// set up levels object
			levels = new Object();

			levels["Tutorial 1"] = JSON.parse(new lvl_tutorial_01());
			levels["Tutorial 2"] = JSON.parse(new lvl_tutorial_02());
			levels["Hallways"] = JSON.parse(new lvl_hallways());

			levels["lvl_tutorial"] = JSON.parse(new lvl_tutorial());
			levels["Generic Test"] = JSON.parse(new lvl_test());
			levels["lvl_collisionTest"] = JSON.parse(new lvl_collisionTest());
			levels["Pickup Test"] = JSON.parse(new lvl_pickupTest());

			// set up levelPages array
			levelPages[0] = ["Tutorial 1", "Tutorial 2", null, null, "Hallways", null, null, null];
			levelPages[1] = ["Pickup Test", null, null, null, null, null, "Generic Test", null];
		}
		
		public function getLevel(lvl:String):Object
		{
			trace("Returning: " + lvl);
			return levels[lvl];
		}
	}
}