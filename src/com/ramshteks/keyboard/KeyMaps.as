package com.ramshteks.keyboard
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author 
	 */
	public class KeyMaps extends EventDispatcher 
	{
		private var _globalKeyMap:Array = [];
		
		public function KeyMaps() 
		{
			super();
		}
		
		public function handleKeyDown(e:KeyboardEvent):void {
			_globalKeyMap[e.keyCode] = true;
		}
		
		public function handleKeyUp(e:KeyboardEvent):void {
			_globalKeyMap[e.keyCode] = false;
		}
		
		public function isDown(...keys:Array):Boolean 
		{
			for each(var key:int in keys){
				if (!keyIsEqual(key, true)) return false;
			}
			return true;
		}
		
		public function isUp(...keys:Array):Boolean 
		{
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