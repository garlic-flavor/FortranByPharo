Class {
	#name : #SWTerminalMorph,
	#superclass : #StandardWindow,
	#instVars : [
		'outputMorph',
		'inputMorph',
		'std',
		'commandSemaphore'
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

	commandSemaphore terminateProcess.
	self std close.
	super delete
]

{ #category : #enumerating }
SWTerminalMorph >> do: aBlock [
	self halt. self flag: #toRewrite.
	commandSemaphore critical: [
		^ aBlock value: self std.
	].


]

{ #category : #initialization }
SWTerminalMorph >> initialize [
	super initialize.
	commandSemaphore := Semaphore forMutualExclusion.
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

{ #category : #'as yet unclassified' }
SWTerminalMorph >> onEnter [
	|text|
	commandSemaphore wait.
	text := inputMorph text.
	outputMorph
		appendText: ' % ';
		appendText: text;
		appendText: String cr.
	(self std writeStream)
		<< text;
		done.
	inputMorph setText: ''.

]

{ #category : #'as yet unclassified' }
SWTerminalMorph >> std [
	^ std ifNil: [
		std := SWStd new.
		std readStream >> [ :txt |
			outputMorph
				appendText: txt;
				appendText: String cr.
			commandSemaphore signal.
		].
		std in: (SWPipeReader new
			>> [ :txt |
				(std out)
					nextPutAll: ([Behavior compiler evaluate: txt] on: CodeError do: [ nil ]) asString;
					done
			];
			yourself).
		std
	]
]

{ #category : #accessing }
SWTerminalMorph >> std: anObject [

	std := anObject
]
