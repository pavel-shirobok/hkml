package com.ramshteks.keyboard.hkml {
	import flash.events.Event;

	/**
	 * ...
	 * @author Pavel Shirobok (ramshteks@gmail.com)
	 */
	public class HkmlEvent extends Event {
		private var _status:Boolean;

		public function HkmlEvent(type:String, status:Boolean) {
			super(type, bubbles, cancelable);
			_status = status;
		}

		public function get status():Boolean {
			return _status;
		}

		override public function clone():Event {
			return new HkmlEvent(type, status);
		}
	}
}
