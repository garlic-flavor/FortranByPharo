Extension { #name : #RBVariableNode }

{ #category : #'*SWFortranByPharo-Client' }
RBVariableNode >> transpileUsing: arg1 [

	^ arg1 putVariable: self
]
