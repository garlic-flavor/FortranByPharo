Extension { #name : #RBLiteralValueNode }

{ #category : #'*SWFortranByPharo-Client' }
RBLiteralValueNode >> transpileUsing: arg1 [

	^ self value
		  ifNil: [ arg1 putNil ]
		  ifNotNil: [ self value transpileUsing: arg1 ]
]
