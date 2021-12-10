"
I accumlate dependencies.
"
Class {
	#name : #SWStackAnalyzerToTranspile,
	#superclass : #SWStackAnalyzer,
	#instVars : [
		'dependencies'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'instance creation' }
SWStackAnalyzerToTranspile class >> new: selector types: types sendStack: ss [
	^ definedMethods at: selector ifPresent: [ :dm |
		dm value: selector value: types
	] ifAbsent: [|aMethod|
		aMethod := self search: selector in: types first.
		((self willTranspile: aMethod) ifTrue: [ self new ] ifFalse: [ SWStackAnalyzer new])
			method: aMethod;
			types: types;
			sendStack: ss;
			yourself
	]

]

{ #category : #testing }
SWStackAnalyzerToTranspile class >> willTranspile: aMethod [
	|target|
	target := aMethod methodClass.
	target class = Metaclass ifTrue: [ target := target soleInstance ].
	^ target respondsTo: #toTranspile
]

{ #category : #accessing }
SWStackAnalyzerToTranspile >> dependencies [

	^ dependencies ifNil: [ dependencies := Dictionary new ]
]

{ #category : #accessing }
SWStackAnalyzerToTranspile >> dependencies: anObject [

	dependencies := anObject
]

{ #category : #protected }
SWStackAnalyzerToTranspile >> returnInfoOf: selector super: supered args: args [
	|aMethod|

	aMethod := self class search: selector in: args first type.
	^ (self class willTranspile: aMethod) ifTrue: [ |mi|
		mi := self methodInfoOf: selector super: supered args: args.
		self dependencies values detect: [ :one | one = mi ] ifFound: [ :detected | mi := detected ].
		self dependencies at: (self method sourceNodeForPC: oldPC) put: mi.
		mi return
	] ifFalse: [
		super returnInfoOf: selector super: supered args: args
	]



]
