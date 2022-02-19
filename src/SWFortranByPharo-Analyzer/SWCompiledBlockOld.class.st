"
An implementation of SWCompiledCode for CompiledCode.
"
Class {
	#name : #SWCompiledBlockOld,
	#superclass : #SWCompiledCodeOld,
	#instVars : [
		'numHiddenArgs'
	],
	#category : #'SWFortranByPharo-Analyzer-Olds'
}

{ #category : #accessing }
SWCompiledBlockOld >> argNames [
	^ payload argumentNames
]

{ #category : #accessing }
SWCompiledBlockOld >> declaringNames [
	^ self payload sourceNode temporaryNames
]

{ #category : #accessing }
SWCompiledBlockOld >> initialSize [
	^ self payload numTemps

]

{ #category : #testing }
SWCompiledBlockOld >> isDecodable [
	^ true
]

{ #category : #accessing }
SWCompiledBlockOld >> methodClass [
	^ nil
]

{ #category : #accessing }
SWCompiledBlockOld >> numArgs [
	^ self payload numArgs

]

{ #category : #accessing }
SWCompiledBlockOld >> numTemps [
	^ self payload numArgs + self payload sourceNode temporaries size

]

{ #category : #accessing }
SWCompiledBlockOld >> selector [
	^ 'closure'
]

{ #category : #accessing }
SWCompiledBlockOld >> sourceNode [
	^ self payload sourceNode
]

{ #category : #'source code management' }
SWCompiledBlockOld >> tempNames [
	^ self payload argumentNames, self payload sourceNode temporaryNames

]
