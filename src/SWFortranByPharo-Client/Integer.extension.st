Extension { #name : #Integer }

{ #category : #'*SWFortranByPharo-Client' }
Integer class >> initializeClassTranspiler: aCT [
	aCT targetClass isInstanceSide ifTrue: [
		aCT
			defineMethodReturnsReceiver: #+
	] ifFalse: [
	]
]

{ #category : #'*SWFortranByPharo-Client' }
Integer >> transpileUsing: transpiler [
	^ transpiler putInteger: self
]
