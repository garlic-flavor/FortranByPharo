Class {
	#name : #SWMTofJSTest,
	#superclass : #SWTranspilerTestBase,
	#category : #'SWFortranByPharo-Transpiler-Tests-JS'
}

{ #category : #tests }
SWMTofJSTest >> test_0010_nop [
	self resultWith: {  } equals: '/// I''m a test class for SWDecoderTest.
class SWTestProgram extends PharoObject {
    _var1 = null;
}
'
]

{ #category : #tests }
SWMTofJSTest >> test_0460_access_to_local_variables [
	self resultWith: {  } equals: '/// I''m a test class for SWDecoderTest.
class SWTestProgram extends PharoObject {
    _var1 = null;
    var1(){
        return var1;
    }
    var1_(anObject){
        var1 = anObject;
    }
}
var tp = null;
tp = new SWTestProgram();
tp.var1_(123);
return tp.var1();
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
