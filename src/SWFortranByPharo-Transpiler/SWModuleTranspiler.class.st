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
SWModuleTranspiler >> basename [
	^ String streamContents: [ :s | self payload putBasenameOn: s ]
]

{ #category : #accessing }
SWModuleTranspiler >> contents [
	self payload isDecoded ifFalse: [ self transpile ].
	^ self stream contents
]

{ #category : #'public API' }
SWModuleTranspiler >> decode: aSelector with: args [

	^ self pool newSenderOf: aSelector super: false with: (SWSlotOld newFrom: args)
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
	self solveDependencies: self payload receiverClass

]

{ #category : #private }
SWModuleTranspiler >> solveDependencies: aClass [
	|tClass solver|
	solver := #solveDependenciesUsing:.
	tClass := aClass instanceSide.
	(tClass respondsTo: solver) ifTrue: [
		tClass perform: solver with: self
	]
]

{ #category : #accessing }
SWModuleTranspiler >> stream [
	^ self payload stream
]

{ #category : #'public API' }
SWModuleTranspiler >> transpile [
	self pool addInitializerIn: self payload receiverClass.
	self payload decode.
	self transpile: self payload receiverClass.
	self transpilePayload

]

{ #category : #'public API' }
SWModuleTranspiler >> transpile: aClass [
	|ct|
	ct := (self payload pool getClassDispatcher: aClass instanceSide).
	ct isTranspiled ifTrue: [ ^ self ].
	ct markAsTranspiled.
	self solveDependencies: aClass.
	ct transpile.

]

{ #category : #'as yet unclassified' }
SWModuleTranspiler >> transpilePayload [
	self payload transpile
]
