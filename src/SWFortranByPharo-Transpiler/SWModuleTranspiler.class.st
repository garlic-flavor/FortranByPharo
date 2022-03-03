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
SWModuleTranspiler >> basename [
	self halt; flag: #toRewrite.
	^ String streamContents: [ :s | self payload putBasenameOn: s ]
]

{ #category : #accessing }
SWModuleTranspiler >> contents [
	^ self stream contents
]

{ #category : #api }
SWModuleTranspiler >> decode [
	self decoder pool addInitializerIn: self decoder receiverClass.
	self decoder decode.

]

{ #category : #'public API' }
SWModuleTranspiler >> decode: aSelector with: args [
	self halt; flag: #toRewrite.

	^ self pool newSenderOf: aSelector super: false with: (SWSlotOld newFrom: args)
]

{ #category : #accessing }
SWModuleTranspiler >> filename [
	^ String streamContents: [ :s | self putFilenameOn: s ]
]

{ #category : #accessing }
SWModuleTranspiler >> global [
	^ self pool global
]

{ #category : #accessing }
SWModuleTranspiler >> haltAt: sender [
	self halt; flag: #toRewrite.
	self pool haltAt: sender
]

{ #category : #'public API' }
SWModuleTranspiler >> import: anArray from: basename [
	self mainTranspiler
		putImport: anArray from: basename;
		putStatementDelimiter;
		cr
]

{ #category : #accessing }
SWModuleTranspiler >> logger [
	self halt; flag: #toRewrite.
	^ self payload logger
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
SWModuleTranspiler >> putFilenameOn: aStream [
	aStream
		<< self senderInfo receiverClass instanceSide name;
		<< self senderInfo method selector  asCamelCase
]

{ #category : #accessing }
SWModuleTranspiler >> senderInfo [

	^ self mainTranspiler expression senderInfo
]

{ #category : #private }
SWModuleTranspiler >> solveDependencies [
	self halt; flag: #toRewrite.
	self solveDependencies: self payload receiverClass

]

{ #category : #private }
SWModuleTranspiler >> solveDependencies: aClass [
	|tClass solver|
	self halt; flag: #toRewrite.
	solver := #solveDependenciesUsing:.
	tClass := aClass instanceSide.
	(tClass respondsTo: solver) ifTrue: [
		tClass perform: solver with: self
	]
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
	rClass := self mainTranspiler expression receiverClass instanceSide.
	(rClass respondsTo: #solveDependencies:) ifTrue: [
		rClass solveDependencies: self
	].
	self transpile: self mainTranspiler expression method methodClass instanceSide.
	self transpile: rClass.
	self mainTranspiler transpile

]

{ #category : #'public API' }
SWModuleTranspiler >> transpile: aClass [
	|cdt|
	cdt := (self pool getClassInfo: aClass).
	cdt isTranspiled ifTrue: [ ^ self ].
	cdt transpile

]
