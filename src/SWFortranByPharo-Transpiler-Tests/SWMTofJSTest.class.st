Class {
	#name : #SWMTofJSTest,
	#superclass : #SWTranspilerTestBaseJS,
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
        return this._var1;
    }
    var1_(anObject){
        this._var1 = anObject;
        return this;
    }
}
var tp = null;
tp = new SWTestProgram();
tp.var1_(123);
return tp.var1();
'
]

{ #category : #utilities }
SWMTofJSTest >> transpile: aMethod with: arguments [
	^ (module method: aMethod with: arguments)
		transpile
]
