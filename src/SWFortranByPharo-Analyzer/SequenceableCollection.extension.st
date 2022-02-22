Extension { #name : #SequenceableCollection }

{ #category : #'*SWFortranByPharo-Analyzer' }
SequenceableCollection >> dispatchTo: transpiler [
	^ transpiler 
		atArray: self
]
