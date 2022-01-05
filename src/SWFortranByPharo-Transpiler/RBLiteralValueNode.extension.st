Extension { #name : #RBLiteralValueNode }

{ #category : #'*SWFortranByPharo-Transpiler' }
RBLiteralValueNode >> transpileUsing: transpiler [
	^ self value ifNotNil: [
		self value transpileUsing: transpiler
	] ifNil: [
		transpiler putNil
	]

]
