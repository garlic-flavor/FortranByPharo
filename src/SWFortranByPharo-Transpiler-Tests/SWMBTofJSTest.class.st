Class {
	#name : #SWMBTofJSTest,
	#superclass : #SWMethodBodyTranspilerTest,
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
	self resultWith: { Boolean } equals: 'return (needle ? 123 : "False");
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
SWMBTofJSTest >> test_01_Transcript [
	|transpiler result|
	transpiler := self transpileNo: 39 with: { }.
	result := transpiler stream contents.
	self assert: result equals: 'Transcript.show_("Hello, good-bye!");
Transcript.cr();
Transcript.cr();
'
]

{ #category : #tests }
SWMBTofJSTest >> test_01_return_constant [
	self resultOfNo: 1 with: {  }
]

{ #category : #tests }
SWMBTofJSTest >> test_02_SWStd_print [

	|transpiler result|
	transpiler := self transpileNo: 28 with: {}.
	result := transpiler stream contents.
	self assert: result equals: 'return console.log("hoge!");
'
]

{ #category : #tests }
SWMBTofJSTest >> test_06_cascading [
	|transpiler result|
	transpiler := self transpileNo: 41 with: { String }.
	result := transpiler stream contents.
	self assert: result equals: 'return function(_receiver_){
     return (_receiver_.failed(), 
    _receiver_.message_("hogehoge"), 
    _receiver_.uri_(uri), 
    _receiver_);
}(new SWServerStatus()).toString();
'
]

{ #category : #tests }
SWMBTofJSTest >> test_07_opBinaries [
	|transpiler result|
	transpiler := self transpileNo: 42 with: { Integer }.
	result := transpiler stream contents.
	self assert: result equals: 'return (((a + 100) * 200) - 300) / 400;
'

]

{ #category : #tests }
SWMBTofJSTest >> test_08_try_catch [
	|transpiler result|
	transpiler := self transpileNo: 34 with: {  }.
	result := transpiler stream contents.
	self assert: result equals: 'return function(){ try {
    return 1 + 2;
} catch {
    return self.error();
}}();
'

]

{ #category : #tests }
SWMBTofJSTest >> test_09_closure_local_variable [
	|transpiler result|
	transpiler := self transpileNo: 43 with: {  }.
	result := transpiler stream contents.
	result inspect.
]

{ #category : #tests }
SWMBTofJSTest >> test_10_ifTrue_and_local_variable [
	|transpiler result|
	transpiler := self transpileNo: 44 with: {  }.
	result := transpiler stream contents.
	result inspect.
]

{ #category : #tests }
SWMBTofJSTest >> test_11_locals [
	|transpiler result|
	transpiler := self transpileNo: 45 with: { Boolean }.
	result := transpiler stream contents.
	result inspect.
]

{ #category : #tests }
SWMBTofJSTest >> test_12_has_arguments [
	|transpiler result|
	transpiler := self transpileNo: 2 with: { String }.
	result := transpiler stream contents.
	self halt.
	self assert: result equals: 'Transcript.show_("Hello, good-bye!");
Transcript.cr();
Transcript.cr();
'
]

{ #category : #accessing }
SWMBTofJSTest >> transpilerClass [
	^ SWMBTofJS
]
