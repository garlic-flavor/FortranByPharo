"
An implementation of SWCompiledCode for CompiledMethod.
"
Class {
	#name : #SWCompiledMethodOld,
	#superclass : #SWCompiledCodeOld,
	#category : #'SWFortranByPharo-Analyzer-Olds'
}

{ #category : #accessing }
SWCompiledMethodOld >> argNames [
	^ payload argumentNames
]

{ #category : #accessing }
SWCompiledMethodOld >> declaringNames [
	^ self tempNames copyFrom: (self numArgs + 1) to: self numTemps
]

{ #category : #accessing }
SWCompiledMethodOld >> initialSize [
	^ payload method numTemps
]

{ #category : #testing }
SWCompiledMethodOld >> isDecodable [
	^ true
]

{ #category : #accessing }
SWCompiledMethodOld >> methodClass [
	^ self payload methodClass
]

{ #category : #accessing }
SWCompiledMethodOld >> numArgs [
	^ payload numArgs
]

{ #category : #accessing }
SWCompiledMethodOld >> numLocals [
	^ payload method numTemps
]

{ #category : #accessing }
SWCompiledMethodOld >> numTemps [
	^ payload tempNames size
]

{ #category : #accessing }
SWCompiledMethodOld >> selector [
	^ payload selector
]

{ #category : #accessing }
SWCompiledMethodOld >> sourceNode [
	^ payload sourceNode
]

{ #category : #'source code management' }
SWCompiledMethodOld >> tempNames [
	^ payload tempNames
]
