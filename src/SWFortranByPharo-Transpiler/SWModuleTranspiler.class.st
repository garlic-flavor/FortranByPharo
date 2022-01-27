"
I represent a module (equals to a file).
"
Class {
	#name : #SWModuleTranspiler,
	#superclass : #Object,
	#instVars : [
		'stream',
		'payload'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #constants }
SWModuleTranspiler class >> extension [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWModuleTranspiler class >> methodBodyTranspilerClass [
	^ self subclassResponsibility 
]

{ #category : #'instance creation' }
SWModuleTranspiler class >> newFrom: aClass [
	^ (self new)
		payload: (self methodBodyTranspilerClass
			new: (self methodBodyTranspilerClass poolClass search: #main in: aClass classSide)
			with: { aClass classSide });
		yourself

]

{ #category : #accessing }
SWModuleTranspiler >> contents [
	stream ifNil: [ self transpile ].
	^ self stream contents
]

{ #category : #'as yet unclassified' }
SWModuleTranspiler >> decode: aSelector with: args [
	^ self pool getMethodTranspiler: aSelector supered: false with: args
]

{ #category : #'as yet unclassified' }
SWModuleTranspiler >> enableDebugMode [
	self payload debugMode: true.
	self stream logging: true.
]

{ #category : #accessing }
SWModuleTranspiler >> filename [
	^ String streamContents: [ :s | self payload putFilenameOn: s ]
]

{ #category : #testing }
SWModuleTranspiler >> isToTranspile: aClass [
	|tClass|
self error; flag: #toRemove.

	tClass := self payload methodClass.
	tClass ifNil: [ ^ false ].
	tClass instanceSide = aClass instanceSide ifTrue: [ ^ true ].

	^ (tClass instanceSide respondsTo: #dependings) ifTrue: [
		(tClass instanceSide perform: #dependings)
			anySatisfy: [ :each | each = aClass instanceSide ]
	] ifFalse: [ false ]

]

{ #category : #accessing }
SWModuleTranspiler >> payload [

	^ payload
]

{ #category : #accessing }
SWModuleTranspiler >> payload: anObject [

	payload := anObject
]

{ #category : #accessing }
SWModuleTranspiler >> pool [
	^ self payload pool
]

{ #category : #'as yet unclassified' }
SWModuleTranspiler >> solveDependencies [
	|solver tClass|
	solver := #solveDependenciesUsing:.
	tClass := self payload receiverClass instanceSide.
	(tClass respondsTo: solver) ifTrue: [
		tClass perform: solver with: self
	].
	self pool detect: [ :each | each targetClass = tClass ] ifFound: [ :t |
		self transpile: tClass
	]
]

{ #category : #accessing }
SWModuleTranspiler >> stream [

	^ stream ifNil: [ stream := SWTranspilerStream new ]
]

{ #category : #accessing }
SWModuleTranspiler >> stream: anObject [

	stream := anObject
]

{ #category : #'public API' }
SWModuleTranspiler >> transpile [
	self payload
		stream: self stream;
		decode.
	self solveDependencies.
"
	self flag: #toRemove.
	self payload pool select: [ :each | self isToTranspile: each targetClass ] thenDo: [ :each |
		each
			stream: self stream;
			transpile
	].
"
	self payload transpile.

]

{ #category : #'code generation' }
SWModuleTranspiler >> transpile: aClass [
	|ct|
	ct := (self pool getClassTranspiler: aClass).
	ct isTranspiled ifFalse: [
		ct
			stream: self stream;
			transpile
	]

]
