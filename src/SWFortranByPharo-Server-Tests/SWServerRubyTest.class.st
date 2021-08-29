Class {
	#name : #SWServerRubyTest,
	#superclass : #TestCase,
	#classVars : [
		'source'
	],
	#category : #'SWFortranByPharo-Server-Tests-Server'
}

{ #category : #accessing }
SWServerRubyTest class >> put [
	<sampleInstance>
	SWServer start.
	^ [ |client|
		client := SWClient new.
		self source putTo: client.
		client close.
		self source
	] ensure: [
		SWServer stop.
	]
]

{ #category : #initialization }
SWServerRubyTest class >> reset [
	<script>
	source := nil
]

{ #category : #accessing }
SWServerRubyTest class >> source [
	^ source ifNil: [
		source := SWSource new
			classes: { SWServer };
			type: #rb;
			yourself.
	]
]

{ #category : #'code generation' }
SWServerRubyTest class >> transpile [
	<sampleInstance>
	self reset.
	^ self source contents
]
