Extension { #name : #SequenceableCollection }

{ #category : #'*SWFortranByPharo-Analyzer' }
SequenceableCollection >> traverseUsing: transpiler [
	^ transpiler 
		putArray: self
]
