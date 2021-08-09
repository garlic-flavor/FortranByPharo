Extension { #name : #RBVariableNode }

{ #category : #'*SWFortranByPharo-Client' }
RBVariableNode >> transpileUsing: transpiler [
	(self variable class = InstanceVariableSlot) ifTrue: [
		^ transpiler put: '@'; put: self name
	].

	^ transpiler putVariable: self name

]
