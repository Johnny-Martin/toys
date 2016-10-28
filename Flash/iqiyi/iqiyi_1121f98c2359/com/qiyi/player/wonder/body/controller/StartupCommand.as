package com.qiyi.player.wonder.body.controller
{
    import com.qiyi.player.wonder.body.controller.initcommand.*;
    import org.puremvc.as3.patterns.command.*;

    public class StartupCommand extends MacroCommand
    {

        public function StartupCommand()
        {
            return;
        }// end function

        override protected function initializeMacroCommand() : void
        {
            super.initializeMacroCommand();
            addSubCommand(PrepModelCommand);
            addSubCommand(PrepViewCommand);
            addSubCommand(InitLoginStateCommand);
            return;
        }// end function

    }
}
