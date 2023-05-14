Class {
	#name : #SWTerminalMorph,
	#superclass : #StandardWindow,
	#instVars : [
		'outputMorph',
		'inputMorph',
		'reader',
		'writer',
		'std'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'tests - execution' }
SWTerminalMorph class >> start [
	<script>
	|m|
	m := self new openInWorld.
	m do: [ :std |
		std >> [ :val |
			std << (Behavior evaluate: val) asString; done
		]
	] | [ :std |
		std >> [ :val |
			std << 'hoge! '; << val; << ' hoge!'; done
		]
	].
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

	reader close.
	writer close.
	std ifNotNil: [ std close ].
	super delete
]

{ #category : #enumerating }
SWTerminalMorph >> do: aBlock [
	^ aBlock value: self std.

]

{ #category : #initialization }
SWTerminalMorph >> initialize [
	super initialize.

	reader := SWPipe new.
	writer := SWPipe new.
	writer >> [ :buf |
		outputMorph
			appendText: buf;
			appendText: String cr
	].

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

{ #category : #'as yet unclassified' }
SWTerminalMorph >> std [
	^ std ifNil: [ std := SWStd new
		in: reader readStream;
		out: writer writeStream;
		err: writer writeStream;
		yourself
	]
]

{ #category : #accessing }
SWTerminalMorph >> std: anObject [
	std := anObject
]

{ #category : #writing }
SWTerminalMorph >> writeStream [
	^ writer
]
