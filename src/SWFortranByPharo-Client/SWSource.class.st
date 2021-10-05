"
This corresponds to a file on server side.
"
Class {
	#name : #SWSource,
	#superclass : #Object,
	#instVars : [
		'classes',
		'mainClass',
		'entryClass',
		'type',
		'contents',
		'contentsHash',
		'filename',
		'moduleName'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #accessing }
SWSource >> classes [

	^ classes
]

{ #category : #accessing }
SWSource >> classes: anObject [

	classes := anObject
]

{ #category : #accessing }
SWSource >> contents [

	^ contents ifNil: [
		self error: 'I need be set a contents.'
	]
]

{ #category : #accessing }
SWSource >> contents: anObject [

	contents := anObject
]

{ #category : #accessing }
SWSource >> contentsHash [

	^ contentsHash ifNil: [
		contentsHash := (SHA256 hashMessage: self contents) hex
	]
]

{ #category : #accessing }
SWSource >> contentsHash: anObject [

	contentsHash := anObject
]

{ #category : #accessing }
SWSource >> dirName [
	^  'cache'

]

{ #category : #accessing }
SWSource >> entryClass [

	^ entryClass ifNil: [
		entryClass := self classes detect: [ :aClass |
			(aClass compiledMethodAt: #main: ifAbsent: [ nil ]) isNotNil
		] ifFound: [ :aClass | aClass ] ifNone: [ nil ]
	]
]

{ #category : #accessing }
SWSource >> entryClass: anObject [

	entryClass := anObject
]

{ #category : #accessing }
SWSource >> filename [

	^ filename ifNil: [
		filename := String streamContents: [:s |
			s
				<< self dirName; << '/';
				<< self moduleName; << '/';
				<< self contentsHash; << '.'; << self type
		]
	]
]

{ #category : #accessing }
SWSource >> filename: anObject [

	filename := anObject
]

{ #category : #accessing }
SWSource >> mainClass [
	^ mainClass ifNil: [
		mainClass := self entryClass ifNil: [ self classes last ]
	]
]

{ #category : #accessing }
SWSource >> mainClass: anObject [
	mainClass := anObject
]

{ #category : #accessing }
SWSource >> moduleName [
	^ moduleName ifNil: [
		moduleName := (self mainClass respondsTo: #moduleName) ifTrue: [
			self mainClass moduleName
		] ifFalse: [
			self mainClass name
		]
	]

]

{ #category : #accessing }
SWSource >> moduleName: anObject [

	moduleName := anObject
]

{ #category : #accessing }
SWSource >> type [

	^ type
]

{ #category : #accessing }
SWSource >> type: anObject [

	type := anObject
]
