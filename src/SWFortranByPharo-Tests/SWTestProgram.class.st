"
I'm a test class for SWDecoderTest.
"
Class {
	#name : #SWTestProgram,
	#superclass : #Object,
	#instVars : [
		'var1'
	],
	#category : #'SWFortranByPharo-Tests'
}

{ #category : #'as yet unclassified' }
SWTestProgram class >> getBySelector: aSelector [
	^ self getMy: ((aSelector copyAfter: $_) copyUpTo: $_) asInteger.

]

{ #category : #acccessing }
SWTestProgram class >> getMy: no [
	|header|
	header := String streamContents: [ :s |
		s << $_; << (no asString padLeftTo: 4 with: $0)
	].
	self methodDict valuesDo: [ :val |
		(val selector beginsWith: header) ifTrue: [ ^ val ]
	].
	self error.
]

{ #category : #'tests - source' }
SWTestProgram >> _0010_nop [
]

{ #category : #'tests - source' }
SWTestProgram >> _0020_return_constant [

	^ 345
]

{ #category : #'tests - source' }
SWTestProgram >> _0030_has_arguments: arg [
	^ arg
]

{ #category : #'tests - source' }
SWTestProgram >> _0040_local_variables [

	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 |

	^ tmp9 := 123
]

{ #category : #'tests - source' }
SWTestProgram >> _0050_call_wellknown_message: arg1 [

	| tmp1 |
	tmp1 := 123.
	^ arg1 + tmp1
]

{ #category : #'tests - source' }
SWTestProgram >> _0060_ifTrue_ifFalse: needle [
	needle ifTrue: [ 123 ] ifFalse: [ 'False' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0070_ifTrue_ifFalse_expression: needle [
	^ needle ifTrue: [ 123 ] ifFalse: [ 'False' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0080_ifTrue_ifFalse_shortcircuit: needle [
	needle ifTrue: [ ^ 123 ] ifFalse: [ ^ 'False' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0090_ifFalse_ifTrue: needle [
	needle ifFalse: [ 123 ] ifTrue: [ 'True' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0100_ifFalse_ifTrue_expression: needle [
	^ needle ifFalse: [ 123 ] ifTrue: [ 'True' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0110_ifFalse_ifTrue_shortcircuit: needle [
	needle ifFalse: [ ^ 123 ] ifTrue: [ ^ 'True' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0120_ifTrue: needle [
	needle ifTrue: [ 123 ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0130_ifTrue_shortcircuit: needle [
	needle ifTrue: [ ^ 123 ].
	^ 'false'
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0140_ifFalse: needle [
	needle ifFalse: [ 123 ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0150_ifFalse_shortcircuit: needle [
	needle ifFalse: [ ^ 123 ].
	^ 'true'
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0160_ifNotNil_ifNil: needle [
	needle ifNotNil: [ 123 ] ifNil: [ 'Nil' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0170_ifNotNil_ifNil_expression: needle [
	^ needle ifNotNil: [ 123 ] ifNil: [ 'Nil' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0180_ifNotNil_ifNil_shortcircuit: needle [
	needle ifNotNil: [ ^ 123 ] ifNil: [ ^ 'Nil' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0190_ifNil_ifNotNil: needle [
	needle ifNil: [ 123 ] ifNotNil: [ 'NotNil' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0200_ifNil_ifNotNil_expression: needle [
	^ needle ifNil: [ 123 ] ifNotNil: [ 'NotNil' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0210_ifNil_ifNotNil_shortcircuit: needle [
	needle ifNil: [ ^ 123 ] ifNotNil: [ ^ 'NotNil' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0220_ifNotNil: needle [
	needle ifNotNil: [ 123 ]

	
]

{ #category : #'tests - source' }
SWTestProgram >> _0230_ifNotNil_expression: needle [
	^ needle ifNotNil: [ 123 ]

	
]

{ #category : #'tests - source' }
SWTestProgram >> _0240_ifNotNil_shortcircuit: needle [
	needle ifNotNil: [ ^ 123 ].
	^ 'nil'

	
]

{ #category : #'tests - source' }
SWTestProgram >> _0250_ifNil: needle [
	needle ifNil: [ 123 ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0260_ifNil_expression: needle [
	^ needle ifNil: [ 123 ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0270_ifNil_shortcircuit: needle [
	needle ifNil: [ ^ 123 ].
	^ 'notnil'
	
]

{ #category : #'tests - source' }
SWTestProgram >> _0280_ifNil_accessor [
	^ var1 ifNil: [ var1 := 123 ]

	
]

{ #category : #'tests - source' }
SWTestProgram >> _0290_method_call [
	^ SWStd print: 'hoge!'
]

{ #category : #'tests - source' }
SWTestProgram >> _0300_recursive_message_call: arg1 [

	^ 0 < arg1
		  ifTrue: [ arg1 + (self _0300_recursive_message_call: arg1 - 1) ]
		  ifFalse: [ 0 ]
]

{ #category : #'tests - source' }
SWTestProgram >> _0310_new: arg1 [
	|loc1 loc2|
	loc1 := Dictionary new.
	loc2 := Set new.
	^ loc2
]

{ #category : #'tests - source' }
SWTestProgram >> _0320_return_literal [
	|dict url|
	dict := Dictionary new.
	dict at: 'fuga' put: (url ifNil: [ 'hoge' ]).
	^ dict
]

{ #category : #'tests - source' }
SWTestProgram >> _0330_try_catch [

	[  
		1 + 2
	] on: Exception do: [
		self error
	]
]

{ #category : #'tests - source' }
SWTestProgram >> _0340_try_catch_expression [

	^ [  
		1 + 2
	] on: Exception do: [
		self error
	]
]

{ #category : #'tests - source' }
SWTestProgram >> _0350_try_catch_shortcircuit [

	 [  
		^ 1 + 2
	] on: Exception do: [
		self error
	].
	^ 'false'
]

{ #category : #'tests - source' }
SWTestProgram >> _0360_ensure [
	[ 
		123
	] ensure: [ 'hoge' ]
]

{ #category : #'tests - source' }
SWTestProgram >> _0370_ensure_expression [
	^ [ 
		123
	] ensure: [ 'hoge' ]
]

{ #category : #'tests - source' }
SWTestProgram >> _0380_ensure_shortcircuit [
	[ 
		^ 123
	] ensure: [ 'hoge' ].
	^ 'false'
]

{ #category : #'tests - source' }
SWTestProgram >> _0390_opBinaries: a [
	^ a + 100 * 200 - 300 / 400
]

{ #category : #'tests - source' }
SWTestProgram >> _0400_cascading: uri [
	^ (SWServerStatus new
		failed;
		message: 'hogehoge';
		uri: uri;
		yourself) toString

]

{ #category : #'tests - source' }
SWTestProgram >> _0410_call_Transcript [

	Transcript
		show: 'Hello, good-bye!';
		cr;
		cr
]

{ #category : #'tests - source' }
SWTestProgram >> _0420_closure_local_variable [

	[ |hoge|
		hoge := 123.
	] on: Exception do: [ 
		self error.
	]
]

{ #category : #'tests - source' }
SWTestProgram >> _0430_ifTrue_and_local_variable [
	|outervar|
	outervar := true.
	outervar ifTrue: [|inner| 
		inner := 234.
		^ inner
	].
	^ outervar
]

{ #category : #'tests - source' }
SWTestProgram >> _0440_locals: arg1 [
	|outer1|
	outer1 := true.
	^ outer1 ifTrue: [|inner|
		inner := 234.
	] ifFalse: [ |inner inner2|
		inner := 345.
		inner2 := 'hello'
	]
]

{ #category : #'tests - source' }
SWTestProgram >> _0450_locals2: arg1 [
	|outer0 outer1 outer2 outer3|
	outer1 := true.
	[ :arg2| |inner1|
		outer1 ifTrue: [|inner2|
			inner1 := 'hoge'.
			^ inner2 := 234.
		].
	] value: 345.
]

{ #category : #'tests - source' }
SWTestProgram >> _0460_access_to_local_variables [
	|tp|
	tp := SWTestProgram new.
	tp var1: 123.
	^ tp var1
]

{ #category : #'tests - source' }
SWTestProgram >> _0470_user_specified_variable_type [

	| tmp1 |
	SWType declare: #tmp1 as: Integer.
	tmp1 := 3.14159265358979.

	^ tmp1 * 2.23620679
]

{ #category : #'tests - source' }
SWTestProgram >> _1010_SWShellEnvironemt_default [
	^ SWShellEnvironment default

]

{ #category : #'tests - source' }
SWTestProgram >> _1020_SWShellEnvironemtLocalDirectory [
	^ SWShellEnvironment default localDirectory

]

{ #category : #'tests - source' }
SWTestProgram >> _1030_SWShell_class_execute [
	^ SWShell execute: 'echo hoge'

]

{ #category : #'tests - source' }
SWTestProgram >> _1040_TestCase [
	^ TestCase selector: 'hoge'
]

{ #category : #'tests - source' }
SWTestProgram >> _1050_ZnServerClass_default [

	ZnServer startDefaultOn: 50000.
	^ ZnServer default
]

{ #category : #'tests - source' }
SWTestProgram >> _1060_SWServerClass_starton [

	^ SWServer start
]

{ #category : #'tests - source' }
SWTestProgram >> _1070_SWShellEnvironment [
	^ self assert: (SWShellEnvironment default localDirectory fullName endsWith: 'hoge')
]

{ #category : #accessing }
SWTestProgram >> var1 [

	^ var1
]

{ #category : #accessing }
SWTestProgram >> var1: anObject [

	var1 := anObject
]
