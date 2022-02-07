Class {
	#name : #SWSTofJS,
	#superclass : #SWSenderTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #accessing }
SWSTofJS class >> generator [
]

{ #category : #accessing }
SWSTofJS >> generator [
	^ generator ifNil: [ |ordinary receiverClass|
		ordinary := super generator.

		self method ifNil: [ ^ ordinary ].
		self method methodClass isInstanceSide ifTrue: [ ^ ordinary ].
		receiverClass := self operands receiver value.
		receiverClass = self method methodClass ifTrue: [ ^ ordinary ].

		generator := [ :transpiler :aNode |
			transpiler
				put: self method methodClass instanceSide name;
				putClassAccessor;
				put: (transpiler mangle: self);
				putClassAccessor;
				put: 'call';
				putArguments: ({RBVariableNode named: receiverClass instanceSide name}, aNode arguments)
		]
	]
]
