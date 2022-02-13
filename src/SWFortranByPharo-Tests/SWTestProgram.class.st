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

{ #category : #acccessing }
SWTestProgram class >> getMy: no [
	|header|
	header := String streamContents: [ :s |
		s << $_; << (no asString padLeftTo: 2 with: $0)
	].
	self methodDict valuesDo: [ :val |
		(val selector beginsWith: header) ifTrue: [ ^ val ]
	].
	self error.
]

{ #category : #'tests - source' }
SWTestProgram >> _01_return_constant [

	^ 345
]

{ #category : #'tests - source' }
SWTestProgram >> _02_has_arguments: arg [
	^ arg
]

{ #category : #'tests - source' }
SWTestProgram >> _03_return_self [
	^ self
]

{ #category : #'tests - source' }
SWTestProgram >> _04_call_wellknown_message: arg1 [

	| tmp1 |
	tmp1 := 123.
	^ arg1 + tmp1
]

{ #category : #'tests - source' }
SWTestProgram >> _05_ifTrue_ifFalse: needle [
	needle ifTrue: [ 123 ] ifFalse: [ 'False' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _06_ifTrue_ifFalse_expression: needle [
	^ needle ifTrue: [ 123 ] ifFalse: [ 'False' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _07_ifTrue_ifFalse_shortcircuit: needle [
	needle ifTrue: [ ^ 123 ] ifFalse: [ ^ 'False' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _08_ifFalse_ifTrue: needle [
	needle ifFalse: [ 123 ] ifTrue: [ 'True' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _09_ifFalse_ifTrue_expression: needle [
	^ needle ifFalse: [ 123 ] ifTrue: [ 'True' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _10_ifFalse_ifTrue_shortcircuit: needle [
	needle ifFalse: [ ^ 123 ] ifTrue: [ ^ 'True' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _11_ifTrue: needle [
	needle ifTrue: [ 123 ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _12_ifTrue_shortcircuit: needle [
	needle ifTrue: [ ^ 123 ].
	^ 'false'
	
]

{ #category : #'tests - source' }
SWTestProgram >> _13_ifFalse: needle [
	needle ifFalse: [ 123 ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _14_ifFalse_shortcircuit: needle [
	needle ifFalse: [ ^ 123 ].
	^ 'true'
	
]

{ #category : #'tests - source' }
SWTestProgram >> _15_ifNotNil_ifNil: needle [
	needle ifNotNil: [ 123 ] ifNil: [ 'Nil' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _16_ifNotNil_ifNil_expression: needle [
	^ needle ifNotNil: [ 123 ] ifNil: [ 'Nil' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _17_ifNotNil_ifNil_shortcircuit: needle [
	needle ifNotNil: [ ^ 123 ] ifNil: [ ^ 'Nil' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _18_ifNil_ifNotNil: needle [
	needle ifNil: [ 123 ] ifNotNil: [ 'NotNil' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _19_ifNil_ifNotNil_expression: needle [
	^ needle ifNil: [ 123 ] ifNotNil: [ 'NotNil' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _20_ifNil_ifNotNil_shortcircuit: needle [
	needle ifNil: [ ^ 123 ] ifNotNil: [ ^ 'NotNil' ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _21_ifNil: needle [
	needle ifNil: [ 123 ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _22_ifNil_expression: needle [
	^ needle ifNil: [ 123 ]
	
]

{ #category : #'tests - source' }
SWTestProgram >> _23_ifNil_shortcircuit: needle [
	needle ifNil: [ ^ 123 ].
	^ 'notnil'
	
]

{ #category : #'tests - source' }
SWTestProgram >> _24_ifNil_accessor [
	^ var1 ifNil: [ var1 := 123 ]

	
]

{ #category : #'tests - source' }
SWTestProgram >> _25_ifNotNil: needle [
	needle ifNotNil: [ 123 ]

	
]

{ #category : #'tests - source' }
SWTestProgram >> _26_ifNotNil_expression: needle [
	^ needle ifNotNil: [ 123 ]

	
]

{ #category : #'tests - source' }
SWTestProgram >> _27_ifNotNil_shortcircuit: needle [
	needle ifNotNil: [ ^ 123 ].
	^ 'nil'

	
]

{ #category : #'tests - source' }
SWTestProgram >> _28_method_call [
	^ SWStd print: 'hoge!'
]

{ #category : #'tests - source' }
SWTestProgram >> _29_local_variables [

	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 |

	^ tmp9 := 123
]

{ #category : #'tests - source' }
SWTestProgram >> _30_recursive_message_call: arg1 [

	^ 0 < arg1
		  ifTrue: [ arg1 + (self _30_recursive_message_call: arg1 - 1) ]
		  ifFalse: [ 0 ]
]

{ #category : #'tests - source' }
SWTestProgram >> _31_new: arg1 [
	|loc1 loc2|
	loc1 := Dictionary new.
	loc2 := Set new.
	^ loc2
]

{ #category : #'tests - source' }
SWTestProgram >> _32_return_literal [
	|dict url|
	dict := Dictionary new.
	dict at: 'fuga' put: (url ifNil: [ 'hoge' ]).
	^ dict
]

{ #category : #'tests - source' }
SWTestProgram >> _33_try_catch [

	[  
		1 + 2
	] on: Exception do: [
		self error
	]
]

{ #category : #'tests - source' }
SWTestProgram >> _34_try_catch_expression [

	^ [  
		1 + 2
	] on: Exception do: [
		self error
	]
]

{ #category : #'tests - source' }
SWTestProgram >> _35_try_catch_shortcircuit [

	 [  
		^ 1 + 2
	] on: Exception do: [
		self error
	].
	^ 'false'
]

{ #category : #'tests - source' }
SWTestProgram >> _36_ensure [
	[ 
		123
	] ensure: [ 'hoge' ]
]

{ #category : #'tests - source' }
SWTestProgram >> _37_ensure_expression [
	^ [ 
		123
	] ensure: [ 'hoge' ]
]

{ #category : #'tests - source' }
SWTestProgram >> _38_ensure_shortcircuit [
	[ 
		^ 123
	] ensure: [ 'hoge' ].
	^ 'false'
]

{ #category : #accessing }
SWTestProgram >> var1 [

	^ var1
]

{ #category : #accessing }
SWTestProgram >> var1: anObject [

	var1 := anObject
]
