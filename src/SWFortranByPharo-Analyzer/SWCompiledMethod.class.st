"
An implementation of SWCompiledCode for CompiledMethod.
"
Class {
	#name : #SWCompiledMethod,
	#superclass : #SWCompiledCode,
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #'as yet unclassified' }
SWCompiledMethod >> argNames [
	^ payload argumentNames
]

{ #category : #accessing }
SWCompiledMethod >> code [
	^ payload
]

{ #category : #accessing }
SWCompiledMethod >> declaringNames [
	^ self tempNames copyFrom: (self numArgs + 1) to: self numTemps
]

{ #category : #'as yet unclassified' }
SWCompiledMethod >> isDecodable [
	^ true
]

{ #category : #accessing }
SWCompiledMethod >> numArgs [
	^ payload numArgs
]

{ #category : #'as yet unclassified' }
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
