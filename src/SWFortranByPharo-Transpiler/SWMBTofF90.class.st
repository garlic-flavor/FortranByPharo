"
SWMBTofF90 is an implementation of SWMethodBodyTranspiler for Fortran 90.
"
Class {
	#name : #SWMBTofF90,
	#superclass : #SWMethodBodyTranspiler,
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #'as yet unclassified' }
SWMBTofF90 >> putStdOut [
	self children second result value = Array ifTrue: [
		self put: 'print *, '.
		self children second children do: [ :child |
			self transpileChild: child
		] separatedBy: [ self put: ', ' ]
	] ifFalse: [
		self put: 'print *, '; transpileChildWithoutBracket: self children second
	]

]

{ #category : #'code generation' }
SWMBTofF90 >> putVariableDeclarationOf: aName [
	|typeName|
	typeName := self expression slot detect: [ :each | each name = aName ] ifFound: [ :found |
		self pool class mangleClass transpiledTypeNameOf: found value
	] ifNone: [
		'Integer'
	].
	self put: typeName; put: ' '; put: aName; cr.

]

{ #category : #'public API' }
SWMBTofF90 >> transpileAsMain [
	self put: 'program '.
	self expression senderInfo putBasenameOn: self stream.
	self cr; incIndent; put: 'implicit none'; cr.
	super transpileAsMain.
	self decIndent; put: 'end program '.
	self expression senderInfo putBasenameOn: self stream.
	self cr
]
