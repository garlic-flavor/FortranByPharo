Class {
	#name : #SWMTofZTest,
	#superclass : #SWTranspilerTestBaseZ,
	#category : #'SWFortranByPharo-Transpiler-Tests'
}

{ #category : #tests }
SWMTofZTest >> test_0010_nop [ 
	self resultWith: {  } equals: ''
]

{ #category : #utilities }
SWMTofZTest >> transpile: aMethod with: arguments [
	^ self transpileModule: aMethod with: arguments
]
