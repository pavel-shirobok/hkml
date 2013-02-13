package {
	import com.ramshteks.keyboard.hkml.HkmlCompiler;
	import com.ramshteks.keyboard.hkml.HkmlVM;
	import com.ramshteks.keyboard.hkml.KeysNode;

	import flash.display.Sprite;
	import flash.ui.Keyboard;

	/**
	 * ...
	 * @author ramshteks
	 */
	public class Main extends Sprite {
		public function Main() {
			super();

			//win failed:
			testCompiler("A+B>>C>100>D", "HkmlVM{(65+66),(67),(100:68)}", "ABCD", "ABDC");
			testCompiler("A+B>>C>>D", "HkmlVM{(65+66),(67>>68)}", "ABCD", "CDAS");
			testCompiler("A+B+C>>D>>E>>F>100>G", "HkmlVM{(65+66+67),(68>>69>>70),(100:71)}", "ABCDEFG", "WQER");

			//all ok
			testCompiler("D>100>B>100>C", "HkmlVM{(68),(100:66),(100:67)}", "DBC", "CDS");
			testCompiler("D>100>B+A", "HkmlVM{(68),(100:66+65)}", "DAB", "ABD");
			testCompiler("G>>A+B+C", "HkmlVM{(71),(65+66+67)}", "GABC", "FABC");

		}

		private function testCompiler(toCompile:String, compiledToString:String, strToWin:String, strToFail:String):void {
			var vm:HkmlVM = HkmlCompiler.compile(toCompile);
			if(vm.toString()!=compiledToString){
				trace(toCompile, "compile failed with", compiledToString);

			}else{
				if(resetVMAndCheckForString(vm, strToWin) == false){
					trace(toCompile, "str win failed");
				}
				if(resetVMAndCheckForString(vm, strToFail) == true){
					trace(toCompile, "str fail failed");
				}
			}
		}

		private function resetVMAndCheckForString(vm:HkmlVM, str:String):Boolean{
			vm.reset();
			for(var i:int = 0; i<str.length; i++){
				vm.testKey(Keyboard[str.charAt(i).toUpperCase()]);
			}
			return vm.isFinished;
		}

		private function test(key:String, vm:HkmlVM):void{
			trace(key.toUpperCase(), vm.testKey(Keyboard[key]), vm.isFinished);
		}
	}
}
