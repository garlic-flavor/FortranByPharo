Class {
	#name : #SWTerminalMorph,
	#superclass : #StandardWindow,
	#instVars : [
		'outputMorph',
		'inputMorph',
		'leftMostPipe',
		'rightMostPipe',
		'errPipe',
		'io'
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

{ #category : #'private - creation' }
SWTerminalMorph >> createOutputPipe [
	^ SWPipe new
		>> [ :txt |
			outputMorph
				appendText: txt;
				appendText: String cr.
		];
		yourself
]

{ #category : #'open/close' }
SWTerminalMorph >> delete [

	leftMostPipe ifNotNil: [ leftMostPipe close ].
	rightMostPipe ifNotNil: [ rightMostPipe close ].
	super delete
]

{ #category : #enumerating }
SWTerminalMorph >> do: aBlock [

	^ aBlock value: self io clone
	


]

{ #category : #accessing }
SWTerminalMorph >> errPipe [

	^ errPipe ifNil: [ errPipe := self createOutputPipe ]
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
SWTerminalMorph >> io [

	^ io ifNil: [
		io := SWIO new
			in: self leftMostPipe readStream;
			out: self rightMostPipe writeStream;
			err: self errPipe writeStream;
			yourself
	]
]

{ #category : #accessing }
SWTerminalMorph >> io: anObject [

	io := anObject
]

{ #category : #accessing }
SWTerminalMorph >> leftMostPipe [

	^ leftMostPipe ifNil: [
		leftMostPipe := SWPipe new
			>> [ :txt |
				(self rightMostPipe)
					nextPutAll: ([Behavior compiler evaluate: txt] on: CodeError do: [ nil ]) asString;
					done;
					waitReady
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
	inputMorph setText: ''.
 	outputMorph
		appendText: ' % ';
		appendText: text;
		appendText: String cr.
	(self leftMostPipe)
		<< text;
		done.

]

{ #category : #accessing }
SWTerminalMorph >> rightMostPipe [

	^ rightMostPipe ifNil: [	rightMostPipe := self createOutputPipe ]
]

{ #category : #accessing }
SWTerminalMorph >> rightMostPipe: anObject [

	rightMostPipe := anObject
]
