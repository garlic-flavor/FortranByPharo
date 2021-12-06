Extension { #name : #SequenceableCollection }

{ #category : #'*SWFortranByPharo-Client' }
SequenceableCollection >> transpileUsing: arg1 [

	^ arg1 putArray: self
]
