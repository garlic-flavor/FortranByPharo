Extension { #name : #FullBlockClosure }

{ #category : #'*SWFortranByPharo-Client' }
FullBlockClosure >> transpileUsing: transpiler [
	|res|
	transpiler incIndent.
	res := self sourceNode transpileUsing: transpiler.
	transpiler decIndent.
	^ res
]
