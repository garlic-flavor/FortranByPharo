"
get first CompiledBlock from CompiledMethod.
"
Class {
	#name : #SWCompiledBlockDripper,
	#superclass : #SymbolicBytecodeBuilder,
	#instVars : [
		'cm',
		'cc'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #'as yet unclassified' }
SWCompiledBlockDripper class >> dripFrom: aCompiledMethod receiver: receiver args: args [
	^ self new
		method: aCompiledMethod;
		cm: (SWCompiledMethod new: aCompiledMethod receiver: receiver with: args);
		decode;
		cc
]

{ #category : #accessing }
SWCompiledBlockDripper >> cc [
	^ cc
]

{ #category : #accessing }
SWCompiledBlockDripper >> cm [

	^ cm
]

{ #category : #accessing }
SWCompiledBlockDripper >> cm: anObject [

	cm := anObject
]

{ #category : #'instruction decoding' }
SWCompiledBlockDripper >> pushFullClosure: lit numCopied: numCopied receiverOnStack: rcvr ignoreOuterContext: ignore [

	cc := cc ifNil: [SWCompiledBlock new: lit  receiver: cm receiver with: (self cm slot  pop: numCopied) ].
	
	^ super pushFullClosure: lit numCopied: numCopied receiverOnStack: rcvr ignoreOuterContext: ignore
]
