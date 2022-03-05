Class {
	#name : #SWMBTofJSTest2,
	#superclass : #SWTranspilerTestBaseJS,
	#category : #'SWFortranByPharo-Transpiler-Tests-JS'
}

{ #category : #tests }
SWMBTofJSTest2 >> test_9002_ZnUrl_queryAt_ifPresent [
	SWServer setUpTranspiler: module.
	self resultWith: { ZnUrl }
]

{ #category : #utilities }
SWMBTofJSTest2 >> transpile: aMethod with: operands [
	(module pool transpilerFor: aMethod with: operands)
		transpile

]
