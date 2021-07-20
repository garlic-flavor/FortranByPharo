Extension { #name : #SWShell }

{ #category : #'*SWFortranByPharo-Client' }
SWShell class >> rb_execute_with: arguments using: transpiler [
	transpiler put: '`'.
	arguments do: [:each|
		transpiler put: each value asString
	] separatedBy: [ 
		transpiler put: ' '
	].
	transpiler put: '`'.
]
