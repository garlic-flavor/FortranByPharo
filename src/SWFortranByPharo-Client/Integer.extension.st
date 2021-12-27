Extension { #name : #Integer }

{ #category : #'*SWFortranByPharo-Client' }
Integer class >> initializeClassTranspiler: aCT [
	self halt.
]

{ #category : #'*SWFortranByPharo-Client' }
Integer >> transpileUsing: transpiler [
	^ transpiler putInteger: self
]
