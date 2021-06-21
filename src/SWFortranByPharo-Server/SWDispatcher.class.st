"
This is a OrderedCollection of Associations that consists of closure as its key.
This implements if-elseif like directive.
"
Class {
	#name : #SWDispatcher,
	#superclass : #Object,
	#instVars : [
		'list'
	],
	#category : #'SWFortranByPharo-Server-Shell'
}

{ #category : #evaluation }
SWDispatcher >> detect: needle [
	list do: [ :assoc |
		(assoc key value: needle)
			ifTrue: [ ^ assoc value value: needle ]
	]
]

{ #category : #initialization }
SWDispatcher >> if: needle then: trueBlock [
	list add: (needle -> trueBlock)
]

{ #category : #initialization }
SWDispatcher >> initialize [
	super initialize.
	list := OrderedCollection new.
]
