Class {
	#name : #SWMDTofJSTest,
	#superclass : #SWTranspilerTestBase,
	#category : #'SWFortranByPharo-Transpiler-Tests-JS'
}

{ #category : #tests }
SWMDTofJSTest >> test_0010_nop [
	self resultWith: {  } equals: '_0010_nop(){
}
'
]

{ #category : #tests }
SWMDTofJSTest >> test_0030_has_arguments [
	self resultWith: { String } equals: '_0030_has_arguments_(arg){
    return arg;
}
'
]

{ #category : #utilities }
SWMDTofJSTest >> transpile: selector with: args [
	self setUpDecoder: selector with: args.
	transpiler bodyTranspiler: (SWMBTofJS new
		decoder: decoder;
		yourself).
	transpiler stream newline: String cr.
	transpiler transpile
]

{ #category : #accessing }
SWMDTofJSTest >> transpilerClass [
	^ SWMDTofJS
]
