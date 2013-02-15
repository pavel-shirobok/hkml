/*
 * Copyright (c) 2013, Shirobok Pavel (ramshteks@gmail.com)
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the <organization> nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package com.ramshteks.keyboard.hkml {
	import flash.utils.getTimer;

	public class HkmlVM {

		private var _currentKeysNodeIndex:int = 0;
		private var _lastCompleteTime:int = 0;
		private var _keysNodes:Vector.<KeysNode>;
		private var _markup:String;

		public function HkmlVM(markup:String, keysNodes:Vector.<KeysNode>) {
			_markup = markup;

			if(keysNodes.length==0){
				throw new ArgumentError("Keys nodes must be more, than one");
			}

			_keysNodes = keysNodes;
			reset();
			updateLastCompleteTime();
		}

		public function checkPressedKey(pressedKeyCode:int):Boolean {
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

		public function get finished():Boolean {
			return _keysNodes[_keysNodes.length - 1].finished;
		}

		public function reset():void {
			_currentKeysNodeIndex = 0;
			for each(var keysNode:KeysNode in _keysNodes) {
				keysNode.reset();
			}
		}

		private function testCurrentKeysNode(keyCode:int):Boolean {
			return currentKeysNode.checkPressedKey(keyCode, _lastCompleteTime)
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

		public function get markup():String {
			return _markup;
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
