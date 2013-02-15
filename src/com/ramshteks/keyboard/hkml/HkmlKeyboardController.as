package com.ramshteks.keyboard.hkml {
	import com.ramshteks.keyboard.KeyMap;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;

	/**
	 * ...
	 * @author Pavel Shirobok (ramshteks@gmail.com)
	 */
	public class HkmlKeyboardController extends EventDispatcher {
		private var _keyboardEventsDispatcher:IEventDispatcher;
		private var _keyMap:KeyMap;

		public function HkmlKeyboardController(keyboardEventsDispatcher:IEventDispatcher) {
			_keyboardEventsDispatcher = keyboardEventsDispatcher;
			_keyMap = new KeyMap();

			_keyboardEventsDispatcher.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_keyboardEventsDispatcher.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		private function onKeyUp(e:KeyboardEvent):void {
			_keyMap.handleKeyUp(e.keyCode);
		}

		private function onKeyDown(e:KeyboardEvent):void {
			_keyMap.handleKeyDown(e.keyCode);
		}


	}
}
