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
	self error; flag: #toRemove.
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

{ #category : #'code generation' }
SWCDTofF90 >> putMethodFooter: mbt [
	mbt node containsReturn ifTrue: [
		self halt.
	] ifFalse: [
		mbt decIndent; put: 'end subroutine '; put: mbt mangle; cr
	]
]

{ #category : #'code generation' }
SWCDTofF90 >> putMethodHeader: mbt [
	mbt node containsReturn ifTrue: [
		self halt.
	] ifFalse: [
		mbt put: 'subroutine '; put: mbt mangle; put: '('.
		mbt expression arguments do: [ :arg |
			mbt put: arg name
		] separatedBy: [ mbt put: ', ' ].
		mbt put: ')'; cr; incIndent
	]

]

{ #category : #private }
SWCDTofF90 >> transpileAsInstanceSide [

]
