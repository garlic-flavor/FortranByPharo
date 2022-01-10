Class {
	#name : #SWMBTofJSTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Transpiler-Tests'
}

{ #category : #'tests - source' }
SWMBTofJSTest >> _01_call_Transcript [

	Transcript
		show: 'Hello, good-bye!';
		cr;
		cr
]

{ #category : #'tests - source' }
SWMBTofJSTest >> _02_call_SWStd_print [

	SWStd print: 'Hello, World!'
]

{ #category : #'tests - source' }
SWMBTofJSTest >> _03_user_specified_variable_type [

	| tmp1 |
	SWType declare: #tmp1 as: Integer.
	tmp1 := 3.14159265358979.

	^ tmp1 * 2.23620679
]

{ #category : #'as yet unclassified' }
SWMBTofJSTest >> _04_ifTrueifFalse [
	^ true ifTrue: [ 123 ] ifFalse: [ 'hoge' ]
	
]

{ #category : #'as yet unclassified' }
SWMBTofJSTest >> _05_ifTrue [
	^ true ifTrue: [ 123 ]
	
]

{ #category : #tests }
SWMBTofJSTest >> test_01 [
	|transpiler result|
	transpiler := (self transpile_program: #_01_call_Transcript).
	result := transpiler stream contents.
	self assert: result equals: 'Transcript.show_("Hello, good-bye!");
Transcript.cr();
Transcript.cr();
'
]

{ #category : #tests }
SWMBTofJSTest >> test_01_analyze [
	self
		assert: (SWStackAnalyzer new: self class>>#_01_call_Transcript with: { self class }) decode return value
		equals: self class
]

{ #category : #tests }
SWMBTofJSTest >> test_02 [

	|transpiler result|
	transpiler := (self transpile_program: #_02_call_SWStd_print).
	result := transpiler stream contents.
	self assert: result equals: 'console.log("Hello, World!");
'
]

{ #category : #tests }
SWMBTofJSTest >> test_03_analyze [
	self
		assert: (SWStackAnalyzer new: self class>>#_03_user_specified_variable_type with: { self class }) decode return value
		equals: Integer
]

{ #category : #tests }
SWMBTofJSTest >> test_04 [
	|transpiler result|
	transpiler := (self transpile_program: #_04_ifTrueifFalse).
	result := transpiler stream contents.
	self assert: result equals: 'return (true) ? (function(){return 123;})() : (function(){return "hoge";})();
'
]

{ #category : #tests }
SWMBTofJSTest >> test_05 [
	|transpiler result|
	transpiler := (self transpile_program: #_05_ifTrue).
	result := transpiler stream contents.
	self assert: result equals: 'return (true) ? (function(){return 123;})() : null;
'
]

{ #category : #utilities }
SWMBTofJSTest >> transpile_program: selector [
	|transpiler|
	transpiler := (SWMBTofJS new: self class>>selector with: { self class })
		logging: true;
		yourself.
	transpiler stream newline: String cr.
	transpiler decode; transpile.
	^ transpiler

]
