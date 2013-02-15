package com.ramshteks.keyboard.hkml {
	import com.ramshteks.keyboard.KeyMap;
	import com.ramshteks.keyboard.hkml.HkmlVM;

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

		private var _virtualMachines:Array;
		private var _lastKeyMapState:String;

		public function HkmlKeyboardController(keyboardEventsDispatcher:IEventDispatcher) {
			_keyboardEventsDispatcher = keyboardEventsDispatcher;

			_virtualMachines = [];

			_keyMap = new KeyMap();
			_lastKeyMapState = _keyMap.state;

			_keyboardEventsDispatcher.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_keyboardEventsDispatcher.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		private function onKeyUp(e:KeyboardEvent):void {
			//_keyMap.handleKeyUp(e.keyCode);
		}

		private function onKeyDown(e:KeyboardEvent):void {
			_keyMap.handleKeyDown(e.keyCode);

			if(_keyMap.state!=_lastKeyMapState){

				for each(var vm:HkmlVM in _virtualMachines){
					if(vm.testKey(e.keyCode)){
						if(vm.isFinished){
							vm.reset();
							dispatchEvent(new HkmlEvent(vm.sourceMarkup, true));
						}
					}else{
						vm.reset();
						dispatchEvent(new HkmlEvent(vm.sourceMarkup, false));
					}
				}

				_lastKeyMapState = _keyMap.state;
			}
		}

		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);

			var vm:HkmlVM = HkmlCompiler.compile(type);
			_virtualMachines[type] = vm;
		}

		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			super.removeEventListener(type, listener, useCapture);
			var vm:HkmlVM = _virtualMachines[type];
			vm.destroy();
			delete _virtualMachines[type];
		}

		override public function hasEventListener(type:String):Boolean {
			return super.hasEventListener(type);
		}
	}
}
