package com.ramshteks.keyboard.hkml {
	import flash.utils.getTimer;

	/**
	 * ...
	 * @author ramshteks
	 */
	public class KeysNode {
		public static const NO_TEST_TIME:int = -1;
		private var _lastSuccessTestTime:int = NO_TEST_TIME;

		private var _keys:Vector.<int>;
		private var _keysStatus:Vector.<Boolean>;
		private var _indexOfKeyToTest:int = 0;
		private var _delay:int;
		private var _orMode:Boolean;

		public function KeysNode(keys:Vector.<int>, delay:int = -1, orMode:Boolean = false) {
			_keys = keys;
			_delay = delay;
			_orMode = orMode;

			//TODO: проверка на повторяющиеся ключи
			if(_orMode){
				_keysStatus = new Vector.<Boolean>(keys.length, true);
				resetKeyStatuses();
			}
		}

		public function testKeys(keyCode:int, timeOfCompletePrevKeyNode:int):Boolean {
			var timer:int = getTimer();
			if(_delay != -1){
				if(timer - timeOfCompletePrevKeyNode > _delay){
					reset();
					return false;
				}
			}

			var keyFromQueue:int;

			if(_orMode){
				var index:int = _keys.indexOf(keyCode);
				if(index == -1){
					reset();
					return false;
				}

				var alreadyPressed:Boolean = _keysStatus[index];
				if(alreadyPressed){
					reset();
					return false;
				}
				_keysStatus[index] = true;

			}else{
				keyFromQueue = _keys[_indexOfKeyToTest];

				if(keyCode != keyFromQueue){
					reset();
					return false;
				}

				_indexOfKeyToTest++;
			}

			_lastSuccessTestTime = timer;
			return true;
		}

		public function reset():void{
			_lastSuccessTestTime = NO_TEST_TIME;

			if(_orMode){
				resetKeyStatuses();
			}else{
				_indexOfKeyToTest = 0;
			}
		}

		private function resetKeyStatuses():void{
			for(var i:int = 0; i<_keysStatus.length; i++){
				_keysStatus[i] = false;
			}
		}

		public function destroy():void{
			_keys = null;
			_keysStatus = null;
		}

		public function get finished():Boolean{
			if(_orMode){
				for each(var keyStatus:Boolean in _keysStatus){
					if(!keyStatus)return false;
				}
				return true;
			}
			return _keys.length == _indexOfKeyToTest;
		}

		public function get lastSuccessfulTestTime():int{
			return _lastSuccessTestTime;
		}


		public function toString():String {
			return (_delay != -1 ? ("(" + _delay + ")") : "") + _keys.join(_orMode?"+":">>");
		}
	}
}
