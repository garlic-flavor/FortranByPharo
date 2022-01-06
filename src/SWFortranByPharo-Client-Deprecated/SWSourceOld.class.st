"
This corresponds to a file on server side.
"
Class {
	#name : #SWSourceOld,
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
	#category : #'SWFortranByPharo-Client-Deprecated-Client-Deprecated'
}

{ #category : #accessing }
SWSourceOld >> classes [

	^ classes
]

{ #category : #accessing }
SWSourceOld >> classes: anObject [

	classes := anObject
]

{ #category : #accessing }
SWSourceOld >> contents [

	^ contents ifNil: [
		self error: 'I need be set a contents.'
	]
]

{ #category : #accessing }
SWSourceOld >> contents: anObject [

	contents := anObject
]

{ #category : #accessing }
SWSourceOld >> contentsHash [

	^ contentsHash ifNil: [
		contentsHash := (SHA256 hashMessage: self contents) hex
	]
]

{ #category : #accessing }
SWSourceOld >> contentsHash: anObject [

	contentsHash := anObject
]

{ #category : #accessing }
SWSourceOld >> dirName [
	^  'cache'

]

{ #category : #accessing }
SWSourceOld >> filename [

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
SWSourceOld >> filename: anObject [

	filename := anObject
]

{ #category : #accessing }
SWSourceOld >> firstClass [
	^ firstClass ifNil: [
		firstClass := self programClass ifNil: [ self classes first ]
	]
]

{ #category : #accessing }
SWSourceOld >> firstClass: anObject [
	firstClass := anObject
]

{ #category : #accessing }
SWSourceOld >> moduleName [
	^ moduleName ifNil: [
		moduleName := (self firstClass respondsTo: #moduleName) ifTrue: [
			self firstClass moduleName
		] ifFalse: [
			self firstClass name
		]
	]

]

{ #category : #accessing }
SWSourceOld >> moduleName: anObject [

	moduleName := anObject
]

{ #category : #accessing }
SWSourceOld >> programClass [

	^ programClass ifNil: [
		programClass := self classes detect: [ :aClass |
			aClass respondsTo: #program
		] ifFound: [ :aClass | aClass ] ifNone: [ nil ]
	]
]

{ #category : #accessing }
SWSourceOld >> type [

	^ type
]

{ #category : #accessing }
SWSourceOld >> type: anObject [

	type := anObject
]
