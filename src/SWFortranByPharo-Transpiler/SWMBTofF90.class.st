"
SWMBTofF90 is an implementation of SWMethodBodyTranspiler for Fortran 90.
"
Class {
	#name : #SWMBTofF90,
	#superclass : #SWMethodBodyTranspiler,
	#instVars : [
		'bindC'
	],
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

{ #category : #accessing }
SWMBTofF90 >> bindC [

	^ bindC ifNil: [ bindC := false ]
]

{ #category : #accessing }
SWMBTofF90 >> bindC: anObject [

	bindC := anObject
]

{ #category : #'as yet unclassified' }
SWMBTofF90 >> putArgumentDeclaration: anArrayOfVariable [
	anArrayOfVariable do: [ :var |
		self stream put: var name
	] separatedBy: [
		self stream put: ', '
	]

]

{ #category : #'code generation' }
SWMBTofF90 >> putMessageWithSelector: aSelector [
	self expression messageInfo operands first value = self expression messageInfo method methodClass ifTrue: [
		self expression messageInfo isSubroutine ifTrue: [
			self put: 'call '; put: aSelector; putArguments: self children allButFirst
		] ifFalse: [
			self error
		]
	] ifFalse: [
		self error
	]
]

{ #category : #'code generation' }
SWMBTofF90 >> putReturnKeyword [
	self put: 'return ='
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

{ #category : #'as yet unclassified' }
SWMBTofF90 >> putTypeDeclarationOf: aVariable as: aType [
	|name typeSpecs|
	self halt; flag: #toRemove.
	name := aVariable node value.
	typeSpecs := OrderedCollection new.
	self bindC ifTrue: [
		typeSpecs add: (self pool class mangleClass transpiledBindCTypeNameOf: aType result value).
		self expression arguments detect: [ :each | each name = name ] ifFound: [ :found |
			typeSpecs add: 'Value'; add: 'Intent(In)'
		]
	] ifFalse: [
		typeSpecs add: (self pool class mangleClass transpiledTypeNameOf: aType result value).
	].
	typeSpecs do: [ :spec |
		self put: spec
	] separatedBy: [ self put: ', ' ].
	self put: ' :: '; put: name

]

{ #category : #'code generation' }
SWMBTofF90 >> putVariableDeclarationOf: aName [
	|typeName typeSpecs|
	typeSpecs := OrderedCollection new.
	typeName := self expression slot detect: [ :each | each name = aName ] ifFound: [ :found |
		found = SWIO ifTrue: [ ^ self ].
		self bindC ifTrue: [
			typeSpecs add: (self pool class mangleClass transpiledBindCTypeNameOf: found value).
			self expression arguments detect: [ :each | each name = aName ] ifFound: [ :f |
				typeSpecs add: 'Value'; add: 'Intent(In)'
			]
		] ifFalse: [
			typeSpecs add: (self pool class mangleClass transpiledTypeNameOf: found value).
		].
	] ifNone: [
		typeSpecs add: 'Integer'
	].
	typeSpecs do: [ :spec |
		self put: spec
	] separatedBy: [ self put: ', ' ].
	self put: ' :: '; put: aName; cr

]

{ #category : #'code generation' }
SWMBTofF90 >> putVariableDeclarations [

	self expression arguments do: [ :loc |
		self putVariableDeclarationOf: loc name
	].
	super putVariableDeclarations.

]
