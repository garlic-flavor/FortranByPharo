"
I represent a module (equals to a file).
"
Class {
	#name : #SWModuleTranspiler,
	#superclass : #Object,
	#instVars : [
		'stream',
		'payload',
		'name',
		'filename'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
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
		name: aClass instanceSide name, 'Program';
		yourself
]

{ #category : #accessing }
SWModuleTranspiler >> contents [
	^ self stream contents
]

{ #category : #accessing }
SWModuleTranspiler >> filename [
	^ filename ifNil: [ filename := 'cache/', self name, '/', self sourceHash hex, '.', self class extension ]
]

{ #category : #accessing }
SWModuleTranspiler >> name [

	^ name
]

{ #category : #accessing }
SWModuleTranspiler >> name: anObject [

	name := anObject
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

{ #category : #'public API' }
SWModuleTranspiler >> ready [
	^ self payload ready

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
	self payload
		stream: self stream;
		transpile

]
