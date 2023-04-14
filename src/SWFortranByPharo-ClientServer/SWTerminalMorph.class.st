Class {
	#name : #SWTerminalMorph,
	#superclass : #StandardWindow,
	#instVars : [
		'textMorph',
		'input',
		'err'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #accessing }
SWTerminalMorph class >> lineSep [
	^ String cr
]

{ #category : #accessing }
SWTerminalMorph class >> prompt1 [
	^ ' % '
]

{ #category : #'tests - execution' }
SWTerminalMorph class >> start [
	<script>
	self new openInWorld

]

{ #category : #'tests - execution' }
SWTerminalMorph class >> startThenInspect [
	<script>
	self new
		openInWorld;
		inspect
]

{ #category : #accessing }
SWTerminalMorph >> errStream [
	^ err ifNil: [
		err := SWStream new
			>> [:val | self putLine: val ];
			yourself
	]
]

{ #category : #private }
SWTerminalMorph >> getLastLine [
	|buf|
	buf := textMorph getText asString trimRight.
	buf := buf allButFirst: (buf findLastOccurrenceOfString: self class lineSep startingAt: 1).
	(buf beginsWith: self class prompt1) ifTrue: [ buf := buf allButFirst: self class prompt1 size ].
	^ buf
]

{ #category : #initialization }
SWTerminalMorph >> initialize [
	super initialize.
	textMorph := self newTextEditorFor: NewValueHolder new getText: #value setText: #value:.
	textMorph announcer when: RubReturnEntered send: #value to: [ self onEnter. false ].
	self addMorph: textMorph fullFrame: (LayoutFrame identity).
	self putPrompt1.
]

{ #category : #'instance creation' }
SWTerminalMorph >> inputStream [
	^ input ifNil: [
		input := SWStream new
			>> [ :val | self putLine: val ];
			yourself
	]

]

{ #category : #'instance creation' }
SWTerminalMorph >> newIO [
	^ SWIO new
		inputStream: self inputStream;
		outputStream: self inputStream;
		errStream: self errStream;
		yourself
]

{ #category : #'as yet unclassified' }
SWTerminalMorph >> onEnter [
	[
		self inputStream << (Behavior evaluate: self getLastLine) asString.
		self putPrompt1
	] fork

]

{ #category : #api }
SWTerminalMorph >> putLine: line [
	textMorph
		appendText: line;
		appendText: self class lineSep

]

{ #category : #private }
SWTerminalMorph >> putPrompt1 [
	textMorph appendText: self class prompt1
]
