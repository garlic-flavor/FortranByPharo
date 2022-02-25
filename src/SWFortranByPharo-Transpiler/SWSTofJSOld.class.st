"
This is an implementation of SWSenderTranspiler for ECMAScript.
"
Class {
	#name : #SWSTofJSOld,
	#superclass : #SWSenderTranspiler,
	#category : #'SWFortranByPharo-Transpiler-Olds'
}

{ #category : #accessing }
SWSTofJSOld >> generator [
	^ generator ifNil: [ |ordinary receiverClass|
		ordinary := super generator.

		self method ifNil: [ ^ ordinary ].
		self method methodClass isInstanceSide ifTrue: [ ^ ordinary ].
		receiverClass := self operands receiver value.
		receiverClass = self method methodClass ifTrue: [ ^ ordinary ].
		"For static method."
		generator := [ :transpiler :sender |
			transpiler
				put: self method methodClass instanceSide name;
				putClassAccessor;
				put: (transpiler mangle: self);
				putClassAccessor;
				put: 'call';
				putArguments: ({RBVariableNode named: receiverClass instanceSide name}, sender node arguments)
		]
	]
]
