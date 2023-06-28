Catspeak.addFunction("show_message", show_message);
Catspeak.addFunction("show_debug_message", show_debug_message);
Catspeak.applyPreset(CatspeakPreset.GML);

var _asg = catspeak_load_script("example.meow");
var _func = Catspeak.compileGML(_asg);

_func();
print = _func.getGlobals()[$ "print"];	
print2 = _func.getGlobals()[$ "print2"];	
print("Good job! ( ⓛ ω ⓛ *)");