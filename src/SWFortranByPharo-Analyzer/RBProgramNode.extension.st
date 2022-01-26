Extension { #name : #RBProgramNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBProgramNode >> isExpression [
	"In Pharo, everything is an expression. But in transpiling purpose, this is not true."
	self isUsed ifFalse: [ ^ false ].
	self isDirectlyUsed ifTrue: [ ^ true ].
	self parent ifNil: [ ^ true ].
	^ self parent isExpression
]
