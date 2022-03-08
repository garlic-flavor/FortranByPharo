"
I'm a stream for transpilers.
"
Class {
	#name : #SWTranspilerStream,
	#superclass : #Object,
	#instVars : [
		'payload',
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
SWTranspilerStream >> append: stream [
	self payload nextPutAll: stream contents.
]

{ #category : #accessing }
SWTranspilerStream >> contents [
	^ self payload contents
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
	indent := 0.
	isNewline := false.
	preventNewline := false.
]

{ #category : #testing }
SWTranspilerStream >> isNotEmpty [
	self error; flag: #toRemove.
	^ payload isNotNil and: [ payload isEmpty not ]
]

{ #category : #accessing }
SWTranspilerStream >> lastLineOfComment [

	^ lastLineOfComment ifNil: [ lastLineOfComment := ' */' ]
]

{ #category : #accessing }
SWTranspilerStream >> lastLineOfComment: anObject [

	lastLineOfComment := anObject
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
SWTranspilerStream >> nextPutAll: val [
	self payload nextPutAll: val
]

{ #category : #accessing }
SWTranspilerStream >> payload [

	^ payload ifNil: [ payload := String new writeStream ]
]

{ #category : #accessing }
SWTranspilerStream >> payload: anObject [

	payload := anObject
]

{ #category : #api }
SWTranspilerStream >> preventDelimiter [
	preventDelimiter := true
]

{ #category : #api }
SWTranspilerStream >> preventNewline [
	preventNewline := true
]

{ #category : #api }
SWTranspilerStream >> put: code [
	self putIndent.
	self payload nextPutAll: code.
]

{ #category : #api }
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

{ #category : #api }
SWTranspilerStream >> putDelimiter [
	preventDelimiter ifNotNil: [
		preventDelimiter := nil
	] ifNil: [
		self payload << self delimiter
	]
]

{ #category : #private }
SWTranspilerStream >> putIndent [
	isNewline ifFalse: [ ^ self ].
	self payload nextPutAll: (' ' repeat: {0. (self tabWidth * indent)} max).
	isNewline := false.

]

{ #category : #api }
SWTranspilerStream >> putLine [
	preventNewline
		ifTrue: [ preventNewline := false ]
		ifFalse: [
			self payload << self newline.
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

{ #category : #'instance creation' }
SWTranspilerStream >> subStream [
	^ self copy
		payload: nil;
		yourself
]

{ #category : #accessing }
SWTranspilerStream >> tabWidth [

	^ tabWidth ifNil: [ tabWidth := 4 ]
]

{ #category : #accessing }
SWTranspilerStream >> tabWidth: anObject [

	tabWidth := anObject
]
