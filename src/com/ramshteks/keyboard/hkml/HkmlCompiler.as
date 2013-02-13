package com.ramshteks.keyboard.hkml
{
    import flash.ui.Keyboard;

    /**
	 * Class for compiling hkml(Hot Key Markup Language) notation
	 * @author Pavel Shirobok
	 */
	public class HkmlCompiler
	{

        private static const TOKEN_KEY:String = "str";
		private static const TOKEN_OR:String = "or";
		private static const TOKEN_SEQ:String = "seq";

		private static const SEQ:String = ">";
		private static const COMB:String = "+";
		private static const SPACE:String = " ";
		private static const TAB:String = "\t";

		public static function compile(combination:String):HkmlVM {
            var tokens:Array = tokenize(combination);
			var keysNodes:Vector.<KeysNode> = buildKeysNodes(tokens);
			return new HkmlVM(keysNodes);
		}

		private static function tokenize(combination:String):Array {
			var c:String;
			var buffer:String = "";
			var chunks:Array = [];

			for (var i:int = 0; i < combination.length; i++) {
				c = combination.charAt(i);

				switch (c) {
					case SEQ:
                        c = combination.charAt(++i);
                        buffer = "";
                        while(c != SEQ){
                            if(i == combination.length){
                                throw new HkmlBuildError("Unexpected end of line. Expected '>'", (i-1));
                            }
                            buffer += c;
                            c = combination.charAt(++i);
                        }

                        if(buffer.length!=0){
                            if(isNaN(parseInt(buffer)) || parseInt(buffer)<=0){
                                throw new HkmlBuildError("Wrong delay value '"+buffer+"'", i-buffer.length-1);
                            }
                        }else{
                            buffer = "-1";
                        }
						chunks.push(createToken(TOKEN_SEQ, buffer, i - buffer.length - 1));
					break;
					case COMB:
						chunks.push(createToken(TOKEN_OR, c, i));
						break;
                    case TAB:
                    case SPACE:
                        break;
					default:
						buffer = "";
						do {
							buffer += c;
							c = combination.charAt(++i);
						} while ((c != SEQ && c != COMB && c!=SPACE && c!=TAB) && i != combination.length);
						chunks.push(createToken(TOKEN_KEY, buffer, i));
						i--;
						break;
				}

			}
			return chunks;
		}

		private static function createToken(name:String, value:*, index:int):Object {
			return {
						name:name,
						value:value,
						index:index
						/*,toString:function():String{return name+":'"+value+"'";}*/};
		}

		private static function buildKeysNodes(tokens:Array):Vector.<KeysNode> {
			var keysNodes:Vector.<KeysNode> = new Vector.<KeysNode>();

			var token:Object;
			var currentType:String;
            var currentValue:String;
            var currentIndex:int;
            var buffer:Array = [];
            var delay:int = 0;

            var lastOperation:String = null;
            for(var i:int = 0; i<tokens.length; i++){
				token = tokens[i];
                currentType = token.name;
                currentValue = token.value;
                currentIndex = token.index;

                //combination can't begins with operation
                if(i ==0 && (currentType==TOKEN_OR || currentType==TOKEN_SEQ)){
                    throw new HkmlBuildError("Line must be started by key", currentIndex);
                }

                //combination can't ends with operation
                if(i == tokens.length - 1 && (currentType==TOKEN_OR || currentType==TOKEN_SEQ)){
                    throw new HkmlBuildError("Line must be ended by key", currentIndex);
                }

                switch(currentType){
                    case TOKEN_KEY:
                        buffer.push(currentValue);
                        break;

                    default :
                        var parsedDelay:Number = parseFloat(currentValue);
                        var correctDelayed:Boolean = (-1!= parsedDelay && !isNaN(parsedDelay));
                        if(lastOperation==null){
                            //first turn
                            if(correctDelayed){
                                keysNodes.push(createKeysNode(buffer, currentType, delay, token.index));
                                buffer = [];
                                delay = parsedDelay;
                            }else{
                                lastOperation = currentType;
                            }
                        } else {
                            //other turn
                            if(lastOperation!=currentType || correctDelayed){
								if(currentType == TOKEN_OR && buffer.length>1){
									var lastToken:String = buffer.pop();
									keysNodes.push(createKeysNode(buffer, lastOperation, delay, token.index));
									buffer = [lastToken];
								}else{
									keysNodes.push(createKeysNode(buffer, lastOperation, delay, token.index));
									buffer = [];
								}

                                delay = parsedDelay;
                                lastOperation = correctDelayed?null:currentType;
                            }else{
                                lastOperation = currentType;
                            }
                        }
                        break;
                }

			}

            if(buffer.length!=0){
                keysNodes.push(createKeysNode(buffer, lastOperation, delay, token.index));
            }

            return keysNodes;
        }

        private static function createKeysNode(buffer:Array, type:String, delay:Number, index:int):KeysNode {
            var keys:Vector.<int> = new Vector.<int>(buffer.length, true);
			var keyStringAlias:String;

			for (var i:int = 0; i < buffer.length; i++) {
				keyStringAlias = buffer[i];

				if(Keyboard[keyStringAlias] == undefined){
                    throw new HkmlBuildError("Unknown key alias '"+keyStringAlias+"'", index);
                }

                keys[i] = Keyboard[keyStringAlias];
            }

            return new KeysNode(keys, delay, type==TOKEN_OR);
        }
	}

}