"
I'm a stream for transpilers.
"
Class {
	#name : #SWTranspilerStream,
	#superclass : #Object,
	#instVars : [
		'payload',
		'logger',
		'tabWidth',
		'indent',
		'isNewline',
		'newline',
		'preventNewline'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #accessing }
SWTranspilerStream >> contents [
	^ payload contents
]

{ #category : #api }
SWTranspilerStream >> decIndent [
	indent := indent - 1.
	indent < 0 ifTrue: [ self error: 'Indentation clauses mismatch.' ]
]

{ #category : #api }
SWTranspilerStream >> incIndent [
	indent := indent + 1.
]

{ #category : #initialization }
SWTranspilerStream >> initialize [
	super initialize.
	payload := String new writeStream.
	indent := 0.
	isNewline := false.
	preventNewline := false.
]

{ #category : #api }
SWTranspilerStream >> log [
	self logger log: '' withContext: thisContext sender
]

{ #category : #api }
SWTranspilerStream >> log: msg [
	self logger log: msg withContext: thisContext sender
]

{ #category : #accessing }
SWTranspilerStream >> logger [

	^ logger ifNil: [ logger := SWLogger new ]
]

{ #category : #accessing }
SWTranspilerStream >> logger: anObject [

	logger := anObject
]

{ #category : #api }
SWTranspilerStream >> logging: trueOrFalse [
	self logger enabled: trueOrFalse
]

{ #category : #accessing }
SWTranspilerStream >> newline [

	^ newline ifNil: [ newline := String crlf ]
]

{ #category : #accessing }
SWTranspilerStream >> newline: anObject [

	newline := anObject
]

{ #category : #api }
SWTranspilerStream >> preventNewline [
	preventNewline := true
]

{ #category : #api }
SWTranspilerStream >> put: code [
	self logger log: code.
	self putIndent.
	payload nextPutAll: code.
]

{ #category : #private }
SWTranspilerStream >> putIndent [
	isNewline ifFalse: [ ^ self ].
	payload nextPutAll: (' ' repeat: {0. (self tabWidth * indent)} max).
	isNewline := false.

]

{ #category : #api }
SWTranspilerStream >> putLine [
	preventNewline
		ifTrue: [ preventNewline := false ]
		ifFalse: [
			payload << self newline.
			isNewline := true.
		].

]

{ #category : #api }
SWTranspilerStream >> putLine: code [
	self put: code.
	self putLine.

]

{ #category : #accessing }
SWTranspilerStream >> tabWidth [

	^ tabWidth ifNil: [ tabWidth := 4 ]
]

{ #category : #accessing }
SWTranspilerStream >> tabWidth: anObject [

	tabWidth := anObject
]
