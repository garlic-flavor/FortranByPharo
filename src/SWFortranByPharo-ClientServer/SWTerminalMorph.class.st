Class {
	#name : #SWTerminalMorph,
	#superclass : #StandardWindow,
	#instVars : [
		'outputMorph',
		'inputMorph',
		'reader',
		'writer'
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
		| [ :io |
			io >> [ :val |
				io << (Behavior evaluate: val) asString; done
			]
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

{ #category : #'open/close' }
SWTerminalMorph >> delete [

	reader close.
	writer close.
	super delete
]

{ #category : #initialization }
SWTerminalMorph >> initialize [
	super initialize.

	reader := SWPipe new.
	writer := SWPipe new
		>> [ :buf |
			outputMorph
				appendText: buf;
				appendText: String cr
		];
		yourself.

	outputMorph := (self newTextEditorFor: NewValueHolder new getText: #value setText: #value:)
		beReadOnly.
	inputMorph := (self newTextEditorFor: NewValueHolder new getText: #value setText: #value).
	inputMorph announcer when: RubReturnEntered send: #value: to: [ :ann | self onEnter. ann accepted: true ].
	self
		addMorph: outputMorph fullFrame:
			(LayoutFrame identity
				bottomFraction: 0.5;
				bottomOffset: 45);
		addMorph: inputMorph fullFrame:
			(LayoutFrame identity
				topFraction: 0.5;
				topOffset: 45).
]

{ #category : #'as yet unclassified' }
SWTerminalMorph >> onEnter [
	|text|
	text := inputMorph text.
	outputMorph
		appendText: ' % ';
		appendText: text;
		appendText: String cr.
"
	writer writeStream
		<< ' % ';
		<< text;
		done.
"
	reader writeStream
		<< text;
		done.
	inputMorph setText: ''.
]

{ #category : #accessing }
SWTerminalMorph >> readStream [
	^ reader
]

{ #category : #writing }
SWTerminalMorph >> writeStream [
	^ writer
]
