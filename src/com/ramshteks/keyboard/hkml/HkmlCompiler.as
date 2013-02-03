package com.ramshteks.keyboard.hkml
{
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

		public static function compile(combination:String):Vector.<KeysNode> {

			var chunks:Array = tokenize(combination);
			var keysNodes:Vector.<KeysNode> = buildKeysNodes(chunks);
			trace(chunks);
			trace(keysNodes);
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
						chunks.push(createToken(TOKEN_SEQ, c, i));
					break;
					case COMB:
						chunks.push(createToken(TOKEN_OR, c, i));
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
			//noinspection JSUnusedGlobalSymbols
			return {name:name, value:value, index:index, toString:function():String{return name+"("+index+"):["+value+"]";}};
		}

		private static function buildKeysNodes(tokens:Array):Vector.<KeysNode> {
			var keysNodes:Vector.<KeysNode> = new Vector.<KeysNode>();

			var token:Object;
			for(var i:int = 0; i<tokens.length; i++){
				token = tokens[i];

			}

			return keysNodes;
		}
	}

}