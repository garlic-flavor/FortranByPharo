Class {
	#name : #SWMDTofJSTest,
	#superclass : #SWMethodDefinitionTranspilerTest,
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

{ #category : #accessing }
SWMDTofJSTest >> transpilerClass [
	^ SWMDTofJS
]
