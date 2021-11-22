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
	#category : #'SWFortranByPharo-Client-Transpiler'
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

{ #category : #'private - accessing' }
SWTranspilerStream >> indent [

	^ indent ifNil: [ indent := 0 ]
]

{ #category : #'private - accessing' }
SWTranspilerStream >> indent: anObject [

	indent := anObject
]

{ #category : #'private - accessing' }
SWTranspilerStream >> isNewline [

	^ isNewline ifNil: [ isNewline := false ]
]

{ #category : #'private - accessing' }
SWTranspilerStream >> isNewline: anObject [

	isNewline := anObject
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

{ #category : #'private - accessing' }
SWTranspilerStream >> newline [

	^ newline ifNil: [ newline := String crlf ]
]

{ #category : #'private - accessing' }
SWTranspilerStream >> newline: anObject [

	newline := anObject
]

{ #category : #'private - accessing' }
SWTranspilerStream >> payload [

	^ payload ifNil: [ payload := String new writeStream ]
]

{ #category : #'private - accessing' }
SWTranspilerStream >> payload: anObject [

	payload := anObject
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

{ #category : #accessing }
SWTranspilerStream >> tabWidth [

	^ tabWidth
]

{ #category : #accessing }
SWTranspilerStream >> tabWidth: anObject [

	tabWidth := anObject
]
