Extension { #name : #RBSequenceNode }

{ #category : #'*SWFortranByPharo-Client' }
RBSequenceNode >> transpileUsing: transpiler [
	|res|
	self children do: [ :one|
		res := one transpileUsing: transpiler.
		transpiler putLine: ''
	].
	^ res

]
