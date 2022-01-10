"
I represent a module (equals to a file).
"
Class {
	#name : #SWModuleTranspiler,
	#superclass : #Object,
	#instVars : [
		'stream',
		'payload',
		'contents'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #constants }
SWModuleTranspiler class >> extension [
	^ self subclassResponsibility 
]

{ #category : #generators }
SWModuleTranspiler class >> mainProgramTranspilerFrom: aClass [
	^ self subclassResponsibility 
]

{ #category : #'instance creation' }
SWModuleTranspiler class >> newMainProgramFrom: aClass [
	^ (self new)
		payload: (self mainProgramTranspilerFrom: aClass);
		yourself
]

{ #category : #accessing }
SWModuleTranspiler >> contents [
	^ contents ifNil: [
		self transpile.
		contents := self stream contents
	]
]

{ #category : #accessing }
SWModuleTranspiler >> filename [
	^ self payload filename
]

{ #category : #accessing }
SWModuleTranspiler >> payload [

	^ payload
]

{ #category : #accessing }
SWModuleTranspiler >> payload: anObject [

	payload := anObject
]

{ #category : #'as yet unclassified' }
SWModuleTranspiler >> solveDependencies [
	self error; flag: #toRemove.
	self payload decode.
	self payload decodeAllOf: [ :mi |
		mi classInfo isToTranspile
	].
	^ self payload pool

]

{ #category : #comparing }
SWModuleTranspiler >> sourceHash [

	^ self payload sourceHash
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
	self payload decode.

	self payload pool select: [ :each | each isToTranspile ] thenDo: [ :each |
		each
			stream: self stream;
			transpile
	].

	self payload
		stream: self stream;
		transpile

]