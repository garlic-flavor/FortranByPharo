Extension { #name : #RBMessageNode }

{ #category : #'*SWFortranByPharo-Transpiler' }
RBMessageNode >> transpileUsing: transpiler [
	^ transpiler putMessage: self withReceiver: self receiver.
]
