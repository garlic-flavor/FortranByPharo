Extension { #name : #RBArrayNode }

{ #category : #'*SWFortranByPharo-Analyzer' }
RBArrayNode >> dispatchTo: transpiler [
	^ self statements dispatchTo: transpiler

]
