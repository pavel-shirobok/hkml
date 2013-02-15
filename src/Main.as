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
			testCompiler("A+B>>C>100>D", "HkmlVM{(65+66),(67),(100:68)}", "A,B,C,D", "A,B,D,C");
			testCompiler("A+B>>C>>D", "HkmlVM{(65+66),(67>>68)}", "A,B,C,D", "C,D,A,S");
			testCompiler("A+B+C>>D>>E>>F>100>G", "HkmlVM{(65+66+67),(68>>69>>70),(100:71)}", "A,B,C,D,E,F,G", "W,Q,E,R");

			//all ok
			testCompiler("CONTROL>>A", "HkmlVM{(17>>65)}", "CONTROL,A", "CONTROL,F");
			testCompiler("D>100>B>100>C", "HkmlVM{(68),(100:66),(100:67)}", "D,B,C", "C,D,S");
			testCompiler("D>100>B+A", "HkmlVM{(68),(100:66+65)}", "D,A,B", "A,B,D");
			testCompiler("G>>A+B+C", "HkmlVM{(71),(65+66+67)}", "G,A,B,C", "F,A,B,C");

			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);

			_controller = new HkmlKeyboardController(stage);
			_controller.addEventListener("A+S", onA_B)
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
			var keys:Array = str.split(",");
			for(var i:int = 0; i<keys.length; i++){
				vm.checkPressedKey(Keyboard[keys[i].toUpperCase()]);
			}
			return vm.finished;
		}
	}
}
