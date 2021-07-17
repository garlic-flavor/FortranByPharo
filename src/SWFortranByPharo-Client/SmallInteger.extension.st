Extension { #name : #SmallInteger }

{ #category : #'*SWFortranByPharo-Client' }
SmallInteger >> rb_opAdd_with: args using: transpiler [
	transpiler
		put: ' + ';
		putArgumentsOf: #+ with: args.
	^ self
]

{ #category : #'*SWFortranByPharo-Client' }
SmallInteger >> rb_opMul_with: args using: transpiler [
	transpiler
		put: ' * ';
		putArgumentsOf: #* with: args.
	^ self
]
