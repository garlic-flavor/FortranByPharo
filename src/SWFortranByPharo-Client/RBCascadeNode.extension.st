Extension { #name : #RBCascadeNode }

{ #category : #'*SWFortranByPharo-Client' }
RBCascadeNode >> transpileUsing: transpiler [
	self messages do: [ :each|
		each transpileUsing: transpiler.
	] separatedBy: [
		transpiler putLine.
	]
]
