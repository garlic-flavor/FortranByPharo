Class {
	#name : #SWMBTofJSTest,
	#superclass : #SWMethodBodyTranspilerTest,
	#category : #'SWFortranByPharo-Transpiler-Tests-JS'
}

{ #category : #tests }
SWMBTofJSTest >> test_01_Transcript [
	|transpiler result|
	transpiler := self transpileNo: 39 withArguments: { }.
	result := transpiler stream contents.
	self assert: result equals: 'Transcript.show_("Hello, good-bye!");
Transcript.cr();
Transcript.cr();
'
]

{ #category : #tests }
SWMBTofJSTest >> test_02_SWStd_print [

	|transpiler result|
	transpiler := self transpileNo: 28 withArguments: {}.
	result := transpiler stream contents.
	self assert: result equals: 'return console.log("hoge!");
'
]

{ #category : #tests }
SWMBTofJSTest >> test_04_ifTrue_ifFalse_expression [
	|transpiler result|
	transpiler := self transpileNo: 06 withArguments: { Boolean }.
	result := transpiler stream contents.
	self assert: result equals: 'return (needle ? 123 : "False");
'
]

{ #category : #tests }
SWMBTofJSTest >> test_05_ifTrue [
	|transpiler result|
	transpiler := self transpileNo: 11 withArguments: { Boolean }.
	result := transpiler stream contents.
	self assert: result equals: 'if(needle){
    123;
}
'
]

{ #category : #tests }
SWMBTofJSTest >> test_06_cascading [
	|transpiler result|
	transpiler := self transpileNo: 41 withArguments: { String }.
	result := transpiler stream contents.
	self assert: result equals: 'return (function(_receiver_) {
    _receiver_.failed();
    _receiver_.message_("hogehoge");
    _receiver_.uri_(uri);
    return _receiver_;
})((new SWServerStatus())).toString();
'
]

{ #category : #tests }
SWMBTofJSTest >> test_07_opBinaries [
	|transpiler result|
	transpiler := self transpileNo: 42 withArguments: { Integer }.
	result := transpiler stream contents.
	self assert: result equals: 'return (((a + 100) * 200) - 300) / 400;
'

]

{ #category : #tests }
SWMBTofJSTest >> test_08_try_catch [
	|transpiler result|
	transpiler := self transpileNo: 34 withArguments: {  }.
	result := transpiler stream contents.
self halt.
	self assert: result equals: 'return (function(){try {
    return 1 + 2;
} catch {
    return self.error();
}})();
'

]

{ #category : #tests }
SWMBTofJSTest >> test_09_closure_local_variable [
	|transpiler result|
	transpiler := self transpileNo: 43 withArguments: {  }.
	result := transpiler stream contents.
	result inspect.
]

{ #category : #tests }
SWMBTofJSTest >> test_10_ifTrue_and_local_variable [
	|transpiler result|
	transpiler := self transpileNo: 44 withArguments: {  }.
	result := transpiler stream contents.
	result inspect.
]

{ #category : #tests }
SWMBTofJSTest >> test_11_locals [
	|transpiler result|
	transpiler := self transpileNo: 45 withArguments: { Boolean }.
	result := transpiler stream contents.
	result inspect.
]

{ #category : #accessing }
SWMBTofJSTest >> transpilerClass [
	^ SWMBTofJS
]
