"
I am a base class of the class that implements a project.s
"
Class {
	#name : #SWClass,
	#superclass : #Object,
	#instVars : [
		'stdout'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWClass >> functionDeclarations [
	^ #()
]

{ #category : #initialization }
SWClass >> initialize [
	super initialize.

]

{ #category : #running }
SWClass >> program [
	^ self subclassResponsibility
]

{ #category : #accessing }
SWClass >> stdout [

	^ stdout
]

{ #category : #accessing }
SWClass >> stdout: anObject [

	stdout := anObject
]
