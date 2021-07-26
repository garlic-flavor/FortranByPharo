Extension { #name : #RBArrayNode }

{ #category : #'*SWFortranByPharo-Client' }
RBArrayNode >> transpileUsing: transpiler [
	^ self statements do: [:each |
		each transpileUsing: transpiler
	]

]
