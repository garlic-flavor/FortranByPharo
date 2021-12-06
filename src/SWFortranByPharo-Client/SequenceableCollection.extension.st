Extension { #name : #SequenceableCollection }

{ #category : #'*SWFortranByPharo-Client' }
SequenceableCollection >> transpileUsing: transpiler [
	^ transpiler 
		putArray: self
]
