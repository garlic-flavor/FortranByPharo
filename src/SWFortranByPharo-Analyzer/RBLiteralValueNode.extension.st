Extension { #name : #RBLiteralValueNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBLiteralValueNode >> dispatchTo: transpiler [
	^ self value ifNotNil: [
		self value dispatchTo: transpiler
	] ifNil: [
		transpiler atNil
	]

]
