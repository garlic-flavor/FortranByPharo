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
SWCompiledBlock >> numLocals [
	^ self payload numTemps

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
SWCompiledBlock >> slot: anObject [
	super slot: anObject.
	numHiddenArgs := anObject size.
	self tempNames do: [ :each |
		(self slot push) name: each
	].
	self slot allocate: numHiddenArgs + self numLocals - self numArgs.
]

{ #category : #accessing }
SWCompiledBlock >> sourceNode [
	^ self payload sourceNode
]

{ #category : #'source code management' }
SWCompiledBlock >> tempNames [
	^ self payload argumentNames, self payload sourceNode temporaryNames

]
