Extension { #name : #RBMessageNode }

{ #category : #'*SWFortranByPharo-Client' }
RBMessageNode >> transpileUsing: arg1 [

	^ arg1
		  putMessage: self receiver
		  send: self selector
		  with: self arguments
]
