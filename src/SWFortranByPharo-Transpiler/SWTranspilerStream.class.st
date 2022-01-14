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
		'delimiter',
		'preventNewline',
		'preventDelimiter',
		'firstLineHeaderOfComment',
		'middleLineHeaderOfComment',
		'lastLineOfComment',
		'singleLineHeaderOfComment'
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

{ #category : #accessing }
SWTranspilerStream >> delimiter [

	^ delimiter ifNil: [ delimiter := ';' ]
]

{ #category : #accessing }
SWTranspilerStream >> delimiter: anObject [

	delimiter := anObject
]

{ #category : #accessing }
SWTranspilerStream >> firstLineHeaderOfComment [

	^ firstLineHeaderOfComment ifNil: [ firstLineHeaderOfComment := '/** ' ]
]

{ #category : #accessing }
SWTranspilerStream >> firstLineHeaderOfComment: anObject [

	firstLineHeaderOfComment := anObject
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

{ #category : #accessing }
SWTranspilerStream >> lastLineOfComment [

	^ lastLineOfComment ifNil: [ lastLineOfComment := ' */' ]
]

{ #category : #accessing }
SWTranspilerStream >> lastLineOfComment: anObject [

	lastLineOfComment := anObject
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
SWTranspilerStream >> middleLineHeaderOfComment [

	^ middleLineHeaderOfComment ifNil: [ middleLineHeaderOfComment := ' * ' ]
]

{ #category : #accessing }
SWTranspilerStream >> middleLineHeaderOfComment: anObject [

	middleLineHeaderOfComment := anObject
]

{ #category : #accessing }
SWTranspilerStream >> newline [

	^ newline ifNil: [ newline := String crlf ]
]

{ #category : #accessing }
SWTranspilerStream >> newline: anObject [

	newline := anObject
]

{ #category : #accessing }
SWTranspilerStream >> preventDelimiter [
	preventDelimiter := true
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

{ #category : #'code generation' }
SWTranspilerStream >> putComment: aComment [

	aComment ifNil: [ ^ self ].
	aComment lineIndicesDo: [ :start :end :endWithDelimiter |
		start = 1 ifTrue: [
			aComment size = endWithDelimiter ifTrue: [
				self put: self singleLineHeaderOfComment; putLine: aComment.
				^ self
			].
			self put: self firstLineHeaderOfComment
		] ifFalse: [
			self put: self middleLineHeaderOfComment
		].
		self putLine: (aComment copyFrom: start to: end).
		aComment size = endWithDelimiter ifTrue: [
			self lastLineOfComment isEmptyOrNil ifFalse: [
				self putLine: self lastLineOfComment
			]
		]
	]
]

{ #category : #'as yet unclassified' }
SWTranspilerStream >> putDelimiter [
	preventDelimiter ifNotNil: [
		preventDelimiter := nil
	] ifNil: [
		payload << self delimiter
	]
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
SWTranspilerStream >> singleLineHeaderOfComment [

	^ singleLineHeaderOfComment ifNil: [ singleLineHeaderOfComment := '/// ' ]
]

{ #category : #accessing }
SWTranspilerStream >> singleLineHeaderOfComment: anObject [

	singleLineHeaderOfComment := anObject
]

{ #category : #accessing }
SWTranspilerStream >> tabWidth [

	^ tabWidth ifNil: [ tabWidth := 4 ]
]

{ #category : #accessing }
SWTranspilerStream >> tabWidth: anObject [

	tabWidth := anObject
]
