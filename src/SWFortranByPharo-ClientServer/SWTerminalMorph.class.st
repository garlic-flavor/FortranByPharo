"
A test implementation of shell like something.
"
Class {
	#name : #SWTerminalMorph,
	#superclass : #StandardWindow,
	#instVars : [
		'outputMorph',
		'inputMorph',
		'leftMostPipe',
		'rightMostPipe',
		'errPipe'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'tests - execution' }
SWTerminalMorph class >> start [

	<script>
	| m |
	m := self new openInWorld.
"
	m do: [ :std |
		std >> [ :val |
		std
			<< (Behavior compiler evaluate: val) asString;
			done ] ] | [ :std |
		std >> [ :val |
		std
			<< 'hoge! ';
			<< val;
			<< ' hoge!';
			done ] ].
"
	^ m
]

{ #category : #'tests - execution' }
SWTerminalMorph class >> startThenInspect [
	<script>
	self new
		openInWorld;
		inspect
]

{ #category : #accessing }
SWTerminalMorph >> contents [

	^ outputMorph text
]

{ #category : #'open/close' }
SWTerminalMorph >> delete [

	leftMostPipe ifNotNil: [
		leftMostPipe close.
		leftMostPipe := nil
	].

	rightMostPipe ifNotNil: [
		rightMostPipe close.
		rightMostPipe := nil
	].

	errPipe ifNotNil: [
		errPipe close.
		errPipe := nil
	].

	super delete
]

{ #category : #enumerating }
SWTerminalMorph >> do: aBlock [
	^ aBlock value: (SWIO new
		in: (SWWaitableStream newOn: self leftMostPipe stream);
		out: self rightMostPipe;
		err: self errPipe;
		yourself)



]

{ #category : #accessing }
SWTerminalMorph >> errPipe [

	^ errPipe ifNil: [
		errPipe := SWStreamListener newOnPipe
			callback: [ :txt |
				outputMorph
					appendText: txt;
					appendText: String cr
			];
			yourself
	]
]

{ #category : #accessing }
SWTerminalMorph >> errPipe: anObject [

	errPipe := anObject
]

{ #category : #initialization }
SWTerminalMorph >> initialize [
	super initialize.
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

{ #category : #accessing }
SWTerminalMorph >> input: aText [

	inputMorph setText: aText.
	self onEnter.

]

{ #category : #accessing }
SWTerminalMorph >> leftMostPipe [

	^ leftMostPipe ifNil: [
		leftMostPipe := SWStreamListener newOnPipe
			callback: [ :txt |
				self rightMostPipe
					nextPutAll: (Behavior evaluate: txt) asString;
					nextPut: SWStreamListener lineSep;
					flush
			];
			yourself
	]
]

{ #category : #accessing }
SWTerminalMorph >> leftMostPipe: anObject [

	leftMostPipe := anObject
]

{ #category : #'as yet unclassified' }
SWTerminalMorph >> onEnter [
	|text|

	text := inputMorph text.
 	outputMorph
		appendText: ' % ';
		appendText: text;
		appendText: String cr.
	(self leftMostPipe)
		nextPutAll: text;
		flush.
	inputMorph setText: ''.

]

{ #category : #accessing }
SWTerminalMorph >> rightMostPipe [

	^ rightMostPipe ifNil: [
		rightMostPipe := SWStreamListener newOnPipe
			callback: [ :txt |
				outputMorph appendText: txt
			];
			yourself
	]
]

{ #category : #accessing }
SWTerminalMorph >> rightMostPipe: anObject [

	rightMostPipe := anObject
]
