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
SWCompiledBlockDripper class >> dripFrom: aCompiledMethod with: operands [
	^ self new
		method: aCompiledMethod;
		cm: (SWCompiledMethod new: aCompiledMethod with: operands);
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

	cc := cc ifNil: [SWCompiledBlock new: lit stack: (self cm copySlotForFullClosure: numCopied) ].
	
	^ super pushFullClosure: lit numCopied: numCopied receiverOnStack: rcvr ignoreOuterContext: ignore
]
