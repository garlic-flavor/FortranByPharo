Class {
	#name : #SWTerminalMorph,
	#superclass : #StandardWindow,
	#instVars : [
		'textMorph'
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

{ #category : #'private - accessing' }
SWTerminalMorph >> getLastLine [
	|buf|
	buf := textMorph getText trimRight.
	buf := buf allButFirst: (buf findLastOccurrenceOfString: self class lineSep startingAt: 1).
	(buf beginsWith: self class prompt1) ifTrue: [ buf := buf allButFirst: self class prompt1 length ].
	^ buf
]

{ #category : #initialization }
SWTerminalMorph >> initialize [
	super initialize.
	textMorph := self newTextEditorFor: NewValueHolder new getText: #value setText: #value:.
	textMorph announcer when: RubReturnEntered send: #value to: [
		Transcript show: textMorph getText; cr
	].
	self addMorph: textMorph fullFrame: (LayoutFrame identity).

	
]
