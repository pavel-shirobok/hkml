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

	public class KeysNode {
		public static const NO_TEST_TIME:int = 0;

		private var _lastSuccessTestTime:int = NO_TEST_TIME;
		private var _keys:Vector.<int>;
		private var _keysStatus:Vector.<Boolean>;
		private var _indexOfKeyToTest:int = 0;
		private var _delay:int;
		private var _orMode:Boolean;

		public function KeysNode(keys:Vector.<int>, delay:int = 0, orMode:Boolean = false) {

			if(existRepeatingKeyCodes(keys)){
				throw new ArgumentError("Keys must be unique in one instance of KeysNode");
			}

			_keys = keys;
			_delay = delay;
			_orMode = orMode;

			if (_orMode) {
				_keysStatus = new Vector.<Boolean>(keys.length, true);
				resetKeyStatuses();
			}
		}

		private function existRepeatingKeyCodes(keys:Vector.<int>):Boolean {

			for (var i:int = 0; i < keys.length - 1; i++) {
				if(keys.indexOf(keys[i], i + 1) != -1)return true;
			}

			return false;
		}

		public function checkPressedKey(keyCode:int, timeOfCompletePrevKeyNode:int):Boolean {
			var timer:int = getTimer();
			if (_delay != 0) {
				if (timer - timeOfCompletePrevKeyNode > _delay) {
					reset();
					return false;
				}
			}

			var keyFromQueue:int;

			if (_orMode) {
				var index:int = _keys.indexOf(keyCode);
				if (index == -1) {
					reset();
					return false;
				}

				var alreadyPressed:Boolean = _keysStatus[index];
				if (alreadyPressed) {
					reset();
					return false;
				}
				_keysStatus[index] = true;

			} else {
				keyFromQueue = _keys[_indexOfKeyToTest];

				if (keyCode != keyFromQueue) {
					reset();
					return false;
				}

				_indexOfKeyToTest++;
			}

			_lastSuccessTestTime = timer;
			return true;
		}

		public function reset():void {
			_lastSuccessTestTime = NO_TEST_TIME;

			if (_orMode) {
				resetKeyStatuses();
			} else {
				_indexOfKeyToTest = 0;
			}
		}

		private function resetKeyStatuses():void {
			for (var i:int = 0; i < _keysStatus.length; i++) {
				_keysStatus[i] = false;
			}
		}

		public function get finished():Boolean {
			if (_orMode) {
				for each(var keyStatus:Boolean in _keysStatus) {
					if (!keyStatus)return false;
				}
				return true;
			}
			return _keys.length == _indexOfKeyToTest;
		}

		public function toString():String {
			return "(" + (_delay > 0 ? (_delay + ":") : "") + _keys.join(_orMode ? "+" : ">>") + ")";
		}

		public function destroy():void {
			_keys = null;
			_keysStatus = null;
		}
	}
}
