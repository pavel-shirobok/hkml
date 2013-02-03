package {
	import com.ramshteks.keyboard.hkml.HkmlCompiler;
	import com.ramshteks.keyboard.hkml.KeysNode;

	import flash.display.Sprite;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;

	/**
	 * ...
	 * @author ramshteks
	 */
	public class Main extends Sprite {
		public function Main() {
			super();

			var keys:Vector.<int> = new Vector.<int>(3);

			keys[0] = Keyboard.A;
			keys[1] = Keyboard.B;
			keys[2] = Keyboard.C;

			var keysNode:KeysNode = new KeysNode(keys, -1, false);

			/*trace(keysNode.testKeys(Keyboard.A, getTimer() - 4), keysNode.finished);
			trace(keysNode.testKeys(Keyboard.C, getTimer() - 5), keysNode.finished);
			trace(keysNode.testKeys(Keyboard.C, getTimer() - 5), keysNode.finished);
			trace(keysNode.testKeys(Keyboard.A, getTimer() - 4), keysNode.finished);
			trace(keysNode.testKeys(Keyboard.C, getTimer() - 5), keysNode.finished);
			trace(keysNode.testKeys(Keyboard.B, getTimer()  - 20), keysNode.finished);*/

			keysNode.reset();

			//trace(keysNode);

			//trace(
					HkmlCompiler.compile("A+ C>> D>100 > bb");//);
			/*trace(keysNode.testKeys(Keyboard.A, 10), keysNode.finished);
			trace(keysNode.testKeys(Keyboard.B, 10), keysNode.finished);
			trace(keysNode.testKeys(Keyboard.C, 10), keysNode.finished);*/

		}
	}
}
