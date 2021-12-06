Class {
	#name : #SWProjectOld,
	#superclass : #Object,
	#instVars : [
		'client',
		'pool',
		'moduleName',
		'args',
		'type'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #'instance creation' }
SWProjectOld class >> of: arg1 [

	arg1 = #mjs ifTrue: [ ^ SWProjectOfJs new ].
	arg1 = #f90 ifTrue: [ ^ SWProjectOfFortran new ].
	self
		flag: #ToImplement;
		halt
]

{ #category : #accessing }
SWProjectOld >> args [

	^ args ifNil: [ args := {  } ] ifNotNil: [ args ]
]

{ #category : #accessing }
SWProjectOld >> args: arg1 [

	args := arg1
]

{ #category : #accessing }
SWProjectOld >> client [

	^ client ifNil: [ client := SWClient new ] ifNotNil: [ client ]
]

{ #category : #accessing }
SWProjectOld >> client: arg1 [

	client := arg1
]

{ #category : #running }
SWProjectOld >> go [

	^ self subclassResponsibility
]

{ #category : #running }
SWProjectOld >> goDomestic [

	| tmp1 tmp3 |
	tmp3 := Smalltalk globals at: self moduleName.
	tmp1 := tmp3
		        ifNil: [ (self pool get: self moduleName) programClass ]
		        ifNotNil: [ tmp3 ].
	^ tmp1 program
]

{ #category : #initialization }
SWProjectOld >> initialize [

	super initialize
]

{ #category : #accessing }
SWProjectOld >> moduleName [

	^ moduleName
]

{ #category : #accessing }
SWProjectOld >> moduleName: arg1 [

	moduleName := arg1
]

{ #category : #accessing }
SWProjectOld >> pool [

	^ pool
		  ifNil: [ 
			  | tmp2 |
			  tmp2 := SWSourcesPool new.
			  tmp2
				  type: self type;
				  client: self client.
			  pool := tmp2 yourself ]
		  ifNotNil: [ pool ]
]

{ #category : #accessing }
SWProjectOld >> pool: arg1 [

	pool := arg1
]

{ #category : #accessing }
SWProjectOld >> type [

	^ type
]

{ #category : #accessing }
SWProjectOld >> type: arg1 [

	type := arg1
]
