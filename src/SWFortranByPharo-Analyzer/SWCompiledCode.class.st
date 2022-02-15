"
SWCompiledCode wraps CompiledMethod, CompiledBlock and PseudoBlock.
"
Class {
	#name : #SWCompiledCode,
	#superclass : #Object,
	#instVars : [
		'payload'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #'instance creation' }
SWCompiledCode class >> new: compiledCode [
	compiledCode class = CompiledMethod ifTrue: [
		^ SWCompiledMethod new
			payload: compiledCode;
			yourself.
	]
]

{ #category : #accessing }
SWCompiledCode >> argNames [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> code [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> declaringNames [
	^ self subclassResponsibility 
]

{ #category : #tests }
SWCompiledCode >> isDecodable [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> numArgs [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> numLocals [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> numTemps [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> payload [

	^ payload
]

{ #category : #accessing }
SWCompiledCode >> payload: anObject [

	payload := anObject
]

{ #category : #accessing }
SWCompiledCode >> selector [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> sourceNode [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWCompiledCode >> tempNames [
	^ self subclassResponsibility 
]
