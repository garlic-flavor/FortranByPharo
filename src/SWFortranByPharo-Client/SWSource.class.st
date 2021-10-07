"
This corresponds to a file on server side.
"
Class {
	#name : #SWSource,
	#superclass : #Object,
	#instVars : [
		'classes',
		'firstClass',
		'programClass',
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
SWSource >> firstClass [
	^ firstClass ifNil: [
		firstClass := self programClass ifNil: [ self classes first ]
	]
]

{ #category : #accessing }
SWSource >> firstClass: anObject [
	firstClass := anObject
]

{ #category : #accessing }
SWSource >> moduleName [
	^ moduleName ifNil: [
		moduleName := (self firstClass respondsTo: #moduleName) ifTrue: [
			self firstClass moduleName
		] ifFalse: [
			self firstClass name
		]
	]

]

{ #category : #accessing }
SWSource >> moduleName: anObject [

	moduleName := anObject
]

{ #category : #accessing }
SWSource >> programClass [

	^ programClass ifNil: [
		programClass := self classes detect: [ :aClass |
			aClass respondsTo: #program
		] ifFound: [ :aClass | aClass ] ifNone: [ nil ]
	]
]

{ #category : #accessing }
SWSource >> type [

	^ type
]

{ #category : #accessing }
SWSource >> type: anObject [

	type := anObject
]
