"
I generate mangled name from a class.
"
Class {
	#name : #SWMangle,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #'as yet unclassified' }
SWMangle class >> mangle: aSender [
	self halt; flag: #toRewrite.
	^ self methodNameOf: aSender selector with: aSender operands.
"	
	aCallee method class = CompiledMethod ifTrue: [
		^ self methodNameOf: aCallee method with: aCallee operands
	].

	aCallee method class = ByteSymbol ifTrue: [
		^ self safeSelectorNameOf: aCallee method
	]
"
]

{ #category : #api }
SWMangle class >> methodNameOf: method with: args [
	self halt; flag: #toRewrite.
	^ String streamContents: [ :s ||owner|
		owner := (method methodClass).
		owner isClassSide ifTrue: [ 
			s << owner soleInstance name; << 'C'
		] ifFalse: [
			s << owner name; << '_'
		].
		s
			<< (self safeSelectorNameOf: method selector);
			<< (args collect: [ :v |
				self typeNameOf: v type value
			])
	]
]

{ #category : #api }
SWMangle class >> safeSelectorNameOf: selector [
	selector = '=' ifTrue: [ ^ 'opEqual_' ].
	selector = '==' ifTrue: [ ^ 'opEqual_' ].
	selector = '~=' ifTrue: [ ^ 'opNotEqual_' ].
	selector = ',' ifTrue: [ ^ 'opCamma_' ].
	selector = '->' ifTrue: [ ^ 'opArrow_' ].
	selector = '/' ifTrue: [ ^ 'opDiv_' ].
	selector = '<<' ifTrue: [ ^ 'opWrite_' ].
	selector = '+' ifTrue: [ ^ 'opPlus_' ].
	selector = '<' ifTrue: [ ^ 'opLT_' ].
	selector = '*' ifTrue: [ ^ 'opMul_' ].
	selector = '-' ifTrue: [ ^ 'opSub_' ].
	^ selector collect: [:c | (#' >#:/' anySatisfy: [ :each | each = c]) ifTrue: [ $_ ] ifFalse: [ c ] ]

]

{ #category : #'as yet unclassified' }
SWMangle class >> selectorForTranspilerOf: aSelector [
	self error; flag: #toRemove.
	^ (String streamContents: [ :s |
		s
			<< 'put_';
			<< (self safeSelectorNameOf: aSelector);
			<< ':'
	]) asSymbol
]

{ #category : #api }
SWMangle class >> typeNameOf: aType [
	^ aType ifNil: [ '_' ] ifNotNil: [ aType name select: [ :c | c isUppercase ] thenCollect: [ :c | c asLowercase ] ].
]
