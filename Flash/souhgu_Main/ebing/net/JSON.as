package ebing.net
{

    public class JSON extends Object
    {
        public var at:Number = 0;
        public var ch:String = " ";
        public var text:String;

        public function JSON()
        {
            return;
        }// end function

        public function parse(param1:String) : Object
        {
            this.text = param1;
            return this.value();
        }// end function

        public function value()
        {
            this.white();
            switch(this.ch)
            {
                case "{":
                {
                    return this.object();
                }
                case "[":
                {
                    return this.array();
                }
                case "\"":
                {
                    return this.string();
                }
                case "-":
                {
                    return this.number();
                }
                default:
                {
                    return this.ch >= "0" && this.ch <= "9" ? (this.number()) : (this.word());
                    break;
                }
            }
        }// end function

        public function error(param1) : void
        {
            throw {name:"JSONError", message:param1, at:(this.at - 1), text:this.text};
        }// end function

        public function next()
        {
            this.ch = this.text.charAt(this.at);
            (this.at + 1);
            return this.ch;
        }// end function

        public function white()
        {
            while (this.ch)
            {
                
                if (this.ch <= " ")
                {
                    this.next();
                    continue;
                }
                if (this.ch == "/")
                {
                    switch(this.next())
                    {
                        case "/":
                        {
                            while (this.next() && this.ch != "\n" && this.ch != "\r")
                            {
                                
                            }
                            break;
                        }
                        case "*":
                        {
                            this.next();
                            while (true)
                            {
                                
                                if (this.ch)
                                {
                                    if (this.ch == "*")
                                    {
                                        if (this.next() == "/")
                                        {
                                            this.next();
                                            break;
                                        }
                                    }
                                    else
                                    {
                                        this.next();
                                    }
                                    continue;
                                }
                                this.error("Unterminated comment");
                            }
                            break;
                        }
                        default:
                        {
                            this.error("Syntax error");
                            break;
                        }
                    }
                    continue;
                }
                break;
            }
            return;
        }// end function

        public function string()
        {
            var _loc_1:* = undefined;
            var _loc_3:* = undefined;
            var _loc_4:* = undefined;
            var _loc_2:* = "";
            var _loc_5:Boolean = false;
            if (this.ch == "\"")
            {
                while (this.next())
                {
                    
                    if (this.ch == "\"")
                    {
                        this.next();
                        return _loc_2;
                    }
                    if (this.ch == "\\")
                    {
                        switch(this.next())
                        {
                            case "b":
                            {
                                _loc_2 = _loc_2 + "\b";
                                break;
                            }
                            case "f":
                            {
                                _loc_2 = _loc_2 + "\f";
                                break;
                            }
                            case "n":
                            {
                                _loc_2 = _loc_2 + "\n";
                                break;
                            }
                            case "r":
                            {
                                _loc_2 = _loc_2 + "\r";
                                break;
                            }
                            case "t":
                            {
                                _loc_2 = _loc_2 + "\t";
                                break;
                            }
                            case "u":
                            {
                                _loc_4 = 0;
                                _loc_1 = 0;
                                while (_loc_1 < 4)
                                {
                                    
                                    _loc_3 = parseInt(this.next(), 16);
                                    if (!isFinite(_loc_3))
                                    {
                                        _loc_5 = true;
                                        break;
                                    }
                                    _loc_4 = _loc_4 * 16 + _loc_3;
                                    _loc_1 = _loc_1 + 1;
                                }
                                if (_loc_5)
                                {
                                    _loc_5 = false;
                                    break;
                                }
                                _loc_2 = _loc_2 + String.fromCharCode(_loc_4);
                                break;
                            }
                            default:
                            {
                                _loc_2 = _loc_2 + this.ch;
                                break;
                            }
                        }
                        continue;
                    }
                    _loc_2 = _loc_2 + this.ch;
                }
            }
            this.error("Bad string");
            return;
        }// end function

        public function array()
        {
            var _loc_1:Array = [];
            if (this.ch == "[")
            {
                this.next();
                this.white();
                if (this.ch == "]")
                {
                    this.next();
                    return _loc_1;
                }
                while (this.ch)
                {
                    
                    _loc_1.push(this.value());
                    this.white();
                    if (this.ch == "]")
                    {
                        this.next();
                        return _loc_1;
                    }
                    if (this.ch != ",")
                    {
                        break;
                    }
                    this.next();
                    this.white();
                }
            }
            this.error("Bad array");
            return;
        }// end function

        public function object()
        {
            var _loc_1:Object = null;
            var _loc_2:Object = {};
            if (this.ch == "{")
            {
                this.next();
                this.white();
                if (this.ch == "}")
                {
                    this.next();
                    return _loc_2;
                }
                while (this.ch)
                {
                    
                    _loc_1 = this.string();
                    this.white();
                    if (this.ch != ":")
                    {
                        break;
                    }
                    this.next();
                    _loc_2[_loc_1] = this.value();
                    this.white();
                    if (this.ch == "}")
                    {
                        this.next();
                        return _loc_2;
                    }
                    if (this.ch != ",")
                    {
                        break;
                    }
                    this.next();
                    this.white();
                }
            }
            this.error("Bad object");
            return;
        }// end function

        public function number()
        {
            var _loc_2:* = undefined;
            var _loc_1:* = "";
            if (this.ch == "-")
            {
                _loc_1 = "-";
                this.next();
            }
            while (this.ch >= "0" && this.ch <= "9")
            {
                
                _loc_1 = _loc_1 + this.ch;
                this.next();
            }
            if (this.ch == ".")
            {
                _loc_1 = _loc_1 + ".";
                while (this.next() && this.ch >= "0" && this.ch <= "9")
                {
                    
                    _loc_1 = _loc_1 + this.ch;
                }
            }
            _loc_2 = _loc_1;
            if (!isFinite(_loc_2))
            {
                this.error("Bad number");
            }
            else
            {
                return _loc_2;
            }
            return;
        }// end function

        public function word()
        {
            switch(this.ch)
            {
                case "t":
                {
                    if (this.next() == "r" && this.next() == "u" && this.next() == "e")
                    {
                        this.next();
                        return true;
                    }
                    break;
                }
                case "f":
                {
                    if (this.next() == "a" && this.next() == "l" && this.next() == "s" && this.next() == "e")
                    {
                        this.next();
                        return false;
                    }
                    break;
                }
                case "n":
                {
                    if (this.next() == "u" && this.next() == "l" && this.next() == "l")
                    {
                        this.next();
                        return null;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.error("Syntax error");
            return;
        }// end function

    }
}
