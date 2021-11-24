"
I transpile a method of Pharo class.
"
Class {
	#name : #SWMethodBodyTranspiler,
	#superclass : #SWStackAnalyzer,
	#instVars : [
		'stream',
		'type'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWMethodBodyTranspiler class >> analyzerClass [
	^ SWStackAnalyzer
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> << anObject [
	self stream log.
	anObject isString ifTrue: [
		self stream put: anObject
	] ifFalse: [
		anObject transpileUsing: self
	]
]

{ #category : #'public API' }
SWMethodBodyTranspiler >> logging: trueOrFalse [
	self stream logging: trueOrFalse
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putAssignTo: key with: value [
	self stream log: [ key asString, ' = ', value asString ].
	self
		<< key;
		<< ' = ';
		<< value

]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putInteger: anInteger [
	self stream log.
	self << anInteger asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putReturn: value [
	self stream log.
	^ self
		<< 'return ';
		<< value.
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariable: aVariableNode [
	self stream log: aVariableNode name.
	self << aVariableNode name
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream [

	^ stream ifNil: [ stream := SWTranspilerStream new ]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream: anObject [

	stream := anObject
]

{ #category : #'public API' }
SWMethodBodyTranspiler >> transpile [
	self decoded.
	self stream log.
	self method sourceNode body statements do: [ :each | each transpileUsing: self ].
	^ self stream contents
]

{ #category : #accessing }
SWMethodBodyTranspiler >> type [

	^ type
]

{ #category : #accessing }
SWMethodBodyTranspiler >> type: anObject [

	type := anObject
]
