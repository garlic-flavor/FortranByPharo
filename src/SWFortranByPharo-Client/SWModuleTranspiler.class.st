"
I represent a module (equals to a file).
"
Class {
	#name : #SWModuleTranspiler,
	#superclass : #Object,
	#instVars : [
		'stream',
		'toTranspiles',
		'name',
		'filename'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #converting }
SWModuleTranspiler class >> asMetaclassOf: aClass [
	^ aClass class = Metaclass ifTrue: [ aClass ] ifFalse: [ aClass class ]
]

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
	^ self new
		<< (self mainProgramTranspilerFrom: aClass);
		name: (self asMetaclassOf: aClass) soleInstance name, 'Program';
		yourself
]

{ #category : #streaming }
SWModuleTranspiler >> << aTranspiler [
	self toTranspiles add: aTranspiler
]

{ #category : #accessing }
SWModuleTranspiler >> contents [
	^ self stream contents
]

{ #category : #accessing }
SWModuleTranspiler >> filename [
	^ filename ifNil: [ filename := 'cache/', self name, '/', self hash hex, '.', self class extension ]
]

{ #category : #comparing }
SWModuleTranspiler >> hash [
	|ws|
	ws := ReadWriteStream with: {}.
	self toTranspiles do: [ :each | ws << each hash ].
	ws reset.
	^ SHA256 hashStream: ws

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
SWModuleTranspiler >> stream [

	^ stream ifNil: [ stream := SWTranspilerStream new ]
]

{ #category : #accessing }
SWModuleTranspiler >> stream: anObject [

	stream := anObject
]

{ #category : #accessing }
SWModuleTranspiler >> toTranspiles [

	^ toTranspiles ifNil: [ toTranspiles := OrderedCollection new ]
]

{ #category : #accessing }
SWModuleTranspiler >> toTranspiles: anObject [

	toTranspiles := anObject
]

{ #category : #'public API' }
SWModuleTranspiler >> transpile [
	self toTranspiles do: [ :each |
		each
			stream: self stream;
			transpile
	]
]
