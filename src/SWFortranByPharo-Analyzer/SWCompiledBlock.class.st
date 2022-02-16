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

{ #category : #'instance creation' }
SWCompiledBlock class >> new: aCompiledBlock stack: aStack [
	^ self new
		payload: aCompiledBlock;
		slot: aStack;
		yourself
]

{ #category : #accessing }
SWCompiledBlock >> argNames [
	^ payload argumentNames
]

{ #category : #accessing }
SWCompiledBlock >> declaringNames [
	^ self payload sourceNode temporaryNames
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
SWCompiledBlock >> numHiddenArgs [
	^ numHiddenArgs
]

{ #category : #accessing }
SWCompiledBlock >> slot: anObject [
	super slot: anObject.
	numHiddenArgs := anObject size.
]
