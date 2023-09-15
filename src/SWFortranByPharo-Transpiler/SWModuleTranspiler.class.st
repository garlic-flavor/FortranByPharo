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

{ #category : #accessing }
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
SWModuleTranspiler >> main: aScript [
	(aScript class includesBehavior: FullBlockClosure) ifTrue: [
		^ self mainTranspiler: (self pool transpilerForMain: aScript)
	].
	(aScript includesBehavior: SWFProgram) ifTrue: [
		^ self mainTranspiler:
			(self pool transpilerFor: (aScript methodDict at: #main) with: { aScript })
	].
	self error.


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
	(rClass respondsTo: #setupTranspiler:) ifTrue: [
		rClass setupTranspiler: self
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
SWModuleTranspiler >> script: aScript [
	self mainTranspiler: (self pool transpilerForAScript: aScript)
]

{ #category : #accessing }
SWModuleTranspiler >> senderInfo [

	^ self mainTranspiler expression senderInfo
]

{ #category : #analyzing }
SWModuleTranspiler >> solveDependencies [
	|rClass riClass|
	rClass := self mainTranspiler receiverClass.
	rClass ifNil: [ ^ self ].
	riClass := rClass instanceSide.
	(rClass respondsTo: #solveDependencies:) ifFalse: [ ^ self ].
	rClass solveDependencies: self


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
	self solveDependencies.
	self transpile: self mainTranspiler expression method methodClass instanceSide.
	self transpile: self mainTranspiler receiverClass instanceSide.
	self mainTranspiler transpileAsMain

]

{ #category : #'public API' }
SWModuleTranspiler >> transpile: aClass [
	|cdt|
	cdt := (self pool getClassInfo: aClass).
	cdt isTranspiled ifTrue: [ ^ self ].
	cdt transpile.

]
