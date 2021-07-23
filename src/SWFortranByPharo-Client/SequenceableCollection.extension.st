Extension { #name : #SequenceableCollection }

{ #category : #'*SWFortranByPharo-Client' }
SequenceableCollection >> transpileUsing: transpiler [
	transpiler 
		putArrayHeader;
		putArray: self;
		putArrayFooter.
]
