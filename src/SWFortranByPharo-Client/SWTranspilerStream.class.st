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

	indent := indent + 1
]

{ #category : #initialization }
SWTranspilerStream >> initialize [

	super initialize.
	payload := String new writeStream.
	indent := 0.
	isNewline := false.
	preventNewline := false
]

{ #category : #api }
SWTranspilerStream >> log [

	self logger log: '' withContext: thisContext sender
]

{ #category : #api }
SWTranspilerStream >> log: arg1 [

	self logger log: arg1 withContext: thisContext sender
]

{ #category : #accessing }
SWTranspilerStream >> logger [

	^ logger ifNil: [ logger := SWLogger new ] ifNotNil: [ logger ]
]

{ #category : #accessing }
SWTranspilerStream >> logger: arg1 [

	logger := arg1
]

{ #category : #api }
SWTranspilerStream >> logging: arg1 [

	self logger enabled: arg1
]

{ #category : #accessing }
SWTranspilerStream >> newline [

	^ newline ifNil: [ newline := String crlf ] ifNotNil: [ newline ]
]

{ #category : #accessing }
SWTranspilerStream >> newline: arg1 [

	newline := arg1
]

{ #category : #api }
SWTranspilerStream >> preventNewline [

	preventNewline := true
]

{ #category : #api }
SWTranspilerStream >> put: arg1 [

	self logger log: arg1.
	self putIndent.
	payload nextPutAll: arg1
]

{ #category : #private }
SWTranspilerStream >> putIndent [

	isNewline ifFalse: [ ^ self ].
	payload nextPutAll: (' ' repeat: { 
				 0.
				 (self tabWidth * indent) } max).
	isNewline := false
]

{ #category : #api }
SWTranspilerStream >> putLine [

	preventNewline
		ifTrue: [ preventNewline := false ]
		ifFalse: [ 
			payload << self newline.
			isNewline := true ]
]

{ #category : #api }
SWTranspilerStream >> putLine: arg1 [

	self
		put: arg1;
		putLine
]

{ #category : #accessing }
SWTranspilerStream >> tabWidth [

	^ tabWidth ifNil: [ tabWidth := 4 ] ifNotNil: [ tabWidth ]
]

{ #category : #accessing }
SWTranspilerStream >> tabWidth: arg1 [

	tabWidth := arg1
]
