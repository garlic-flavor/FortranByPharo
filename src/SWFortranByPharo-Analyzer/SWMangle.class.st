"
I generate mangled name from a class.
"
Class {
	#name : #SWMangle,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Analyzer-Method'
}

{ #category : #api }
SWMangle class >> methodNameOf: method with: args [
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

{ #category : #api }
SWMangle class >> typeNameOf: aType [
	^ aType ifNil: [ '_' ] ifNotNil: [ aType name select: [ :c | c isUppercase ] thenCollect: [ :c | c asLowercase ] ].
]
