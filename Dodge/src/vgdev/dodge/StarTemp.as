// For GATech VGDev Second Biannual Campus Demo
// v1.0 Mar 04, 2013

// Borrowed again for Dodge, Aug 2015

package vgdev.dodge
{
 import flash.display.Graphics;
 import flash.display.Sprite;
 import flash.events.Event;
 import flash.geom.Point;
 import vgdev.dodge.mechanics.TimeScale;
 /**
  * TEMPORARY FILE
  */
 public class StarTemp extends Sprite
 {
  private var d:Number // distance from center
  private var r:Number // angle of travel in radians
  private var stageCenter:Point;
  private var speed:Number; // applies a random speed to stars so they do not all travel at the same speed.
  private var acceleration:Number = 1.025
  public function StarTemp()
  {
   this.alpha = 0;
   init();
   addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
  }
  
  private function onAddedToStage(e:Event):void 
  {
   removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
   addEventListener(Event.ENTER_FRAME, update);
   stageCenter = new Point(0, 0);
  }
  
  private function update(e:Event):void 
  {
   d -= (d - (d * (acceleration + (speed*0.25)))) * TimeScale.s_scale; 
   alpha= d/500; // fades in the stars as they get closer.
   x = stageCenter.x + Math.cos(r) * d/2;
   y = stageCenter.y + Math.sin(r) * d / 2;
   // loop star when it goes off the stage.
   if (Math.abs(x) > 800 || Math.abs(y) > 600) {
    init()
   }
  }  
  
  private function init():void
  {
   // init values;
   r = Math.random() * 6;
   d = Math.random() * 150;
   speed = Math.random() * 0.0510;
   // draw circle
   this.graphics.clear();
   this.graphics.beginFill(0xFFFFFF);
   this.graphics.drawCircle(0, 0, speed*20);   
  }
 }

}