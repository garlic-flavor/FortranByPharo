Class {
	#name : #VariableStack,
	#superclass : #Object,
	#instVars : [
		'stack'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
VariableStack >> at: key [
	^ self stack top at: key.
]

{ #category : #accessing }
VariableStack >> at: key ifAbsent: block [
	^ self stack top at: key ifAbsent: block
]

{ #category : #accessing }
VariableStack >> at: key ifAbsentPut: aZeroArgBlock [
	^ self stack top at: key ifAbsentPut: aZeroArgBlock
]

{ #category : #accessing }
VariableStack >> at: key put: value [
	^ self stack top at: key put: value
]

{ #category : #initialization }
VariableStack >> initialize [
	super initialize.
	stack := Stack new.

]

{ #category : #removing }
VariableStack >> pop [
	stack pop.
	
]

{ #category : #'API-remotes' }
VariableStack >> push [
	^ stack push: (stack ifNotEmpty: [
		(stack top copy)
			at: '%messageNest%' put: 0;
			yourself
	] ifEmpty: [
		Dictionary new
	]);
	yourself

]

{ #category : #accessing }
VariableStack >> stack [
	^ stack ifEmpty: [ stack push: (Dictionary new); yourself ]
]
