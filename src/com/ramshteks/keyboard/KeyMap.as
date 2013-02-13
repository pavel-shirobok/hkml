package com.ramshteks.keyboard {
	/**
	 * @author Shirobok Pavel (ramshteks@gmail.com)
	 */
	public class KeyMap {
		private var _globalKeyMap:Array = [];

		public function KeyMap() {}

		public function handleKeyDown(downedKeyCode:uint):void {
			_globalKeyMap[downedKeyCode] = true;
		}

		public function handleKeyUp(uppedKeyCode:uint):void {
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

	}
}