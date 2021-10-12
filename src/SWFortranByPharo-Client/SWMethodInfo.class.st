Class {
	#name : #SWMethodInfo,
	#superclass : #Object,
	#instVars : [
		'owner',
		'name',
		'mangledName',
		'returnType',
		'argumentTypes',
		'variables'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWMethodInfo >> argumentTypes [

	^ argumentTypes ifNil: [ argumentTypes := OrderedCollection new ]
]

{ #category : #accessing }
SWMethodInfo >> argumentTypes: anObject [

	argumentTypes := anObject
]

{ #category : #testing }
SWMethodInfo >> hasReturn [
	^ self returnType isNotNil
]

{ #category : #accessing }
SWMethodInfo >> mangledName [

	^ mangledName
]

{ #category : #accessing }
SWMethodInfo >> mangledName: anObject [

	mangledName := anObject
]

{ #category : #accessing }
SWMethodInfo >> name [

	^ name
]

{ #category : #accessing }
SWMethodInfo >> name: anObject [

	name := anObject
]

{ #category : #accessing }
SWMethodInfo >> owner [

	^ owner
]

{ #category : #accessing }
SWMethodInfo >> owner: anObject [

	owner := anObject
]

{ #category : #accessing }
SWMethodInfo >> returnType [

	^ returnType
]

{ #category : #accessing }
SWMethodInfo >> returnType: anObject [

	returnType := anObject
]

{ #category : #accessing }
SWMethodInfo >> variables [

	^ variables ifNil: [ variables := Dictionary new ]
]

{ #category : #accessing }
SWMethodInfo >> variables: anObject [

	variables := anObject
]
