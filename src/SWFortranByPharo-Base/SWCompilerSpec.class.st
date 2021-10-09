"
This express an information about compiler.
"
Class {
	#name : #SWCompilerSpec,
	#superclass : #Object,
	#instVars : [
		'name',
		'type',
		'major',
		'minor',
		'patch',
		'message'
	],
	#category : #'SWFortranByPharo-Base-CompilerAdapter'
}

{ #category : #accessing }
SWCompilerSpec >> major [

	^ major
]

{ #category : #accessing }
SWCompilerSpec >> major: anObject [

	major := anObject
]

{ #category : #accessing }
SWCompilerSpec >> message [

	^ message
]

{ #category : #accessing }
SWCompilerSpec >> message: anObject [

	message := anObject
]

{ #category : #accessing }
SWCompilerSpec >> minor [

	^ minor
]

{ #category : #accessing }
SWCompilerSpec >> minor: anObject [

	minor := anObject
]

{ #category : #accessing }
SWCompilerSpec >> name [

	^ name
]

{ #category : #accessing }
SWCompilerSpec >> name: anObject [

	name := anObject
]

{ #category : #accessing }
SWCompilerSpec >> patch [

	^ patch
]

{ #category : #accessing }
SWCompilerSpec >> patch: anObject [

	patch := anObject
]

{ #category : #accessing }
SWCompilerSpec >> type [

	^ type
]

{ #category : #accessing }
SWCompilerSpec >> type: anObject [

	type := anObject
]
