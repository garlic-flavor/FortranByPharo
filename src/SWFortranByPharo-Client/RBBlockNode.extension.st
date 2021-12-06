Extension { #name : #RBBlockNode }

{ #category : #'*SWFortranByPharo-Client' }
RBBlockNode >> transpileUsing: arg1 [

	^ arg1 putBlock: self
]
