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
SWCDTofF90 >> putClassFooter [
	self stream << 'end module '; << self targetClass name; << '_module'; putLine
]

{ #category : #'code generation' }
SWCDTofF90 >> putClassHeader [
	self stream << 'module '; << targetClass name; << '_module'; putLine;
		<< 'contains'; putLine.
]

{ #category : #'code generation' }
SWCDTofF90 >> putMember [
"
	self targetClass slots do: [ :each |
		self classInfo slot detect: [ :one | one name = each name ] ifFound: [ :found |
			(found isNotNil and: [ found name isEmptyOrNil not ]) ifTrue: [
				self putMemberDeclarationOf: found
			]
		]
	].
"
	self putMethods.
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
	] ifFalse: [|args|
		args := OrderedCollection new.
		mbt put: 'subroutine '; put: mbt mangle; put: '('.
		mbt expression messageInfo needsSelf ifTrue: [ args add: #self ].
		args addAll: (mbt expression arguments collect: [ :each | each name ]).
		args do: [ :arg | mbt put: arg ] separatedBy: [ mbt put: ', ' ].
		mbt put: ')'; cr; incIndent
	]

]

{ #category : #private }
SWCDTofF90 >> transpileAsInstanceSide [
	self stream putComment: self targetClass comment.
	self putClassHeader.
	self stream incIndent.

	self putMember.

	self stream decIndent.
	self putClassFooter.

]
