Extension { #name : #RBReturnNode }

{ #category : #'*SWFortranByPharo-Client' }
RBReturnNode >> transpileUsing: arg1 [

	^ arg1 putReturn: self value
]
