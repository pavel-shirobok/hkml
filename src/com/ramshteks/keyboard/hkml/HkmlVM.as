package com.ramshteks.keyboard.hkml {
	import flash.utils.getTimer;

	/**
	 * ...
	 * @author Pavel Shirobok (ramshteks@gmail.com)
	 */
	public class HkmlVM {

		private var _currentKeysNodeIndex:int = 0;
		private var _lastCompleteTime:int = 0;
		private var _keysNodes:Vector.<KeysNode>;
		private var _sourceMarkup:String;

		public function HkmlVM(sourceMarkup:String, keysNodes:Vector.<KeysNode>) {
			_sourceMarkup = sourceMarkup;

			if(_keysNodes.length==0){
				throw new ArgumentError("Keys nodes must be more, than one");
			}

			_keysNodes = keysNodes;
			reset();
			updateLastCompleteTime();
		}

		public function testKey(pressedKeyCode:int):Boolean {
			var lastNodeTestResult:Boolean;
			if (lastNodeTestResult = testCurrentKeysNode(pressedKeyCode)) {
				if (moreThanOneNode && currentKeysNode.finished) {
					updateLastCompleteTime();
					_currentKeysNodeIndex++;
				}
			} else {
				reset();
			}

			return lastNodeTestResult;
		}

		public function get isFinished():Boolean {
			return _keysNodes[_keysNodes.length - 1].finished;
		}

		public function reset():void {
			_currentKeysNodeIndex = 0;
			for each(var keysNode:KeysNode in _keysNodes) {
				keysNode.reset();
			}
		}

		private function testCurrentKeysNode(keyCode:int):Boolean {
			return currentKeysNode.testKeys(keyCode, _lastCompleteTime)
		}

		private function updateLastCompleteTime():void {
			_lastCompleteTime = getTimer();
		}

		private function get currentKeysNode():KeysNode {
			return _keysNodes[_currentKeysNodeIndex];
		}

		private function get moreThanOneNode():Boolean {
			return _keysNodes.length > 1;
		}

		public function get sourceMarkup():String {
			return _sourceMarkup;
		}

		public function toString():String {
			return "HkmlVM{" + String(_keysNodes) + "}";
		}

		public function destroy():void {
			for each(var keysNode:KeysNode in _keysNodes){
				keysNode.destroy();
			}
			_keysNodes = null;
		}
	}
}
