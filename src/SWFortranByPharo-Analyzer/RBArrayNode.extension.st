Extension { #name : #RBArrayNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBArrayNode >> traverseUsing: transpiler [
	^ self statements traverseUsing: transpiler

]
