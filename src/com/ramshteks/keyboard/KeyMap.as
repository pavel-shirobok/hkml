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

package com.ramshteks.keyboard {

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