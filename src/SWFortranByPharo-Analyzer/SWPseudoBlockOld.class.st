"
An Impoementation of SWCompilerCode for Jumpers (like ifTrue:ifFalse:).
"
Class {
	#name : #SWPseudoBlockOld,
	#superclass : #SWCompiledCodeOld,
	#instVars : [
		'numHiddenArgs'
	],
	#category : #'SWFortranByPharo-Analyzer-Olds'
}

{ #category : #'instance creation' }
SWPseudoBlockOld class >> new: aNode stack: aStack [
	^ self new
		payload: aNode;
		slot: aStack;
		yourself
]

{ #category : #accessing }
SWPseudoBlockOld >> argNames [
	^ #()
]

{ #category : #accessing }
SWPseudoBlockOld >> code [
	^ nil
]

{ #category : #accessing }
SWPseudoBlockOld >> declaringNames [
	^ self payload temporaryNames
]

{ #category : #testing }
SWPseudoBlockOld >> isDecodable [
	^ false
]

{ #category : #accessing }
SWPseudoBlockOld >> methodClass [
	^ nil
]

{ #category : #accessing }
SWPseudoBlockOld >> numArgs [
	^ 0
]

{ #category : #accessing }
SWPseudoBlockOld >> numHiddenArgs [
	^ numHiddenArgs
]

{ #category : #accessing }
SWPseudoBlockOld >> numHiddenArgs: num [
	numHiddenArgs := num
	
]

{ #category : #accessing }
SWPseudoBlockOld >> numLocals [
	^ self payload temporaries size
]

{ #category : #accessing }
SWPseudoBlockOld >> numTemps [
	^ self payload temporaries size
]

{ #category : #accessing }
SWPseudoBlockOld >> selector [
	^ self payload selector
]

{ #category : #accessing }
SWPseudoBlockOld >> slot: anObject [
	super slot: anObject.
	self tempNames doWithIndex: [ :each :idx|
		(self slot at: self numHiddenArgs + idx) name: each
	].
]

{ #category : #accessing }
SWPseudoBlockOld >> sourceNode [
	^ self payload
]

{ #category : #'source code management' }
SWPseudoBlockOld >> tempNames [
	^ self payload temporaryNames
]
