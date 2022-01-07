"
I represent a project.
"
Class {
	#name : #SWProjectTranspiler,
	#superclass : #Object,
	#instVars : [
		'main',
		'modules',
		'newline'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
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

{ #category : #api }
SWProjectTranspiler >> decode [
	self modules do: [ :each | each decode ]
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

{ #category : #accessing }
SWProjectTranspiler >> newline [

	^ newline ifNil: [ newline := String crlf ]
]

{ #category : #accessing }
SWProjectTranspiler >> newline: anObject [

	newline := anObject.
	self modules do: [ :each | each stream newline: anObject ]
]

{ #category : #'as yet unclassified' }
SWProjectTranspiler >> solveDependencies [
	^ self main solveDependencies 
]

{ #category : #api }
SWProjectTranspiler >> transpile [
	self modules do: [ :each | each transpile ]
]
