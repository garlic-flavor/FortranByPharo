"
An implementation of SWCompiledCode for CompiledCode.
"
Class {
	#name : #SWCompiledBlock,
	#superclass : #SWCompiledCode,
	#instVars : [
		'numHiddenArgs'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #accessing }
SWCompiledBlock >> argNames [
	^ payload argumentNames
]

{ #category : #accessing }
SWCompiledBlock >> declaringNames [
	^ self payload sourceNode temporaryNames
]

{ #category : #accessing }
SWCompiledBlock >> initialSize [
	^ self payload numTemps

]

{ #category : #testing }
SWCompiledBlock >> isDecodable [
	^ true
]

{ #category : #accessing }
SWCompiledBlock >> methodClass [
	^ nil
]

{ #category : #accessing }
SWCompiledBlock >> numArgs [
	^ self payload numArgs

]

{ #category : #accessing }
SWCompiledBlock >> numTemps [
	^ self payload numArgs + self payload sourceNode temporaries size

]

{ #category : #accessing }
SWCompiledBlock >> selector [
	^ 'closure'
]

{ #category : #accessing }
SWCompiledBlock >> sourceNode [
	^ self payload sourceNode
]

{ #category : #'source code management' }
SWCompiledBlock >> tempNames [
	^ self payload argumentNames, self payload sourceNode temporaryNames

]
