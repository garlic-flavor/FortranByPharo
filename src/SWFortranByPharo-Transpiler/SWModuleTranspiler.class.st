"
I represent a module (equals to a file).
"
Class {
	#name : #SWModuleTranspiler,
	#superclass : #Object,
	#instVars : [
		'stream',
		'pool',
		'mainTranspiler'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #'instance creation' }
SWModuleTranspiler class >> main: aClass [
	^ self new
		main: aClass;
		yourself

]

{ #category : #'as yet unclassified' }
SWModuleTranspiler class >> poolClass [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWModuleTranspiler >> contents [
	^ self stream contents
]

{ #category : #accessing }
SWModuleTranspiler >> filename [
	^ String streamContents: [ :s | self putFilenameOn: s ]
]

{ #category : #accessing }
SWModuleTranspiler >> global [
	^ self pool global
]

{ #category : #'public API' }
SWModuleTranspiler >> import: anArray from: basename [
	self mainTranspiler
		putImport: anArray from: basename;
		putStatementDelimiter;
		cr
]

{ #category : #accessing }
SWModuleTranspiler >> main: aClass [
	^ self method: (self class poolClass search: #main in: aClass classSide) with: { aClass classSide }
]

{ #category : #accessing }
SWModuleTranspiler >> mainTranspiler [

	^ mainTranspiler
]

{ #category : #accessing }
SWModuleTranspiler >> mainTranspiler: anObject [

	mainTranspiler := anObject
]

{ #category : #accessing }
SWModuleTranspiler >> method: aMethod with: operands [
	|rClass|
	rClass := operands first value instanceSide.
	(rClass respondsTo: #setUpTranspiler:) ifTrue: [
		rClass setUpTranspiler: self
	].
	self mainTranspiler: (self pool transpilerFor: aMethod with: operands)

]

{ #category : #accessing }
SWModuleTranspiler >> pool [

	^ pool ifNil: [
		pool := self class poolClass new
			stream: self stream;
			yourself
	]
]

{ #category : #accessing }
SWModuleTranspiler >> pool: anObject [

	pool := anObject
]

{ #category : #streaming }
SWModuleTranspiler >> putBasenameOn: aStream [
	self senderInfo putBasenameOn: aStream

]

{ #category : #streaming }
SWModuleTranspiler >> putFilenameOn: aStream [
	^ self subclassResponsibility 

]

{ #category : #accessing }
SWModuleTranspiler >> senderInfo [

	^ self mainTranspiler expression senderInfo
]

{ #category : #accessing }
SWModuleTranspiler >> stream [
	^ stream ifNil: [ stream := SWTranspilerStream  new ]
]

{ #category : #accessing }
SWModuleTranspiler >> stream: anObject [

	stream := anObject
]

{ #category : #'public API' }
SWModuleTranspiler >> transpile [
	|rClass|
	rClass := self mainTranspiler receiverClass instanceSide.
	(rClass respondsTo: #solveDependencies:) ifTrue: [
		rClass solveDependencies: self
	].
	self transpile: self mainTranspiler expression method methodClass instanceSide.
	self transpile: rClass.
	self mainTranspiler transpileAsMain

]

{ #category : #'public API' }
SWModuleTranspiler >> transpile: aClass [
	|cdt|
	cdt := (self pool getClassInfo: aClass).
	cdt isTranspiled ifTrue: [ ^ self ].
	cdt transpile

]
