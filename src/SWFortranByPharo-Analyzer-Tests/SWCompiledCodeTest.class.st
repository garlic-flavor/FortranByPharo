"
A SWCompiledCodeTest is a test class for testing the behavior of SWCompiledCode
"
Class {
	#name : #SWCompiledCodeTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #'as yet unclassified' }
SWCompiledCodeTest >> _01_return_value [
	^ 123
]

{ #category : #'as yet unclassified' }
SWCompiledCodeTest >> _02_has_arguments: arg [
	^ arg
]

{ #category : #tests }
SWCompiledCodeTest >> testBasics [
	|cc|
	cc := SWCompiledCode new: self class>>#_01_return_value with: { self class }.
	self assert: cc stack first value equals: self class.
	
	self assert: cc isDecoded not.
	cc markAsDecoded.
	self assert: cc isDecoded.
	self assert: cc methodClass equals: self class.
	self assert: cc receiverClass equals: self class.
	self assert: cc return value equals: UndefinedObject.
	cc specifyReturnTypeAs: Integer.
	self assert: cc return value equals: Integer.
	
	cc := SWCompiledCode new: self class>>#_02_has_arguments: with: { self class. String }.
	self assert: cc arguments size equals: 1.
	self assert: cc arguments first value equals: String.
	self assert: cc locals size equals: 0.
]
