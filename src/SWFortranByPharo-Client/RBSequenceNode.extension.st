Extension { #name : #RBSequenceNode }

{ #category : #'*SWFortranByPharo-Client' }
RBSequenceNode >> hasReturnNode [
	^ self allStatements reversed anySatisfy: [ :a | a class = RBReturnNode ]

]
