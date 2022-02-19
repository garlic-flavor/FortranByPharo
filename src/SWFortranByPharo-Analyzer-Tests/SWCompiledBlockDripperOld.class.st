"
get first CompiledBlock from CompiledMethod.
"
Class {
	#name : #SWCompiledBlockDripperOld,
	#superclass : #SymbolicBytecodeBuilder,
	#instVars : [
		'cm',
		'cc'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Olds'
}

{ #category : #'as yet unclassified' }
SWCompiledBlockDripperOld class >> dripFrom: aCompiledMethod receiver: receiver args: args [
	^ self new
		method: aCompiledMethod;
		cm: (SWCompiledMethodOld new: aCompiledMethod receiver: receiver with: args);
		decode;
		cc
]

{ #category : #accessing }
SWCompiledBlockDripperOld >> cc [
	^ cc
]

{ #category : #accessing }
SWCompiledBlockDripperOld >> cm [

	^ cm
]

{ #category : #accessing }
SWCompiledBlockDripperOld >> cm: anObject [

	cm := anObject
]

{ #category : #'instruction decoding' }
SWCompiledBlockDripperOld >> pushFullClosure: lit numCopied: numCopied receiverOnStack: rcvr ignoreOuterContext: ignore [

	cc := cc ifNil: [SWCompiledBlockOld new: lit  receiver: cm receiver with: (self cm slot  pop: numCopied) ].
	
	^ super pushFullClosure: lit numCopied: numCopied receiverOnStack: rcvr ignoreOuterContext: ignore
]
