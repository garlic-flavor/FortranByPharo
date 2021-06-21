Extension { #name : #RBSequenceNode }

{ #category : #'*SWFortranByPharo-Client' }
RBSequenceNode >> transpileUsing: transpiler [
	self flag: #TODO. "under construction."
	self children do: [ :one|
		one transpileUsing: transpiler.
		transpiler putLine: ''
	]
]
