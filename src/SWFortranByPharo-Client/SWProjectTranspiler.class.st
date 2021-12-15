"
I represent a project.
"
Class {
	#name : #SWProjectTranspiler,
	#superclass : #Object,
	#instVars : [
		'main',
		'modules'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #protected }
SWProjectTranspiler class >> mainModuleFrom: aClass [
	^ self subclassResponsibility 
]

{ #category : #'instance creation' }
SWProjectTranspiler class >> newFrom: aClass [
	^ self new
		main: (self mainModuleFrom: aClass);
		yourself
]

{ #category : #accessing }
SWProjectTranspiler >> main [

	^ main
]

{ #category : #accessing }
SWProjectTranspiler >> main: anObject [

	main := anObject.
	self modules add: anObject.
]

{ #category : #accessing }
SWProjectTranspiler >> modules [

	^ modules ifNil: [ modules := OrderedCollection new ]
]

{ #category : #accessing }
SWProjectTranspiler >> modules: anObject [

	modules := anObject
]

{ #category : #'as yet unclassified' }
SWProjectTranspiler >> solveDependencies [
	|pool|
	self main ready.
	pool := self main pool.
	pool select: [ :ci | ci isToTranspile ] thenDo: [ :ci |
		self halt.
	].

]

{ #category : #'public API' }
SWProjectTranspiler >> transpile [
	self modules do: [ :each | each transpile ]
]
