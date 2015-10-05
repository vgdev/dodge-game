package vgdev.dodge
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	/**
	 * Main menu and level select screen
	 * 
	 * @author Alexander Huynh
	 */
	public class ContainerMenu extends ABST_Container
	{
		public var eng:Engine;					// a reference to the Engine
		public var swc:SWC_MainMenu;			// the actual MovieClip
		
		private var buttonGlow:GlowFilter;		// glow for the buttons
		private var currAlpha:Number = 0;		// current alpha value for the button glow
		private const MAX_ALPHA:Number = .4;	// max alpha value for the button glow
		private var currBtn:SimpleButton;		// helper to reset glow
		
		/**
		 * A MovieClip handling the main menu
		 * @param	_eng			A reference to the Engine
		 */
		public function ContainerMenu(_eng:Engine)
		{			
			super();
			eng = _eng;
			
			SoundManager.playBGM("bgm_menu");
			
			// set up button glow
			buttonGlow = new GlowFilter(0x73FFF8, .75, 16, 16, 4);
			
			// set up the MovieClip
			swc = new SWC_MainMenu();
			addChild(swc);
			
			// set up the main menu
			swc.btn_start.addEventListener(MouseEvent.CLICK, onStart);
			swc.btn_options.addEventListener(MouseEvent.CLICK, onOptions);
			swc.btn_credits.addEventListener(MouseEvent.CLICK, onCredits);
			
			// set up arrow button follower
			swc.btn_start.addEventListener(MouseEvent.ROLL_OVER, ovrBtn);
			swc.btn_options.addEventListener(MouseEvent.ROLL_OVER, ovrBtn);
			swc.btn_credits.addEventListener(MouseEvent.ROLL_OVER, ovrBtn);
			
			// set up levels
			// TODO remove temporary hard-coded stuff
			swc.mc_levels.base.level_00.tf_title.text = "Test";
			swc.mc_levels.base.level_00.hitbox.addEventListener(MouseEvent.CLICK, onLevel);
			swc.mc_levels.base.level_01.tf_title.text = "Tester";
			swc.mc_levels.base.level_01.hitbox.addEventListener(MouseEvent.CLICK, onLevel);
			swc.mc_levels.base.level_02.tf_title.text = "Testest";
			swc.mc_levels.base.level_02.hitbox.addEventListener(MouseEvent.CLICK, onLevel);
		}
		
		/**
		 * Called by the Start button in the main menu; shows the levels
		 * @param	e		the captured MouseEvent, unused
		 */
		private function onStart(e:MouseEvent):void
		{
			swc.mc_levels.gotoAndPlay("in");
		}
		
		/**
		 * Called by the Options button in the main menu; shows the options
		 * @param	e		the captured MouseEvent, unused
		 */
		private function onOptions(e:MouseEvent):void
		{
			swc.mc_options.gotoAndPlay("in");
		}
		
		/**
		 * Called by the Credits button in the main menu; shows the credits
		 * @param	e		the captured MouseEvent, unused
		 */
		private function onCredits(e:MouseEvent):void
		{
			swc.mc_credits.gotoAndPlay("in");
		}
		
		/**
		 * Called by a level folder button; starts the game with the given level
		 * @param	e		the captured MouseEvent, used to determine which button was pressed
		 */
		private function onLevel(e:MouseEvent):void
		{
			// TODO remove temporary hard-coded stuff
			trace(e.target.parent.name);
			switch(e.target.parent.name)
			{
				case "level_00":
					eng.currLevel = "lvl_tutorial_01";
				break;
				case "level_01":
					eng.currLevel = "lvl_tutorial_02";
				break;
				case "level_02":
					eng.currLevel = "lvl_test";
				break;
			}
			completed = true;
		}
		
		/**
		 * Called when the mouse hovers over a button.
		 * Moves the marker to that button
		 * @param	e		the captured MouseEvent, used to get the mouse target
		 */
		private function ovrBtn(e:MouseEvent):void
		{
			// prevent mouse over transformation from breaking the tween
			if (swc.currentFrame != swc.totalFrames)
				return;
			// update the > marker position
			if (swc.mc_marker)
			{
				swc.mc_marker.y = e.target.y;
				swc.mc_marker.filters = [];
			}
			if (currBtn)
				currBtn.filters = [];
			if (e.target != currBtn)
				currAlpha = 0;
			currBtn = e.target as SimpleButton;
			addEventListener(Event.ENTER_FRAME, updateBtns);
		}
		
		/**
		 * Helper to fade in button glow alpha until it hits MAX_ALPHA
		 * @param	e		the captured Event, unused
		 */
		private function updateBtns(e:Event):void
		{
			currAlpha += .02;
			if (currAlpha >= MAX_ALPHA)
			{
				currAlpha = MAX_ALPHA;
				removeEventListener(Event.ENTER_FRAME, step);
			}
			buttonGlow.alpha = currAlpha;
			if (currBtn)
				currBtn.filters = [buttonGlow];
			if (swc.mc_marker)
				swc.mc_marker.filters = [buttonGlow];
		}

		/**
		 * Clean-up code
		 * @param	e	the captured Event, unused
		 */
		protected function destroy(e:Event):void
		{
			swc.btn_start.removeEventListener(MouseEvent.CLICK, onStart);
			
			if (swc && contains(swc))
				removeChild(swc);
			swc = null;
			eng = null;
		}
	}
}
