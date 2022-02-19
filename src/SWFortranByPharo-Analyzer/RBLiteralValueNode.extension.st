Extension { #name : #RBLiteralValueNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBLiteralValueNode >> traverseUsing: transpiler [
	^ self value ifNotNil: [
		self value traverseUsing: transpiler
	] ifNil: [
		transpiler putNil
	]

]
