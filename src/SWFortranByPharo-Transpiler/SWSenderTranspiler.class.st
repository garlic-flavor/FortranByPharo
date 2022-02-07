"
SWSenderTranspiler transpile a message sender expression.
"
Class {
	#name : #SWSenderTranspiler,
	#superclass : #SWSender,
	#instVars : [
		'generator'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #accessing }
SWSenderTranspiler >> generator [

	^ generator ifNil: [
		generator := [ :transpiler :aNode |
			transpiler stream log.
			transpiler
				<< aNode receiver;
				putClassAccessor;
				put: (transpiler mangle: self);
				putArguments: aNode arguments
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

{ #category : #'as yet unclassified' }
SWSenderTranspiler >> transpileUsing: transpiler [
	self generator cull: transpiler cull: self node
]
