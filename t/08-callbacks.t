use lib '.';
use t::CompileTestLib;
use NativeCall;
use Test;

plan(5);

compile_test_lib('08-callbacks');

class Struct is repr('CStruct') {
    has Str  $.str;
    has long $.ival;

    method init {
        $!str := 'Tweedledum, tweedledee';
        $!ival = 314;
    }
}

sub TakeACallback(&cb ()) is native('./08-callbacks') { * }
sub TakeIntCallback(&cb (int32)) is native('./08-callbacks') { * }
sub TakeStringCallback(&cb (Str)) is native('./08-callbacks') { * }
sub TakeStructCallback(&cb (Struct)) is native('./08-callbacks') { * }

sub CheckReturnsFloat(&cb (--> num)) is native('./08-callbacks') { * }
sub CheckReturnsStr(&cb (--> Str)) is native('./08-callbacks') { * }
sub CheckReturnsStruct(&cb (--> Struct)) is native('./08-callbacks') { * }

sub simple_callback() {
    pass 'simple callback';
}

sub int_callback(int32 $x) {
    is $x, 17, 'int callback argument'
}

sub str_callback(Str $x) {
    is $x, 'lorem ipsum', 'string callback argument'
}

sub struct_callback(Struct $struct) {
    is $struct.str, 'foobar', 'struct callback string argument';
    is $struct.ival, -42, 'struct callback int argument';
}

sub return_float() returns num {
    return 1.23e0;
}

sub return_str() returns Str {
    return 'Herps and derps';
}

sub return_struct() returns Struct {
    my Struct $struct .= new;
    $struct.init;

    return $struct;
}

TakeACallback(&simple_callback);
TakeIntCallback(&int_callback);
TakeStringCallback(&str_callback);
TakeStructCallback(&struct_callback);

CheckReturnsFloat(&return_float);
CheckReturnsStr(&return_str);
CheckReturnsStruct(&return_struct);

# vim:ft=perl6
