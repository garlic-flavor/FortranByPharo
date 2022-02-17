"
An implementation of SWCompiledCode for CompiledMethod.
"
Class {
	#name : #SWCompiledMethod,
	#superclass : #SWCompiledCode,
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #accessing }
SWCompiledMethod >> argNames [
	^ payload argumentNames
]

{ #category : #accessing }
SWCompiledMethod >> declaringNames [
	^ self tempNames copyFrom: (self numArgs + 1) to: self numTemps
]

{ #category : #accessing }
SWCompiledMethod >> initialSize [
	^ payload method numTemps
]

{ #category : #testing }
SWCompiledMethod >> isDecodable [
	^ true
]

{ #category : #accessing }
SWCompiledMethod >> methodClass [
	^ self payload methodClass
]

{ #category : #accessing }
SWCompiledMethod >> numArgs [
	^ payload numArgs
]

{ #category : #accessing }
SWCompiledMethod >> numLocals [
	^ payload method numTemps
]

{ #category : #accessing }
SWCompiledMethod >> numTemps [
	^ payload tempNames size
]

{ #category : #accessing }
SWCompiledMethod >> selector [
	^ payload selector
]

{ #category : #accessing }
SWCompiledMethod >> sourceNode [
	^ payload sourceNode
]

{ #category : #'source code management' }
SWCompiledMethod >> tempNames [
	^ payload tempNames
]
