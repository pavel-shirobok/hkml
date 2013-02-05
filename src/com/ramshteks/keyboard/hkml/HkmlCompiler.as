package com.ramshteks.keyboard.hkml
{
	/**
	 * Class for compiling hkml(Hot Key Markup Language) notation
	 * @author Pavel Shirobok
	 */
	public class HkmlCompiler
	{
        //fake token, only for building
		private static const TOKEN_BEGIN:String = "begin";
        private static const TOKEN_KEY:String = "str";
		private static const TOKEN_OR:String = "or";
		private static const TOKEN_SEQ:String = "seq";

        private static const OPERATOR:String = "operator";
        private static const KEY:String = "value";

		private static const SEQ:String = ">";
		private static const COMB:String = "+";
		private static const SPACE:String = " ";
		private static const TAB:String = "\t";

		public static function compile(combination:String):Vector.<KeysNode> {
			trace(combination);
            var tokens:Array = tokenize(combination);
            trace(tokens);
			var keysNodes:Vector.<KeysNode> = buildKeysNodes(tokens);
			return keysNodes;
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
			return {name:name, value:value, index:index, toString:function():String{return name+":'"+value+"'";}};
		}

		private static function buildKeysNodes(tokens:Array):Vector.<KeysNode> {
			var keysNodes:Vector.<KeysNode> = new Vector.<KeysNode>();

			var token:Object;
			var currentType:String;
            var currentValue:String;
            var currentIndex:int;

            var previousToken:Object;
            var delay:int = 0;
            var buffer:Array = [];
            var commitIsNeeded:Boolean;
            var currentSequenceType:String;
            var expectedTokenType:String = KEY;
            for(var i:int = 0; i<tokens.length; i++){
				token = tokens[i];

                previousToken = i == 0?null:tokens[i-1];

                currentType = token.name;
                currentValue = token.value;
                currentIndex = token.index;

                //combination can't begins with operation
                if(i ==0 && (currentType==TOKEN_OR || currentType==TOKEN_SEQ)){
                    throw new HkmlBuildError("Unexpected token '"+currentValue+"' with type '"+currentType+"'", currentIndex);
                }

                if(i == tokens.length - 1 && (currentType==TOKEN_OR || currentType==TOKEN_SEQ)){
                    throw new HkmlBuildError("Line must be ended by key", currentIndex);
                }

                //unexpected token type
                if(expectedTokenType == OPERATOR && (currentType==TOKEN_KEY)){
                    throw new HkmlBuildError("Expected operator token", currentIndex);
                }

                if(expectedTokenType == KEY && (currentType!=TOKEN_KEY)){
                    throw new HkmlBuildError("Expected key token", currentIndex);
                }

                switch(currentType){
                    case TOKEN_OR:
                    case TOKEN_SEQ:
                        if(currentSequenceType==null){
                            delay = 0;
                            buffer = [];
                            currentSequenceType = currentType;
                        }else{
                            if(currentSequenceType != currentType){
                                commitIsNeeded = true;
                            }else{

                            }
                        }


                        expectedTokenType = KEY;
                        break;

                    case TOKEN_KEY:
                        buffer.push(currentValue);
                        if(i == tokens.length-1){
                            commitIsNeeded = true;
                        }
                        expectedTokenType = OPERATOR;
                        break;
                }
                if(commitIsNeeded){
                    commitIsNeeded = false;
                    keysNodes.push(createKeysNode(buffer, currentSequenceType, delay));
                    delay = parseInt(currentValue);
                }
			}

            return keysNodes;
        }

        private static function createKeysNode(buffer:Array, type:String, value:Number):KeysNode {
            return null;
        }
	}

}