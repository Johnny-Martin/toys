package CPlayer.CNetStream.Cipher
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.system.*;

    public class AlcWorkerSprite extends Sprite
    {

        public function AlcWorkerSprite()
        {
            run();
            return;
        }// end function

        public function run() : void
        {
            var _loc_1:int = 0;
            var _loc_2:Number = undefined;
            this.trace("AlcWorkerSprite::run");
            try
            {
                _loc_1 = workerClass["current"].getSharedProperty("flascc.thread_entry");
                _loc_2 = workerClass["current"].getSharedProperty("flascc.thread_args").readObject();
                CModule.prepForThreadedExec();
                CModule.activeConsole = this;
                if (!CModule.rootSprite)
                {
                    CModule.rootSprite = this;
                }
                CModule.callI(_loc_1, _loc_2);
            }
            catch (e:GoingAsync)
            {
                ;
            }
            catch (e:)
            {
                if (e is Exit)
                {
                    System.exit(e.code);
                }
                else
                {
                    this.trace("Warning: Worker threw exception: " + threadId + " - " + e + "\n" + e.getStackTrace());
                }
            }
            return;
        }// end function

    }
}
