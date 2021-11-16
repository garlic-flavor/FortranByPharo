"
I implements base functionality for transpilers.
"
Class {
	#name : #SWTranspilerBase,
	#superclass : #Object,
	#instVars : [
		'type',
		'logger'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'code generation - protected' }
SWTranspilerBase class >> domainSpecificMessageTranspilerOf: aSelector [
	^ ((self safeSelectorNameOf: aSelector), 'For:With:') asSymbol
]

{ #category : #'code generation - protected' }
SWTranspilerBase class >> safeSelectorNameOf: selector [
	selector = '=' ifTrue: [ ^ 'opEqual_' ].
	selector = '~=' ifTrue: [ ^ 'opNotEqual_' ].
	selector = ',' ifTrue: [ ^ 'opCamma_' ].
	selector = '->' ifTrue: [ ^ 'opArrow_' ].
	selector = '/' ifTrue: [ ^ 'opDiv_' ].
	selector = '<<' ifTrue: [ ^ 'opWrite_' ].
	^ selector collect: [:c | (#' >#:/' anySatisfy: [ :each | each = c]) ifTrue: [ $_ ] ifFalse: [ c ] ]

]

{ #category : #accessing }
SWTranspilerBase >> analyzer [
	^ self subclassResponsibility 
]

{ #category : #enumerating }
SWTranspilerBase >> hasDomainSpecificTranspilerOf: aSelecter ifTrue: aBlock [
	|dst|
	dst := self class domainSpecificMessageTranspilerOf: aSelecter.
	(self respondsTo: dst) ifTrue: [
		aBlock value: dst
	]
]

{ #category : #'code generation - protected' }
SWTranspilerBase >> ifUniqueMessageTranspilerExistsOn: receiver of: selector thenDo: aBlock [
	|receiverClass selectorName|
	receiverClass := receiver transpileUsing: self analyzer .
	receiverClass class = Metaclass ifFalse: [ ^ self ].
	selectorName := self uniqueMessageTranspilerOf: selector.
	(receiverClass methodDict includesKey: selectorName) ifTrue: [
		aBlock value: receiverClass soleInstance value: selectorName
	]

]

{ #category : #accessing }
SWTranspilerBase >> logger [
	^ logger ifNil: [ logger := SWLogger new ]
]

{ #category : #accessing }
SWTranspilerBase >> logging: trueOrFalse [
	self logger enabled: trueOrFalse
]

{ #category : #'code generation - protected' }
SWTranspilerBase >> methodBodyGeneratorNameOf: aMethod [
	^ (String streamContents: [ :s |
		s
			<< self type;
			<< '_';
			<< (self class safeSelectorNameOf: aMethod selector);
			<< 'Using:'
	]) asSymbol.

]

{ #category : #'code generation' }
SWTranspilerBase >> putMessage: receiver call: selector with: arguments [
	self logger log: [receiver asString, '>>', selector asString].
	self ifUniqueMessageTranspilerExistsOn: receiver of: selector thenDo: [ :receiverClass :selectorName |
		^ receiverClass perform: selectorName with: arguments with: self
	].
	self hasDomainSpecificTranspilerOf: selector ifTrue: [ :dst |
		^ self perform: dst with: receiver with: arguments
	].
	^ self putOrdinaryMessage: receiver call: selector with: arguments.

]

{ #category : #'code generation' }
SWTranspilerBase >> putOrdinaryMessage: receiver call: selector with: arguments [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWTranspilerBase >> type [

	^ type
]

{ #category : #accessing }
SWTranspilerBase >> type: anObject [

	type := anObject
]

{ #category : #'code generation - protected' }
SWTranspilerBase >> uniqueMessageTranspilerOf: aSelector [
	^ (String streamContents: [ :s |
		s << self type; <<  '_'; << (self class safeSelectorNameOf: aSelector); << 'With:Using:'
	]) asSymbol
	

]
