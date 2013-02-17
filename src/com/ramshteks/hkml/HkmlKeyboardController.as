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

package com.ramshteks.hkml {

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;

	public class HkmlKeyboardController extends EventDispatcher {

		private var _keyboardEventsDispatcher:IEventDispatcher;
		private var _virtualMachines:Array;

		public function HkmlKeyboardController(keyboardEventsDispatcher:IEventDispatcher) {
			_keyboardEventsDispatcher = keyboardEventsDispatcher;
			_virtualMachines = [];
			startKeyboardEventListening();
		}

		private function startKeyboardEventListening():void {
			_keyboardEventsDispatcher.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		private function onKeyDown(e:KeyboardEvent):void {
			for each(var vm:HkmlVM in _virtualMachines) {
				if (vm.checkPressedKey(e.keyCode)) {
					if (vm.finished) {
						vm.reset();
						dispatchEvent(new HkmlEvent(vm.markup, true));
					}
				} else {
					vm.reset();
					dispatchEvent(new HkmlEvent(vm.markup, false));
				}
			}
		}

		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {

			if(_virtualMachines[type]!=null){
				throw new ArgumentError("Handler for '"+type+"' already exist");
			}

			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			_virtualMachines[type] = HkmlCompiler.compile(type);
		}

		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {

			if(_virtualMachines[type] == null){
				throw new ArgumentError("Handler for '"+type+"' does not exist")
			}

			super.removeEventListener(type, listener, useCapture);
			var vm:HkmlVM = _virtualMachines[type];
			vm.destroy();
			delete _virtualMachines[type];
		}

		public function destroy():void {
			_keyboardEventsDispatcher.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_keyboardEventsDispatcher = null;
		}
	}
}
