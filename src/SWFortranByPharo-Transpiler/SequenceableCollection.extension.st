Extension { #name : #SequenceableCollection }

{ #category : #'*SWFortranByPharo-Transpiler' }
SequenceableCollection >> transpileUsing: transpiler [
	^ transpiler 
		putArray: self
]
