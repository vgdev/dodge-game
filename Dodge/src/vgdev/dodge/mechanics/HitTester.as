// credit to Doug McCune
// http://dougmccune.com/blog/2007/02/03/using-hittestpoint-or-hittest-on-transparent-png-images/

package vgdev.dodge.mechanics 
{
	import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.geom.Matrix;
    import flash.geom.Point;
        
	
    public class HitTester
    {
        public static function realHitTest(object:DisplayObject, point:Point):Boolean {
            /* If we're already dealing with a BitmapData object then we just use the hitTest
             * method of that BitmapData.
             */
            if(object is BitmapData) {
                return (object as BitmapData).hitTest(new Point(0,0), 0, object.globalToLocal(point));
            }
            else {
                /* First we check if the hitTestPoint method returns false. If it does, that
                 * means that we definitely do not have a hit, so we return false. But if this
                 * returns true, we still don't know 100% that we have a hit because it might
                 * be a transparent part of the image. 
                 */
                if (!object.hitTestPoint(point.x, point.y, true)) {
                    return false;
                }
                else {
                    /* So now we make a new BitmapData object and draw the pixels of our object
                     * in there. Then we use the hitTest method of that BitmapData object to
                     * really find out of we have a hit or not.
                     */
                    var bmapData:BitmapData = new BitmapData(object.width, object.height, true, 0x00000000);
                    bmapData.draw(object, new Matrix());
					
					var coordTransform:Matrix = new Matrix();

					coordTransform.rotate(object.rotation);
					coordTransform.translate(object.x, object.y);
					coordTransform.scale(object.scaleX, object.scaleY);

					point = coordTransform.transformPoint(point);
                    var returnVal:Boolean = bmapData.hitTest(new Point(0, 0), 255, object.globalToLocal(point));
                    
                    bmapData.dispose();
                    
					//trace("[HT] hitTest = " + returnVal);
					
                    return returnVal;
                }
            }
        }
    }

}