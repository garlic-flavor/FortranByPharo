Class {
	#name : #SWTerminalMorph,
	#superclass : #StandardWindow,
	#instVars : [
		'outputMorph',
		'inputMorph',
		'reader',
		'writer',
		'errWriter'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'tests - execution' }
SWTerminalMorph class >> start [
	<script>
	|m|
	m := self new openInWorld.
	SWShell new
		< m;
		> m;
		| [ :stdin :stdout :stderr |
			[
				stdout << Behavior evaluate: stdin upToEnd
			] repeat
		];
		run.
	^ m

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
	self halt; flag: #toRemove.
	aProcess io
		outputStream: self inputStream;
		errStream: self errStream.
	self keyStream: aProcess io inputStream.

]

{ #category : #'as yet unclassified' }
SWTerminalMorph >> detach [
	self flag: #toRemove; halt.
	self keyStream: nil
]

{ #category : #accessing }
SWTerminalMorph >> errStream [
	self flag: #toRewrite; halt.
	^ err ifNil: [
		err := SWPipe new
			onEachLineDo: [:val | self putLine: val ];
			yourself
	]
]

{ #category : #execution }
SWTerminalMorph >> execute: command [
	|p|
	self flag: #toRewrite; halt.
	p := SWShell new.
	self attach: p.
	p execute: command.
	self detach.

]

{ #category : #private }
SWTerminalMorph >> getLastLine [
	|buf|
	self flag: #toRewrite; halt.
	buf := textMorph getText asString trimRight.
	buf := buf allButFirst: (buf findLastOccurrenceOfString: self class lineSep startingAt: 1).
	(buf beginsWith: self class prompt1) ifTrue: [ buf := buf allButFirst: self class prompt1 size ].
	^ buf
]

{ #category : #initialization }
SWTerminalMorph >> initialize [
	super initialize.

	outputMorph := (self newTextEditorFor: NewValueHolder new getText: #value setText: #value:)
		beReadOnly.
	inputMorph := (self newTextEditorFor: NewValueHolder new getText: #value setText: #value).
	inputMorph announcer when: RubReturnEntered send: #value to: [ self onEnter. false ].
	self
		addMorph: outputMorph fullFrame:
			(LayoutFrame identity
				bottomFraction: 0.5;
				bottomOffset: 45);
		addMorph: inputMorph fullFrame:
			(LayoutFrame identity
				topFraction: 0.5;
				topOffset: 45)

]

{ #category : #accessing }
SWTerminalMorph >> input: line [
	self flag: #toRewrite; halt.

	textMorph appendText: line.
	self onEnter.
	textMorph appendText: self class lineSep.


]

{ #category : #'instance creation' }
SWTerminalMorph >> inputStream [
	self flag: #toRewrite; halt.

	^ input ifNil: [
		input := SWPipe new
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
	self flag: #toRewrite; halt.

	^ key ifNil: [ key := self inputStream ]
]

{ #category : #'as yet unclassified' }
SWTerminalMorph >> keyStream: anObject [
	self flag: #toRewrite; halt.
	key := anObject
]

{ #category : #'as yet unclassified' }
SWTerminalMorph >> onEnter [
	self readStream fillLine.

]

{ #category : #api }
SWTerminalMorph >> putLine: line [
	self flag: #toRewrite; halt.
	textMorph
		appendText: line;
		appendText: self class lineSep

]

{ #category : #accessing }
SWTerminalMorph >> readStream [
	^ reader ifNil: [
		reader := SWTerminalMorphReader new
			morph: inputMorph;
			yourself
	]
]

{ #category : #writing }
SWTerminalMorph >> writeStream [
	^ writer ifNil: [
		writer := SWTerminalMorphWriter new
			morph: outputMorph;
			yourself ]
]
