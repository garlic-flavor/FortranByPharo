Class {
	#name : #SWTerminalMorphtoRemove,
	#superclass : #StandardWindow,
	#instVars : [
		'outputMorph',
		'inputMorph',
		'leftMostPipe',
		'rightMostPipe',
		'errPipe',
		'io'
	],
	#category : #'SWFortranByPharo-ClientServer-toRemove'
}

{ #category : #'tests - execution' }
SWTerminalMorphtoRemove class >> start [

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
SWTerminalMorphtoRemove class >> startThenInspect [
	<script>
	self new
		openInWorld;
		inspect
]

{ #category : #accessing }
SWTerminalMorphtoRemove >> contents [

	^ outputMorph text
]

{ #category : #'private - creation' }
SWTerminalMorphtoRemove >> createOutputPipe [
	^ SWPipetoRemove new
		>> [ :txt |
			outputMorph
				appendText: txt;
				appendText: String cr.
		];
		yourself
]

{ #category : #'open/close' }
SWTerminalMorphtoRemove >> delete [

	leftMostPipe ifNotNil: [ leftMostPipe close ].
	rightMostPipe ifNotNil: [ rightMostPipe close ].
	super delete
]

{ #category : #enumerating }
SWTerminalMorphtoRemove >> do: aBlock [

	^ aBlock value: self io clone
	


]

{ #category : #accessing }
SWTerminalMorphtoRemove >> errPipe [

	^ errPipe ifNil: [ errPipe := self createOutputPipe ]
]

{ #category : #accessing }
SWTerminalMorphtoRemove >> errPipe: anObject [

	errPipe := anObject
]

{ #category : #initialization }
SWTerminalMorphtoRemove >> initialize [
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
SWTerminalMorphtoRemove >> input: aText [

	inputMorph setText: aText.
	self onEnter.

]

{ #category : #accessing }
SWTerminalMorphtoRemove >> io [

	^ io ifNil: [
		io := SWIO new
			in: self leftMostPipe readStream;
			out: self rightMostPipe writeStream;
			err: self errPipe writeStream;
			yourself
	]
]

{ #category : #accessing }
SWTerminalMorphtoRemove >> io: anObject [

	io := anObject
]

{ #category : #accessing }
SWTerminalMorphtoRemove >> leftMostPipe [

	^ leftMostPipe ifNil: [
		leftMostPipe := SWPipetoRemove new
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
SWTerminalMorphtoRemove >> leftMostPipe: anObject [

	leftMostPipe := anObject
]

{ #category : #'as yet unclassified' }
SWTerminalMorphtoRemove >> onEnter [
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
SWTerminalMorphtoRemove >> rightMostPipe [

	^ rightMostPipe ifNil: [	rightMostPipe := self createOutputPipe ]
]

{ #category : #accessing }
SWTerminalMorphtoRemove >> rightMostPipe: anObject [

	rightMostPipe := anObject
]
