package {
	import com.ramshteks.keyboard.hkml.HkmlCompiler;
	import com.ramshteks.keyboard.hkml.HkmlVM;
	import com.ramshteks.keyboard.hkml.KeysNode;

	import flash.display.Sprite;
	import flash.ui.Keyboard;
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

			keysNode.reset();
			/*trace("res0:",HkmlCompiler.compile("A+B>>C>100>D"));
			trace("res1:",HkmlCompiler.compile("A+B>>C>>D"));
			trace("res2:",HkmlCompiler.compile("D>100>B>100>C"));
			trace("res3:",HkmlCompiler.compile("D>100>B+A"));
			trace("res4:",HkmlCompiler.compile("A+B+C>>D>>E>>F>100>G"));
			trace("res5:",HkmlCompiler.compile("G>>A+B+C"));*/

			var vm:HkmlVM = HkmlCompiler.compile("G>>A+B+C");

			test("G", vm);
			test("A", vm);
			test("A", vm);
			test("B", vm);
			test("C", vm);
			trace(vm.isFinished);
			trace("---------");

			vm.reset();
			test("G", vm);
			test("A", vm);
			test("B", vm);
			test("C", vm);
			trace(vm.isFinished);

		}

		private function test(key:String, vm:HkmlVM):void{
			trace(key.toUpperCase(), vm.testKey(Keyboard[key]), vm.isFinished);
		}
	}
}
