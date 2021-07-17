Extension { #name : #RBLiteralValueNode }

{ #category : #'*SWFortranByPharo-Client' }
RBLiteralValueNode >> transpileUsing: transpiler [
	self value isString ifTrue: [
		transpiler putString: self value
	] ifFalse: [
		transpiler put: self sourceText.
	].
	^ self value
]
