"
SWMBTofF90 is an implementation of SWMethodBodyTranspiler for Fortran 90.
"
Class {
	#name : #SWMBTofF90,
	#superclass : #SWMethodBodyTranspiler,
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #accessing }
SWMBTofF90 >> atMethod: aMethodNode [
	|child|
	self putArgumentDeclaration: self expression arguments.
	child := (self scopeChild: self expression)
		putVariableDeclarations;
		putSequence.
	self append: child.

]

{ #category : #'as yet unclassified' }
SWMBTofF90 >> putArgumentDeclaration: anArrayOfVariable [
	anArrayOfVariable do: [ :var |
		self put: (self pool class mangleClass transpiledTypeNameOf: var value); put: ' '; put: var name; cr
	]

]

{ #category : #'code generation' }
SWMBTofF90 >> putMessageWithSelector: aSelector [
	self expression messageInfo operands first value = self expression messageInfo method methodClass ifTrue: [
		self expression messageInfo isSubroutine ifTrue: [
			self put: 'call '; put: aSelector; putArguments: self children allButFirst
		] ifFalse: [
			self halt
		]
	] ifFalse: [
		self halt
	]
]

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
