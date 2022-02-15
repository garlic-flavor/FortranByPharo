"
get first CompiledBlock from CompiledMethod.
"
Class {
	#name : #SWCompiledBlockDripper,
	#superclass : #SymbolicBytecodeBuilder,
	#instVars : [
		'cc'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #'as yet unclassified' }
SWCompiledBlockDripper class >> dripFrom: aCompiledMethod [
	^ self new
		method: aCompiledMethod;
		decode;
		cc
]

{ #category : #accessing }
SWCompiledBlockDripper >> cc [
	^ cc
]

{ #category : #'instruction decoding' }
SWCompiledBlockDripper >> pushFullClosure: lit numCopied: numCopied receiverOnStack: rcvr ignoreOuterContext: ignore [
	self halt.
	
	^ super pushFullClosure: lit numCopied: numCopied receiverOnStack: rcvr ignoreOuterContext: ignore
]
