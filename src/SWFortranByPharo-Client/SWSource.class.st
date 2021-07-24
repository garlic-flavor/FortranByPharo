"
This corresponds to a file on server side.
"
Class {
	#name : #SWSource,
	#superclass : #Object,
	#instVars : [
		'classes',
		'type',
		'transpiler',
		'contents',
		'contentsHash',
		'filename'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #accessing }
SWSource >> classes [

	^ classes ifNil: [ classes := OrderedCollection new ]
]

{ #category : #accessing }
SWSource >> classes: anObject [

	classes := anObject
]

{ #category : #accessing }
SWSource >> contents [

	^ contents ifNil: [
		contents := self transpiler transpile contents.
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
	self type = #f90 ifTrue: [ ^ 'src' ].
	self type = #rb ifTrue: [ ^ 'script' ].
	self error: 'NO IMPLEMENTAION.'.
]

{ #category : #accessing }
SWSource >> filename [

	^ filename ifNil: [
		filename := String streamContents: [:s |
			s
				<< self dirName; << '/';
				<< self programName; << '/';
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
	^ self transpiler mainClass
]

{ #category : #accessing }
SWSource >> programName [
	^ self transpiler programName
]

{ #category : #accessing }
SWSource >> putTo: client [
	|res|
	res := client put: self filename contents: self contents.
	self assert: [ res at: #success ].
	^ res
]

{ #category : #accessing }
SWSource >> transpiler [

	^ transpiler ifNil: [
		transpiler := (self transpilerClass new) classes: self classes yourself
	]
]

{ #category : #accessing }
SWSource >> transpiler: anObject [

	transpiler := anObject
]

{ #category : #accessing }
SWSource >> transpilerClass [ 
	self type = #f90 ifTrue: [ ^ SWTranspilerOfFortran ].
	self type = #rb ifTrue: [ ^ SWTranspilerOfRuby ].
	self error: 'NO IMPLEMENTATION!'.
]

{ #category : #accessing }
SWSource >> type [

	^ type
]

{ #category : #accessing }
SWSource >> type: anObject [

	type := anObject
]
