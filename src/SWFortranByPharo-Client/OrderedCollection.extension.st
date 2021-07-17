Extension { #name : #OrderedCollection }

{ #category : #'*SWFortranByPharo-Client' }
OrderedCollection >> rb_at_with: args using: transpiler [
	transpiler
		put: '[';
		putArray: args;
		put: ']'.
	^ self first ifNotNil: [ self first evaluate ] ifNil: [ nil ]
]
