package com.ramshteks.keyboard {
	/**
	 * @author Shirobok Pavel (ramshteks@gmail.com)
	 */
	public class KeyMap {
		private var _globalKeyMap:Array;
		private var _state:String;

		public function KeyMap() {
			_globalKeyMap = [];
			_state = generateRandomString();
		}

		public function get state():String{
			return _state;
		}

		public function handleKeyDown(downedKeyCode:uint):void {
			updateStateIfNecessery(downedKeyCode, true);
			_globalKeyMap[downedKeyCode] = true;
		}

		private function updateStateIfNecessery(downedKeyCode:uint, neededFlag:Boolean):void {
			if (!keyIsEqual(downedKeyCode, neededFlag)) {
				_state = generateRandomString();
			}
		}

		public function handleKeyUp(uppedKeyCode:uint):void {
			updateStateIfNecessery(uppedKeyCode, false);
			_globalKeyMap[uppedKeyCode] = false;
		}

		public function isDown(...keys:Array):Boolean {
			for each(var key:int in keys) {
				if (!keyIsEqual(key, true)) return false;
			}
			return true;
		}

		public function isUp(...keys:Array):Boolean {
			for each(var key:int in keys) {
				if (!keyIsEqual(key, false)) return false;
			}
			return true;
		}

		private function keyIsEqual(key:int, value:Boolean):Boolean {
			return _globalKeyMap[key] == value;
		}

		private static function generateRandomString():String{
			var string:String = "";
			const alphabet:String = "qwertyuiopasdfghjklzxcvbnm";
			const HASH_SIZE:int = 10;

			for(var i:int = 0; i < HASH_SIZE; i++){
				string += alphabet.charAt(int(alphabet.length*Math.random()));
			}

			return string;
		}

	}
}