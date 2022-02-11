"
I represent a module (equals to a file).
"
Class {
	#name : #SWModuleTranspiler,
	#superclass : #Object,
	#instVars : [
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
	self payload isDecoded ifFalse: [ self transpile ].
	^ self stream contents
]

{ #category : #'public API' }
SWModuleTranspiler >> decode: aSelector with: args [

	^ self pool newSenderOf: aSelector super: false with: (SWSlot newFrom: args)
]

{ #category : #accessing }
SWModuleTranspiler >> filename [
	^ String streamContents: [ :s | self payload putFilenameOn: s ]
]

{ #category : #accessing }
SWModuleTranspiler >> haltAt: sender [
	self payload haltAt: sender
]

{ #category : #'public API' }
SWModuleTranspiler >> import: anArray from: basename [
	self payload
		putImport: anArray from: basename;
		putStatementDelimiter;
		cr
]

{ #category : #accessing }
SWModuleTranspiler >> logger [
	^ self payload logger
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

{ #category : #private }
SWModuleTranspiler >> solveDependencies [
	|solver tClass|
	solver := #solveDependenciesUsing:.
	tClass := self payload receiverClass instanceSide.
	(tClass respondsTo: solver) ifTrue: [
		tClass perform: solver with: self
	].

	self transpile: tClass.
"
	self pool detect: [ :each | each targetClass = tClass ] ifFound: [ :t |
		self transpile: tClass.
	]"
]

{ #category : #accessing }
SWModuleTranspiler >> stream [
	^ self payload stream
]

{ #category : #'public API' }
SWModuleTranspiler >> transpile [
	self pool addInitializerIn: self payload receiverClass.
	self payload decode.
	self solveDependencies.
	self payload transpile.

]

{ #category : #'public API' }
SWModuleTranspiler >> transpile: aClass [
	|ct solver|
	ct := (self payload pool getClassTranspiler: aClass instanceSide).
	ct isTranspiled ifTrue: [ ^ self ].
	ct markAsTranspiled.
	solver := #solveDependenciesUsing:.
	(aClass instanceSide respondsTo: solver) ifTrue: [
		aClass perform: solver with: self
	].
	ct transpile.

]
