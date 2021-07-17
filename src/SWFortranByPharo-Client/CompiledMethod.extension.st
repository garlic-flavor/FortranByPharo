Extension { #name : #CompiledMethod }

{ #category : #'*SWFortranByPharo-Client' }
CompiledMethod >> transpileUsing: transpiler [
	|res|
	transpiler enterBlock.
	res := self sourceNode transpileUsing: transpiler.
	transpiler leaveBlock.
	^ res
]
