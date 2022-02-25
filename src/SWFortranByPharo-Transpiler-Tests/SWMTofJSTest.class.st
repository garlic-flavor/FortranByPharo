Class {
	#name : #SWMTofJSTest,
	#superclass : #SWTranspilerTestBase,
	#category : #'SWFortranByPharo-Transpiler-Tests-JS'
}

{ #category : #tests }
SWMTofJSTest >> test_0010_nop [
	self resultWith: {  } equals: '/// I''m a test class for SWDecoderTest.
class SWTestProgram extends PharoObject {
}
'
]

{ #category : #utilities }
SWMTofJSTest >> transpile: selector with: arguments [
	decoder
		method: (self getMethodBySelector: selector);
		operands: (self makeArgument: arguments).
	transpiler decoder: decoder.
	transpiler decode.
	transpiler stream newline: String cr.
	transpiler transpile.
]

{ #category : #accessing }
SWMTofJSTest >> transpilerClass [
	^ SWMTofJS
]
