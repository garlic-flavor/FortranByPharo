Class {
	#name : #SWStackAnalyzerTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Analyzer'
}

{ #category : #'tests - source' }
SWStackAnalyzerTest >> _01_return_constant [

	^ 345
]

{ #category : #'tests - source' }
SWStackAnalyzerTest >> _02_call_wellknown_message: arg1 [

	| tmp1 |
	tmp1 := 123.
	^ arg1 + tmp1
]

{ #category : #'tests - source' }
SWStackAnalyzerTest >> _03_ifTrue_ifFalse: arg1 [

	| tmp1 |
	^ arg1 = 5
		  ifTrue: [ 
			  tmp1 := 100.
			  tmp1 + 300 ]
		  ifFalse: [ 200 + 300 ]
]

{ #category : #'tests - source' }
SWStackAnalyzerTest >> _04_recursive_message_call: arg1 [

	^ 0 < arg1
		  ifTrue: [ arg1 + (self _04_recursive_message_call: arg1 - 1) ]
		  ifFalse: [ 0 ]
]

{ #category : #tests }
SWStackAnalyzerTest >> _05_local_variables [

	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 |

	^ tmp9 := 123
]

{ #category : #'tests - source' }
SWStackAnalyzerTest >> _06_method_call [
	^ SWStd print: 'hoge!'
]

{ #category : #'tests - source' }
SWStackAnalyzerTest >> _08_ZnServer [

	ZnServer startDefaultOn: 50000.
	^ ZnServer default
]

{ #category : #tests }
SWStackAnalyzerTest >> _10_new: arg1 [
	|loc1 loc2|
	loc1 := Dictionary new.
	loc2 := Set new.
	^ loc2
]

{ #category : #'as yet unclassified' }
SWStackAnalyzerTest >> _12_try_catch [

	[  
		Transcript show: 'hello'; cr
	] on: Exception do: [
		Transcript show: 'error!'
	]
]

{ #category : #'private - utility' }
SWStackAnalyzerTest >> inspectMy: arg1 withArguments: arg2 [

	(SWStackAnalyzer new: self class>>arg1 with: ({self class}, arg2))
		debugMode: true;
		decode; inspect

]

{ #category : #'private - utility' }
SWStackAnalyzerTest >> returnValueOf: arg1 withArguments: arg2 equals: arg3 [
	|analyzer|
	analyzer := SWStackAnalyzer new: arg1 with: arg2.
	analyzer decode.
	self
		assert: analyzer return value
		equals: arg3
]

{ #category : #'private - utility' }
SWStackAnalyzerTest >> returnValueOfMy: arg1 withArguments: arg2 equals: arg3 [

	self returnValueOf: self class>>arg1 withArguments: ({ self class }, arg2) equals: arg3

]

{ #category : #tests }
SWStackAnalyzerTest >> test_01 [

	self
		returnValueOfMy: #_01_return_constant
		withArguments: {  }
		equals: SmallInteger
]

{ #category : #tests }
SWStackAnalyzerTest >> test_02 [

	self
		returnValueOfMy: #_02_call_wellknown_message:
		withArguments: { Integer }
		equals: Integer;
		returnValueOfMy: #_02_call_wellknown_message:
		withArguments: { Float }
		equals: Float
]

{ #category : #tests }
SWStackAnalyzerTest >> test_02_decode [

	self
		inspectMy: #_02_call_wellknown_message:
		withArguments: { Integer }.
"
		equals: Integer;
		returnValueOfMy: #_02_call_wellknown_message:
		withArguments: { Float }
		equals: Float
"
]

{ #category : #tests }
SWStackAnalyzerTest >> test_03 [

	self
		returnValueOfMy: #_03_ifTrue_ifFalse:
		withArguments: { Integer }
		equals: SmallInteger
]

{ #category : #tests }
SWStackAnalyzerTest >> test_04 [

	self
		returnValueOfMy: #_04_recursive_message_call:
		withArguments: { SmallInteger }
		equals: SmallInteger
]

{ #category : #tests }
SWStackAnalyzerTest >> test_05 [

	self
		returnValueOfMy: #_05_local_variables
		withArguments: {  }
		equals: SmallInteger
]

{ #category : #tests }
SWStackAnalyzerTest >> test_06 [

	self
		returnValueOfMy: #_06_method_call
		withArguments: {  }
		equals: SWStd class
]

{ #category : #tests }
SWStackAnalyzerTest >> test_07_decode_closure [
	self returnValueOf: [ 123 ] withArguments: { } equals: SmallInteger

]

{ #category : #tests }
SWStackAnalyzerTest >> test_08 [
	|sa|
	sa := SWStackAnalyzer new: self class>>#_08_ZnServer with: { self class }.
	sa decode.
	sa inspect.
]

{ #category : #tests }
SWStackAnalyzerTest >> test_09_access_to_instance_variables [
	|sa|
	sa := SWStackAnalyzer new: [|satp|
		satp := SWStackAnalyzerTestProgram new.
		satp var1
	].
	sa decode.
	sa inspect.
]

{ #category : #tests }
SWStackAnalyzerTest >> test_10_new [
	self returnValueOfMy: #_10_new: withArguments: { Integer } equals: Set

]

{ #category : #tests }
SWStackAnalyzerTest >> test_11_ZnServer [
	|sa|
	sa := SWStackAnalyzer new: SWServer>>#startOn: with: { SWServer. SmallInteger }.
	sa decode.
	sa inspect.
]

{ #category : #tests }
SWStackAnalyzerTest >> test_12_decode [
	self inspectMy: #_12_try_catch withArguments: {  }
]
