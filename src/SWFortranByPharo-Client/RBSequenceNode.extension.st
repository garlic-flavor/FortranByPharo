Extension { #name : #RBSequenceNode }

{ #category : #'*SWFortranByPharo-Client' }
RBSequenceNode >> transpileUsing: transpiler [
	transpiler incIndent.
	self children do: [ :one|
		one transpileUsing: transpiler.
		transpiler putLine: ''
	].
	transpiler decIndent.
]
