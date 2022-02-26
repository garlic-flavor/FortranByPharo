Extension { #name : #SequenceableCollection }

{ #category : #'*SWFortranByPharo-Analyzer' }
SequenceableCollection >> dispatchTo: dispatcher [
	^ dispatcher atArray: self
]
