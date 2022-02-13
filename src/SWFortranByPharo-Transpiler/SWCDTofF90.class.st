"
SWCDTofF90 is an implementation of SWClassDefinitionTranspiler for Fortran 90.
"
Class {
	#name : #SWCDTofF90,
	#superclass : #SWClassDefinitionTranspiler,
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #initialization }
SWCDTofF90 >> initialize_ThreadSafeTranscript [
	super initialize_ThreadSafeTranscript .
	self
		defineMethodSender: #show: as: [ :transpiler :sender |
			transpiler
				put: 'print *, ';
				<< sender node arguments first
		];
		defineMethodSender: #cr as: [ :transpiler :sender |
			transpiler put: 'print *, '''''
		]
]
