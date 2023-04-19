Class {
	#name : #SWTerminalMorph,
	#superclass : #StandardWindow,
	#instVars : [
		'textMorph',
		'input',
		'key',
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
	^ self new openInWorld

]

{ #category : #'tests - execution' }
SWTerminalMorph class >> startThenInspect [
	<script>
	self new
		openInWorld;
		inspect
]

{ #category : #running }
SWTerminalMorph >> attach: aProcess [
	aProcess io
		outputStream: self inputStream;
		errStream: self errStream.
	self keyStream: aProcess io inputStream.

]

{ #category : #'as yet unclassified' }
SWTerminalMorph >> detach [
	self keyStream: nil
]

{ #category : #accessing }
SWTerminalMorph >> errStream [
	^ err ifNil: [
		err := SWStream new
			onEachLineDo: [:val | self putLine: val ];
			yourself
	]
]

{ #category : #execution }
SWTerminalMorph >> execute: command [
	|p|
	p := SWShellProcess new.
	self attach: p.
	p execute: command.
	self detach.

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

{ #category : #accessing }
SWTerminalMorph >> input: line [
	textMorph appendText: line.
	self onEnter.
	textMorph appendText: self class lineSep.


]

{ #category : #'instance creation' }
SWTerminalMorph >> inputStream [
	^ input ifNil: [
		input := SWStream new
			onEachLineDo: [ :val ||text|
				text := textMorph text.
				(text endsWith: self class prompt1) ifTrue: [
					textMorph setText: (text allButLast: (self class prompt1 size)).
				].
				self
					putLine: val;
					putPrompt1.
			];
			yourself
	]

]

{ #category : #'as yet unclassified' }
SWTerminalMorph >> keyStream [
	^ key ifNil: [ key := self inputStream ]
]

{ #category : #'as yet unclassified' }
SWTerminalMorph >> keyStream: anObject [
	key := anObject
]

{ #category : #'as yet unclassified' }
SWTerminalMorph >> onEnter [
	self keyStream << (Behavior evaluate: self getLastLine) asString.

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
