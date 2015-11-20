package vgdev.dodge 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	
	public class SoundManager 
	{
		
		[Embed(source="../../../bgm/BGM_mainMenu.mp3")]
		private static var bgm_menu:Class;
		[Embed(source="../../../bgm/BGM_level.mp3")]
		private static var bgm_main:Class;
		[Embed(source="../../../bgm/BGM_levelDoge.mp3")]
		private static var bgm_mainD:Class;
		
		[Embed(source = "../../../bgm/SFX_death.mp3")]
		private static var SFX_death:Class;
		[Embed(source = "../../../bgm/SFX_fast.mp3")]
		private static var SFX_fast:Class;
		[Embed(source = "../../../bgm/SFX_power.mp3")]
		private static var SFX_power:Class;
		[Embed(source="../../../bgm/SFX_slow.mp3")]
		private static var SFX_slow:Class;
		
		[Embed(source="../../../bgm/SFX_menuOver.mp3")]
		private static var SFX_menuOver:Class;
		[Embed(source="../../../bgm/SFX_menuDown.mp3")]
		private static var SFX_menuDown:Class;
		
		private static var sounds:Object = new Object();
		private static var bgm:SoundChannel;
		
		private static var currentBGM:String = "";
		
		public function SoundManager() 
		{
			trace("WARNING: Should not instantiate SoundManager class!");
		}
		
		public static function playSound(sound:String):void
		{
			var snd:Sound;
			switch (sound)
			{
				case "sfx_death":
					snd = (new SFX_death()) as Sound;
				break;
				case "sfx_fast":
					snd = (new SFX_fast()) as Sound;
				break;
				case "sfx_power":
					snd = (new SFX_power()) as Sound;
				break;
				case "sfx_menuOver":
					snd = (new SFX_menuOver()) as Sound;
				break;
				case "sfx_menuDown":
					snd = (new SFX_menuDown()) as Sound;
				break;
				default:
					trace("WARNING: No sound located for " + sound + "!");
			}
			if (snd)
				snd.play();
		}
		
		public static function playBGM(music:String):void
		{
			if (currentBGM == music)
				return;
			stopBGM();
			
			var snd:Sound;
			switch (music)
			{
				case "bgm_main":
					snd = new bgm_main();
					break;
				case "bgm_doge":
					snd = new bgm_mainD();
					break;
				case "bgm_menu":
					snd = new bgm_menu();
					break;
				default:
					trace("WARNING: No music located for " + music + "!");
					return;
			}
			currentBGM = music;
			
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