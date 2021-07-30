"
I implement stdout.
"
Class {
	#name : #SWStd,
	#superclass : #Object,
	#instVars : [
		'stdout'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #accessing }
SWStd class >> declarations [
	^ #(print:)
]

{ #category : #'as yet unclassified' }
SWStd class >> rb_print_using: transpiler [
	transpiler putCode: '\
		puts msg
	\'
]

{ #category : #'as yet unclassified' }
SWStd class >> rb_requirements [
	^ { 'require ''Pharo.rb''' }
]

{ #category : #printing }
SWStd >> print: msg [
	self stdout << msg asString; cr; flush
]

{ #category : #accessing }
SWStd >> stdout [

	^ stdout ifNil: [ stdout := Transcript ]
]

{ #category : #accessing }
SWStd >> stdout: anObject [

	stdout := anObject
]

{ #category : #'as yet unclassified' }
SWStd >> switch: needle when: anAssociationArray [
	^ anAssociationArray detect: [ :acc |
		(acc key class inheritsFrom: Boolean) ifTrue: [ acc key ]
			ifFalse: [ acc key = needle ]
	]
		ifFound: [ :acc | acc value value ]

]
