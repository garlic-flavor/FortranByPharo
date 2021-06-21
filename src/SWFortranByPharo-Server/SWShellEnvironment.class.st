"
This contains the information about development environment.
"
Class {
	#name : #SWShellEnvironment,
	#superclass : #Object,
	#classVars : [
		'default'
	],
	#category : #'SWFortranByPharo-Server-Shell'
}

{ #category : #accessing }
SWShellEnvironment class >> default [
	default ifNil: [ 
		OSPlatform current isMacOS ifTrue: [ 
			^ default := SWShellEnvironmentOnMac new
		].
		self error: 'This machine is not supported.'.
	].
	^ default
]

{ #category : #accessing }
SWShellEnvironment >> compilerName [
	^ SubclassResponsibility
]

{ #category : #accessing }
SWShellEnvironment >> exeFileExtension [
	^ SubclassResponsibility
]

{ #category : #accessing }
SWShellEnvironment >> objFileExtension [
	^ SubclassResponsibility 
]
