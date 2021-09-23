Extension { #name : #RBSequenceNode }

{ #category : #'*SWFortranByPharo-Client' }
RBSequenceNode >> transpileUsing: transpiler [
	transpiler incIndent.
	self children do: [ :one|
		one class = RBVariableNode ifFalse: [
			one transpileUsing: transpiler.
			transpiler putLine: ';'
		]
	].
	transpiler decIndent.
]
