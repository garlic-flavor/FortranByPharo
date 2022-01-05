Extension { #name : #RBArrayNode }

{ #category : #'*SWFortranByPharo-Transpiler' }
RBArrayNode >> transpileUsing: transpiler [
	^ self statements transpileUsing: transpiler

]
