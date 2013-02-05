package com.ramshteks.keyboard.hkml {
	/**
	 * ...
	 * @author ramshteks
	 */
	public class HkmlBuildError extends Error {
		private var _index:int;
		public function HkmlBuildError(message:String, index:int) {
			super(message);
			_index = index;
		}

		public function get index():int {
			return _index;
		}
	}
}
