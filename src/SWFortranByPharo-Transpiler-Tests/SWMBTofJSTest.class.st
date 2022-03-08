Class {
	#name : #SWMBTofJSTest,
	#superclass : #SWTranspilerTestBaseJS,
	#category : #'SWFortranByPharo-Transpiler-Tests-JS'
}

{ #category : #tests }
SWMBTofJSTest >> test_0010_nop [
	self resultWith: {  } equals: ''
]

{ #category : #tests }
SWMBTofJSTest >> test_0020_return_constant [
	self resultWith: {  } equals: 'return 345;
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0030_has_arguments [
	self resultWith: { String } equals: 'return arg;
'

]

{ #category : #tests }
SWMBTofJSTest >> test_0040_local_variables [
	self resultWith: {  } equals: 'var tmp1 = null;
var tmp2 = null;
var tmp3 = null;
var tmp4 = null;
var tmp5 = null;
var tmp6 = null;
var tmp7 = null;
var tmp8 = null;
var tmp9 = null;
return tmp9 = 123;
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0050_call_wellknown_message [
	self resultWith: { SmallInteger } equals: 'var tmp1 = null;
tmp1 = 123;
return arg1 + tmp1;
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0060_ifTrue_ifFalse [
	self resultWith: { Boolean } equals: 'if(needle){
    123;
} else {
    "False";
}
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0070_ifTrue_ifFalse_expression [
	self resultWith: { Boolean } equals: 'var t_0 = null;
If(needle){
    t_0 = 123;
} else {
    t_0 = 123;
}
return t_0;
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0080_ifTrue_ifFalse_shortcircuit [
	self resultWith: { Boolean } equals: 'if(needle){
    return 123;
} else {
    return "False";
}
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0090_ifFalse_ifTrue [
	self resultWith: { Boolean } equals: 'if(!needle){
    123;
} else {
    "True";
}
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0120_ifTrue [
	self resultWith: { Boolean } equals: 'if(needle){
    123;
}
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0130_ifTrue_shortcircuit [
	self resultWith: { Boolean } equals: 'if(needle){
    return 123;
}
return "false";
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0140_ifFalse [
	self resultWith: { Boolean } equals: 'if(!needle){
    123;
}
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0160_ifNotNil_ifNil [
	self resultWith: { Object } equals: 'if(needle != null){
    123;
} else {
    "Nil";
}
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0170_ifNotNil_ifNil_expression [
	self resultWith: { Object } equals: 'var t_0 = null;
if(needle != null ){
    t_0 = 123;
} else {
    t_0 = "Nil";
}
return t_0;
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0260_ifNil_expression [
	self resultWith: { Object } equals: 'var t_0 = null;
if(needle == null )  {
    t_0 = 123;
}
return t_0;
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0261_ifNil_expression2 [
	self resultWith: { Object } equals: 'var t_0 = null;
t_0 = needle.asTime();
return t_0 != null ? t_0 : 123;
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0290_SWStd_print [
	self resultWith: {  } equals: 'return console.log("hoge!");
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0300_recursive_message_call [
	self resultWith: { SmallInteger } equals: 'return (0 < arg1) ? (arg1 + (self._0300_recursive_message_call_(arg1 - 1))) : 0;
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0310_new [
	self resultWith: { SmallInteger } equals: 'var loc1 = null;
var loc2 = null;
loc1 = new Dictionary();
loc2 = new Set();
return loc2;
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0330_try_catch [
	self resultWith: {  } equals: 'try {
    1 + 2;
} catch {
    self.error();
}
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0331_try_catch2 [
	self resultWith: {  } equals: 'try {
    1 + 2;
} catch (e){
    self.error_(e.toString());
}
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0340_try_catch_expression [
	self resultWith: {  } equals: 'var t_0 = null;
try {
    t_0 = (1 + 2);
} catch(){
    self.error();
}
return t_0;
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0390_opBinaries [
	self resultWith: { Float } equals: 'return (((a + 100) * 200) - 300) / 400;
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0400_cascading [

	self resultWith: { String } equals: 'var t_0 = null;
t_0 = new SWServerStatus();
t_0.failed();
t_0.message_("hogehoge");
t_0.uri_(uri);
return (t_0).toString();
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0410_Transcript [
	self resultWith: {  } equals: 'Transcript.show_("Hello, good-bye!");
Transcript.cr();
Transcript.cr();
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0420_closure_local_variable [
	self resultWith: {  } equals: 'try {
    var hoge = null;
    hoge = 123;
} catch {
    self.error();
}
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0430_ifTrue_and_local_variable [
	self resultWith: {  } equals: 'var outervar = null;
outervar = true;
if(outervar){
    var inner = null;
    inner = 234;
    return inner;
}
return outervar;
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0440_locals [
	self resultWith: { SmallInteger } equals: 'var outer1 = null;
var inner = null;
var inner = null;
var inner2 = null;
outer1 = true;
return outer1 ? inner = 234 : (inner = 345, 
    inner2 = "hello");
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0450_locals2 [
	self resultWith: { String } equals: 'var outer0 = null;
var outer1 = null;
var outer2 = null;
var outer3 = null;
outer1 = true;
(function(arg2){
    var inner1 = null;
    var t_0 = null;
    if(outer1){
        var inner2 = null;
        t_0 = (inner1 = "hoge", 
            return inner2 = 234);
    };
})(345);
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0470_user_specified_variable_type [
	self resultWith: {  } equals: 'var tmp1 = null;
tmp1 = 3.14159265358979;
return tmp1 * 2.23620679;
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0480_flag [

	self resultWith: {  } equals: '/// toImplement
'
]

{ #category : #'as yet unclassified' }
SWMBTofJSTest >> test_0490_at_put [
	self resultWith: { Dictionary } equals: 'dict["hello"] = "world";
'
]

{ #category : #tests }
SWMBTofJSTest >> test_0500_at_ifAbsent [
	self resultWith: { Dictionary } equals: 'return dict["hello"] || "world";
'
]

{ #category : #utilities }
SWMBTofJSTest >> transpile: aMethod with: operands [
	(module pool transpilerFor: aMethod with: operands)
		transpileAsMain


]
