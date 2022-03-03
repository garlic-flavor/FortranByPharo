"
I generate mangled name from a SWSenderInfo.
"
Class {
	#name : #SWMangle,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #'as yet unclassified' }
SWMangle class >> mangle: aDecoder [
	^ self subclassResponsibility
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
