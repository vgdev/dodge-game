package vgdev.dodge 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	
	public class SoundManager 
	{
		
		[Embed(source = "../../../bgm/BGM_WildstarVanguard.mp3")]
		private static var bgm_main:Class;
		
		private static var bgm:SoundChannel;
		
		public function SoundManager() 
		{
			trace("WARNING: Should not instantiate SoundManager class!");
		}
		
		public static function play(sound:String):void
		{
			switch (sound)
			{
				default:
					trace("WARNING: No sound located for " + sound + "!");
			}
		}
		
		public static function playBGM(music:String):void
		{
			stopBGM();
			
			var snd:Sound;
			switch (music)
			{
				case "bgm_main":
					snd = new bgm_main();
					break;
				default:
					trace("WARNING: No music located for " + music + "!");
					return;
			}
			bgm = snd.play(0, 9999);
		}
		
		public static function stopBGM():void
		{
			if (bgm)
			{
				bgm.stop();
				bgm = null;
			}
		}
		
		public static function isBGMplaying():Boolean
		{
			return (bgm != null);
		}
		
		public static function shutUp():void
		{
			SoundMixer.stopAll();
		}
		
	}

}