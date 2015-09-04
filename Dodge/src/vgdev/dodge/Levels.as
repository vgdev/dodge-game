package vgdev.dodge 
{	
	/**
	 * If JSON is not defined, set Project -> Properties -> Flash Player -> 11.6
	 * @author Alexander Huynh
	 */
	public class Levels 
	{
		[Embed(source = "../../../json/lvl_tutorial.json", mimeType = "application/octet-stream")]
		public var lvl_tutorial:Class;
		
		private var levels:Object;
		
		public function Levels() 
		{
			levels = new Object();
			
			levels["lvl_tutorial"] = JSON.parse(new lvl_tutorial());
		}
		
		public function getLevel(lvl:String):Object
		{
			trace("Returning: " + levels[lvl]);
			return levels[lvl];
		}
	}
}