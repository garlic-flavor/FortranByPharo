Extension { #name : #FullBlockClosure }

{ #category : #'*SWFortranByPharo-Client' }
FullBlockClosure >> rb_value_with: arguments using: transpiler [
	transpiler
		put: '.';
		putFunctionCallOf: 'call' with: arguments.
	^ transpiler variables at: self asString ifAbsent: self
]

{ #category : #'*SWFortranByPharo-Client' }
FullBlockClosure >> transpileUsing: transpiler [
	|res|
	transpiler incIndent.
	res := self sourceNode transpileUsing: transpiler.
	transpiler decIndent.
	^ res
]
