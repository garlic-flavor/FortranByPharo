Extension { #name : #RBArrayNode }

{ #category : #'*SWFortranByPharo-Client' }
RBArrayNode >> transpileUsing: transpiler [
	^ self statements transpileUsing: transpiler

]
