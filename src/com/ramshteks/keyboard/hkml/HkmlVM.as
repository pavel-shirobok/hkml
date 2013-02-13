package com.ramshteks.keyboard.hkml {
	import flash.utils.getTimer;

	/**
	 * ...
	 * @author Pavel Shirobok (ramshteks@gmail.com)
	 */
	public class HkmlVM {

		private var _currentKeysNodeIndex:int = 0;
		private var _keysNodes:Vector.<KeysNode>;
		private var _lastCompleteTime:int = 0;

		public function HkmlVM(keysNodes:Vector.<KeysNode>) {
			_keysNodes = keysNodes;
			reset();
			updateLastCompleteTime();
		}

		public function testKey(pressedKeyCode:int):Boolean{
			if(_keysNodes.length != 1){
				if(testCurrentKeysNode(pressedKeyCode)){
					if(currentKeysNode.finished){
						updateLastCompleteTime();
						_currentKeysNodeIndex++;
					}
					return true;
				}else{
					reset();
				}
			}else{
				if(testCurrentKeysNode(pressedKeyCode)){
					return true;
				}else{
					reset();
					return false;
				}
			}

			return false;
		}

		public function get isFinished():Boolean{
			return _keysNodes[_keysNodes.length-1].finished;
		}

		public function reset():void{
			_currentKeysNodeIndex = 0;
			for each(var keysNode:KeysNode in _keysNodes){
				keysNode.reset();
			}
		}

		private function testCurrentKeysNode(keyCode:int):Boolean{
			return currentKeysNode.testKeys(keyCode, _lastCompleteTime)
		}

		private function updateLastCompleteTime():void{
			_lastCompleteTime = getTimer();
		}

		private function get currentKeysNode():KeysNode{
			return _keysNodes[_currentKeysNodeIndex];
		}


		public function toString():String {
			return "HkmlVM{" + String(_keysNodes) + "}";
		}
	}
}
