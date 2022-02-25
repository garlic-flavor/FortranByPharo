"
SWSenderTranspiler transpile a message sender expression.
"
Class {
	#name : #SWSenderTranspiler,
	#superclass : #SWSenderOld,
	#instVars : [
		'generator'
	],
	#category : #'SWFortranByPharo-Transpiler-Olds'
}

{ #category : #'code generation' }
SWSenderTranspiler >> dispatchTo: transpiler [
	self generator cull: transpiler cull: self
]

{ #category : #accessing }
SWSenderTranspiler >> generator [

	^ generator ifNil: [
		generator := [ :transpiler :sender |
			transpiler
				withoutMessageNestDo: [
					transpiler << sender node receiver
				];
				putClassAccessor;
				put: (transpiler mangle: self);
				putArguments: sender node arguments
			"|transpilerSelector|

			transpilerSelector := transpiler class mangleClass selectorForTranspilerOf: aNode selector.
			(transpiler respondsTo: transpilerSelector) ifTrue: [
				transpiler perform: transpilerSelector with: aNode
			] ifFalse: [
				transpiler putOrdinaryCallee: aNode
			]
"
		]
	]
]

{ #category : #accessing }
SWSenderTranspiler >> generator: anObject [

	generator := anObject
]
