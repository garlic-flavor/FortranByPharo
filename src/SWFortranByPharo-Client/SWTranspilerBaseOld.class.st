"
I implements base functionality for transpilers.
"
Class {
	#name : #SWTranspilerBaseOld,
	#superclass : #Object,
	#instVars : [
		'type',
		'logger'
	],
	#category : #'SWFortranByPharo-Client-Transpiler-Deprecated'
}

{ #category : #accessing }
SWTranspilerBaseOld class >> analyzerClass [
	^ SWCompiledCodeInfo
]

{ #category : #utils }
SWTranspilerBaseOld class >> domainSpecificMessageTranspilerOf: aSelector [
	^ ((self safeSelectorNameOf: aSelector), 'For:With:') asSymbol
]

{ #category : #utils }
SWTranspilerBaseOld class >> safeSelectorNameOf: selector [
	selector = '=' ifTrue: [ ^ 'opEqual_' ].
	selector = '~=' ifTrue: [ ^ 'opNotEqual_' ].
	selector = ',' ifTrue: [ ^ 'opCamma_' ].
	selector = '->' ifTrue: [ ^ 'opArrow_' ].
	selector = '/' ifTrue: [ ^ 'opDiv_' ].
	selector = '<<' ifTrue: [ ^ 'opWrite_' ].
	^ selector collect: [:c | (#' >#:/' anySatisfy: [ :each | each = c]) ifTrue: [ $_ ] ifFalse: [ c ] ]

]

{ #category : #testing }
SWTranspilerBaseOld >> hasDomainSpecificTranspilerOf: aSelecter ifTrue: aBlock [
	|dst|
	dst := self class domainSpecificMessageTranspilerOf: aSelecter.
	(self respondsTo: dst) ifTrue: [
		aBlock value: dst
	]
]

{ #category : #testing }
SWTranspilerBaseOld >> ifUniqueMessageTranspilerExistsOn: receiver of: selector thenDo: aBlock [
	|receiverClass selectorName|
	self halt.
	self flag: #ToImplement.
	receiverClass := receiver transpileUsing: self analyzer .
	receiverClass class = Metaclass ifFalse: [ ^ self ].
	selectorName := self uniqueMessageTranspilerOf: selector.
	(receiverClass methodDict includesKey: selectorName) ifTrue: [
		aBlock value: receiverClass soleInstance value: selectorName
	]

]

{ #category : #accessing }
SWTranspilerBaseOld >> logger [
	^ logger ifNil: [ logger := SWLogger new ]
]

{ #category : #accessing }
SWTranspilerBaseOld >> logging: trueOrFalse [
	self logger enabled: trueOrFalse
]

{ #category : #utils }
SWTranspilerBaseOld >> methodBodyGeneratorNameOf: aMethod [
	^ (String streamContents: [ :s |
		s
			<< self type;
			<< '_';
			<< (self class safeSelectorNameOf: aMethod selector);
			<< 'Using:'
	]) asSymbol.

]

{ #category : #'code generation - protected' }
SWTranspilerBaseOld >> putMessage: receiver send: selector with: arguments [
	self logger log: [receiver asString, '>>', selector asString].
	self ifUniqueMessageTranspilerExistsOn: receiver of: selector thenDo: [ :receiverClass :selectorName |
		^ receiverClass perform: selectorName with: arguments with: self
	].
	self hasDomainSpecificTranspilerOf: selector ifTrue: [ :dst |
		^ self perform: dst with: receiver with: arguments
	].
	^ self putOrdinaryMessage: receiver send: selector with: arguments.

]

{ #category : #'code generation - protected' }
SWTranspilerBaseOld >> putOrdinaryMessage: receiver send: selector with: arguments [
	^ self subclassResponsibility 
]

{ #category : #'public - accessing' }
SWTranspilerBaseOld >> type [

	^ type
]

{ #category : #'public - accessing' }
SWTranspilerBaseOld >> type: anObject [

	type := anObject
]

{ #category : #utils }
SWTranspilerBaseOld >> uniqueMessageTranspilerOf: aSelector [
	^ (String streamContents: [ :s |
		s << self type; <<  '_'; << (self class safeSelectorNameOf: aSelector); << 'With:Using:'
	]) asSymbol
	

]
