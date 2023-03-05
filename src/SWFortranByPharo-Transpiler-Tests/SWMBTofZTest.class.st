Class {
	#name : #SWMBTofZTest,
	#superclass : #SWTranspilerTestBaseZ,
	#category : #'SWFortranByPharo-Transpiler-Tests'
}

{ #category : #tests }
SWMBTofZTest >> test_0010_nop [
	self resultWith: { } equals: ''
]

{ #category : #utilities }
SWMBTofZTest >> transpile: aMethod with: operands [
	^ self transpileBody: aMethod with: operands

]
