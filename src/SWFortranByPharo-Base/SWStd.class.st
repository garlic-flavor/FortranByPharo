"
I implement stdout.
"
Class {
	#name : #SWStd,
	#superclass : #Object,
	#instVars : [
		'stdout'
	],
	#category : #'SWFortranByPharo-Base'
}

{ #category : #accessing }
SWStd class >> classMethodDeclarationFilter: aSymbol [
	^ false
]

{ #category : #accessing }
SWStd class >> declarationFilterBase: symbolName [
	(#('methodDeclarationFilter:' 'classMethodDeclarationFilter:' 'instanceVariableDeclarationFilter:') anySatisfy: [ :each |
		each = symbolName
	]) ifTrue: [ ^ false ].
	(symbolName beginsWith: 'rb_') ifTrue: [ ^ false ].
	^ true
]

{ #category : #accessing }
SWStd class >> instanceVariableDeclarationFilter: aSymbol [
	^ true
]

{ #category : #accessing }
SWStd class >> methodDeclarationFilter: symbolName [
	^ (self declarationFilterBase: symbolName) and: [
		#(error: stdout stdout: assert: print:) anySatisfy: [ :each | each = symbolName ]
	]

]

{ #category : #'as yet unclassified' }
SWStd class >> rb_error_using: transpiler [
	transpiler putCode: '\
		raise msg
	\'
]

{ #category : #'as yet unclassified' }
SWStd class >> rb_print_using: transpiler [
	transpiler putCode: '\
		puts msg
	\'
]

{ #category : #'as yet unclassified' }
SWStd class >> rb_requirements [
	^ { 'require ''Pharo.rb''' }
]

{ #category : #asserting }
SWStd >> assert: aBlock [
	aBlock value ifFalse: [
		self error: 'Assertion failure: ', aBlock asString
	]
]

{ #category : #'error handling' }
SWStd >> error: msg [
	^ super error: msg
]

{ #category : #printing }
SWStd >> print: msg [
	self stdout << msg asString; cr; flush
]

{ #category : #accessing }
SWStd >> stdout [

	^ stdout ifNil: [ stdout := Transcript ]
]

{ #category : #accessing }
SWStd >> stdout: anObject [

	stdout := anObject
]

{ #category : #'as yet unclassified' }
SWStd >> switch: needle when: anAssociationArray [
	^ anAssociationArray detect: [ :acc |
		(acc key class inheritsFrom: Boolean) ifTrue: [ acc key ]
			ifFalse: [ acc key = needle ]
	]
		ifFound: [ :acc | acc value value ]

]
