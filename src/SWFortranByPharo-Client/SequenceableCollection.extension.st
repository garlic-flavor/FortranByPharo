Extension { #name : #SequenceableCollection }

{ #category : #'*SWFortranByPharo-Client' }
SequenceableCollection >> rb_at_with: arguments using: transpiler [
	transpiler
		put: '[';
		putArgumentsOf: 'at:' with: arguments;
		put: ' - 1]'.

]

{ #category : #'*SWFortranByPharo-Client' }
SequenceableCollection >> rb_opConcat_with: arguments using: transpiler [
	transpiler
		put: ' + ';
		putArgumentsOf: #, with: arguments
]

{ #category : #'*SWFortranByPharo-Client' }
SequenceableCollection >> rb_size_with: arguments using: transpiler [
	transpiler put: '.size'.
	^ self size
]

{ #category : #'*SWFortranByPharo-Client' }
SequenceableCollection >> transpileUsing: transpiler [
	transpiler 
		putArrayHeader;
		putArray: self;
		putArrayFooter.
]
