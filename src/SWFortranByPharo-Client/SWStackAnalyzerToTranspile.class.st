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

{ #category : #testing }
SWStackAnalyzerToTranspile class >> isToTranspile: aMethod [
	|target|
	target := aMethod methodClass.
	target class = Metaclass ifTrue: [ target := target soleInstance ].
	^ target respondsTo: #toTranspile
]

{ #category : #'instance creation' }
SWStackAnalyzerToTranspile class >> new: selector types: types [
	^ definedMethods at: selector ifPresent: [ :dm |
		dm value: selector value: types
	] ifAbsent: [|aMethod|
		aMethod := self search: selector in: types first.
		((self isToTranspile: aMethod) ifTrue: [ self new ] ifFalse: [ SWStackAnalyzer new])
			method: aMethod;
			types: types;
			yourself
	]

]

{ #category : #accessing }
SWStackAnalyzerToTranspile >> dependencies [

	^ dependencies ifNil: [ dependencies := Set new ]
]

{ #category : #accessing }
SWStackAnalyzerToTranspile >> dependencies: anObject [

	dependencies := anObject
]

{ #category : #protected }
SWStackAnalyzerToTranspile >> returnInfoOf: selector super: supered args: args [
	|aMethod|

	aMethod := self class search: selector in: args first type.
	^ (self class isToTranspile: aMethod) ifTrue: [ |mi|
		mi := self methodInfoOf: selector super: supered args: args.
		self dependencies add: mi.
		mi return
	] ifFalse: [
		super returnInfoOf: selector super: supered args: args
	]



]
