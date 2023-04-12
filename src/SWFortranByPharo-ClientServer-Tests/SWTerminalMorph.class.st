Class {
	#name : #SWTerminalMorph,
	#superclass : #StandardWindow,
	#instVars : [
		'textMorph',
		'io'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests'
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
SWTerminalMorph >> io [

	^ io ifNil: [ self io: SWIO newSelfSupplied ]
]

{ #category : #accessing }
SWTerminalMorph >> io: anObject [

	io := anObject.
	io toRightStream >> [ :val |
		textMorph
			appendText: val;
			appendText: self class lineSep
	].
	io errStream >> [ :val |
		textMorph
			appendText: val;
			appendText: self class lineSep
	].
	
	^ io
]

{ #category : #'as yet unclassified' }
SWTerminalMorph >> onEnter [
	|res|
	res := Behavior evaluate: self getLastLine.
	[
		self io toLeftStream << res asString.
		self putPrompt1
	] fork

]

{ #category : #private }
SWTerminalMorph >> putPrompt1 [
	textMorph appendText: self class prompt1
]
