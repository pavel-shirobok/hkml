package {
	import com.ramshteks.keyboard.hkml.HkmlCompiler;
	import com.ramshteks.keyboard.hkml.HkmlEvent;
	import com.ramshteks.keyboard.hkml.HkmlKeyboardController;
	import com.ramshteks.keyboard.hkml.HkmlVM;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Keyboard;

	/**
	 * ...
	 * @author ramshteks
	 */
	public class Main extends Sprite {
		private var _controller:HkmlKeyboardController;
		public function Main() {
			super();

			//win failed: I don't know why...
			testCompiler("A+B>>C>100>D", "HkmlVM{(65+66),(67),(100:68)}", "ABCD", "ABDC");
			testCompiler("A+B>>C>>D", "HkmlVM{(65+66),(67>>68)}", "ABCD", "CDAS");
			testCompiler("A+B+C>>D>>E>>F>100>G", "HkmlVM{(65+66+67),(68>>69>>70),(100:71)}", "ABCDEFG", "WQER");

			//all ok
			testCompiler("D>100>B>100>C", "HkmlVM{(68),(100:66),(100:67)}", "DBC", "CDS");
			testCompiler("D>100>B+A", "HkmlVM{(68),(100:66+65)}", "DAB", "ABD");
			testCompiler("G>>A+B+C", "HkmlVM{(71),(65+66+67)}", "GABC", "FABC");


			addEventListener(Event.ADDED_TO_STAGE, onAdded)
		}

		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);

			_controller = new HkmlKeyboardController(stage);
			_controller.addEventListener("CONTROL+C", onA_B)
		}

		private function onA_B(e:HkmlEvent):void {
			trace(e.type, e.status);
		}



		private static function testCompiler(toCompile:String, compiledToString:String, strToWin:String, strToFail:String):void {
			var vm:HkmlVM = HkmlCompiler.compile(toCompile);
			if(vm.toString()!=compiledToString){
				trace(toCompile, "compile failed with", compiledToString);

			}else{
				if(resetVirtualMachineAndCheckForString(vm, strToWin) == false){
					trace(toCompile, "str win failed");
				}
				if(resetVirtualMachineAndCheckForString(vm, strToFail) == true){
					trace(toCompile, "str fail failed");
				}
			}
		}

		private static function resetVirtualMachineAndCheckForString(vm:HkmlVM, str:String):Boolean{
			vm.reset();
			for(var i:int = 0; i<str.length; i++){
				vm.testKey(Keyboard[str.charAt(i).toUpperCase()]);
			}
			return vm.isFinished;
		}
	}
}
