"
I analyze Pharo code.
"
Class {
	#name : #SWAnalyzer,
	#superclass : #SWMethodInfo,
	#instVars : [
		'methods',
		'classes',
		'context',
		'codes'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'as yet unclassified' }
SWAnalyzer class >> artumentTypesOf: ctx [
	^ ctx method argumentNames collect: [ :n |
		SWVariableInfo new
			name: n;
			type: (ctx at: (ctx lookupVar: n) index) class;
			yourself
	]
]

{ #category : #accessing }
SWAnalyzer >> analyzer [
	^ self
]

{ #category : #accessing }
SWAnalyzer >> classes [

	^ classes
]

{ #category : #accessing }
SWAnalyzer >> classes: anObject [

	classes := anObject
]

{ #category : #accessing }
SWAnalyzer >> codes [

	^ codes ifNil: [ codes := SWStackAnalyzer decode: self method ]
]

{ #category : #accessing }
SWAnalyzer >> codes: anObject [

	codes := anObject
]

{ #category : #accessing }
SWAnalyzer >> context [

	^ context
]

{ #category : #accessing }
SWAnalyzer >> context: anObject [

	context := anObject
]

{ #category : #accessing }
SWAnalyzer >> go [
	[
		self step
	] whileTrue.

	self methods at: self mangledName put: self.

]

{ #category : #accessing }
SWAnalyzer >> method [
	^ method ifNil: [ method := self context method ]
]

{ #category : #accessing }
SWAnalyzer >> methods [

	^ methods ifNil: [ methods := Dictionary new ]
]

{ #category : #accessing }
SWAnalyzer >> methods: anObject [

	methods := anObject
]

{ #category : #'public API' }
SWAnalyzer >> receiver: aReceiver method: aMethod argiments: arguments [
	^ self
		method: aMethod;
		context: (Context sender: nil receiver: aReceiver method: aMethod arguments: arguments);
		go

]

{ #category : #accessing }
SWAnalyzer >> step [
	|code|
	code := self codes at: (self context pc - self context initialPC + 1).
	code description = #send ifTrue: [
		^ self subAnalyzer
			context: self context step;
			go
	].
	code description = #return ifTrue: [
		^ self returnValue: (SWVariableInfo new
			value: (self context at: (self context size));
			yourself)
	].
	code description = #write ifTrue: [
	].
	^ self context step = self context

]

{ #category : #'public API' }
SWAnalyzer >> subAnalyzer [
	^ self class new
		methods: self methods;
		yourself
]
