Extension { #name : #RBLiteralValueNode }

{ #category : #'*SWFortranByPharo-Client' }
RBLiteralValueNode >> transpileUsing: transpiler [
	^ self value ifNotNil: [
		self value transpileUsing: transpiler
	] ifNil: [
		transpiler putNil
	]

]
