"
An Impoementation of SWCompilerCode for Jumpers (like ifTrue:ifFalse:).
"
Class {
	#name : #SWPseudoBlock,
	#superclass : #SWCompiledCode,
	#instVars : [
		'numHiddenArgs'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #'instance creation' }
SWPseudoBlock class >> new: aNode stack: aStack [
	^ self new
		payload: aNode;
		slot: aStack;
		yourself
]

{ #category : #accessing }
SWPseudoBlock >> argNames [
	^ #()
]

{ #category : #accessing }
SWPseudoBlock >> code [
	^ nil
]

{ #category : #accessing }
SWPseudoBlock >> declaringNames [
	^ self payload temporaryNames
]

{ #category : #testing }
SWPseudoBlock >> isDecodable [
	^ false
]

{ #category : #accessing }
SWPseudoBlock >> methodClass [
	^ nil
]

{ #category : #accessing }
SWPseudoBlock >> numArgs [
	^ 0
]

{ #category : #accessing }
SWPseudoBlock >> numHiddenArgs [
	^ numHiddenArgs
]

{ #category : #accessing }
SWPseudoBlock >> numLocals [
	^ self payload temporaries size
]

{ #category : #accessing }
SWPseudoBlock >> numTemps [
	^ self payload temporaries size
]

{ #category : #accessing }
SWPseudoBlock >> selector [
	^ self payload selector
]

{ #category : #accessing }
SWPseudoBlock >> slot: anObject [
	super slot: anObject.
	numHiddenArgs := anObject size.
	self tempNames do: [ :each |
		(self slot push) name: each
	].
]

{ #category : #accessing }
SWPseudoBlock >> sourceNode [
	^ self payload
]

{ #category : #'source code management' }
SWPseudoBlock >> tempNames [
	^ self payload temporaryNames
]
