Class {
	#name : #SWMethodInfo,
	#superclass : #SymbolicBytecodeBuilder,
	#instVars : [
		'mangledName',
		'stack',
		'return',
		'sourceHash',
		'classInfo',
		'numTemps'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'instance creation' }
SWMethodInfo class >> new: arg1 types: arg2 [

	| tmp2 |
	tmp2 := self new.
	tmp2
		method: (self search: arg1 in: arg2 first);
		types: arg2.
	^ tmp2 yourself
]

{ #category : #utils }
SWMethodInfo class >> safeSelectorNameOf: arg1 [

	arg1 = '=' ifTrue: [ ^ 'opEqual_' ].
	arg1 = '~=' ifTrue: [ ^ 'opNotEqual_' ].
	arg1 = ',' ifTrue: [ ^ 'opCamma_' ].
	arg1 = '->' ifTrue: [ ^ 'opArrow_' ].
	arg1 = '/' ifTrue: [ ^ 'opDiv_' ].
	arg1 = '<<' ifTrue: [ ^ 'opWrite_' ].
	arg1 = '+' ifTrue: [ ^ 'opPlus_' ].
	^ arg1 collect: [ :arg2 | 
		  (#' >#:/' anySatisfy: [ :arg3 | arg3 = arg2 ])
			  ifTrue: [ $_ ]
			  ifFalse: [ arg2 ] ]
]

{ #category : #utils }
SWMethodInfo class >> search: arg1 in: arg2 [

	^ arg2 ifNotNil: [ 
		  arg2 methodDict
			  at: arg1
			  ifAbsent: [ self search: arg1 in: arg2 superclass ] ]
]

{ #category : #comparing }
SWMethodInfo >> = arg1 [

	self method = arg1 method ifFalse: [ ^ false ].
	self arguments
		with: arg1 arguments
		do: [ :arg2 :arg3 | arg2 type = arg3 type ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #adding }
SWMethodInfo >> addLocalVariable: arg1 [

	self stack push: arg1 afterIndex: self numTemps.
	self numTemps: self numTemps + 1.
	arg1 stackPos: self numTemps
]

{ #category : #accessing }
SWMethodInfo >> allTemps [

	^ self stack copyFrom: 1 to: self numTemps
]

{ #category : #accessing }
SWMethodInfo >> arguments [

	^ self stack copyFrom: 1 to: self method numArgs
]

{ #category : #accessing }
SWMethodInfo >> classInfo [

	^ classInfo
]

{ #category : #accessing }
SWMethodInfo >> classInfo: arg1 [

	classInfo := arg1
]

{ #category : #testing }
SWMethodInfo >> hasExplicitReturn [

	^ self return stackPos ~=  -1
]

{ #category : #comparing }
SWMethodInfo >> hash [

	| tmp2 |
	tmp2 := OrderedCollection new.
	tmp2
		add: self method hash;
		addAll: (self arguments collect: [ :arg1 | arg1 type hash ]).
	^ tmp2 hash
]

{ #category : #accessing }
SWMethodInfo >> locals [

	^ self stack copyFrom: self method numArgs + 1 to: self numTemps
]

{ #category : #accessing }
SWMethodInfo >> mangledName [

	^ mangledName
		  ifNil: [ 
			  mangledName := String streamContents: [ :arg1 | 
				                 | tmp1 |
				                 tmp1 := self method methodClass.
				                 tmp1 class = Metaclass
					                 ifTrue: [ 
						                 arg1
							                 << tmp1 soleInstance name;
							                 << 'C' ]
					                 ifFalse: [ 
						                 arg1
							                 << tmp1 name;
							                 << '_' ].
				                 arg1
					                 <<
						                 (self class safeSelectorNameOf:
								                  self method selector);
					                 <<
						                 (self arguments collect: [ :arg2 | 
								                  arg2 mangledTypeName ]) ] ]
		  ifNotNil: [ mangledName ]
]

{ #category : #accessing }
SWMethodInfo >> mangledName: arg1 [

	mangledName := arg1
]

{ #category : #accessing }
SWMethodInfo >> name [

	^ self method selector asString
]

{ #category : #accessing }
SWMethodInfo >> numTemps [

	^ numTemps
		  ifNil: [ numTemps := self method numTemps ]
		  ifNotNil: [ numTemps ]
]

{ #category : #accessing }
SWMethodInfo >> numTemps: arg1 [

	numTemps := arg1
]

{ #category : #accessing }
SWMethodInfo >> return [

	^ return ifNil: [ return := SWVariableInfo new ] ifNotNil: [ return ]
]

{ #category : #accessing }
SWMethodInfo >> return: arg1 [

	return := arg1
]

{ #category : #accessing }
SWMethodInfo >> sourceHash [

	^ sourceHash
		  ifNil: [ sourceHash := SHA256 hashMessage: self method sourceCode ]
		  ifNotNil: [ sourceHash ]
]

{ #category : #accessing }
SWMethodInfo >> stack [

	^ stack
		  ifNil: [ 
			  | tmp2 |
			  stack := SWStack new.
			  self method numTemps + 1 timesRepeat: [ 
				  stack push: SWVariableInfo new ].
			  tmp2 := stack at: 0.
			  tmp2
				  name: 'self';
				  stackPos: 0.
			  self method temporaryVariables doWithIndex: [ :arg1 :arg2 | 
				  | tmp4 |
				  tmp4 := stack at: arg2.
				  tmp4
					  name: arg1 name;
					  stackPos: arg2 ].
			  stack ]
		  ifNotNil: [ stack ]
]

{ #category : #accessing }
SWMethodInfo >> stack: arg1 [

	stack := arg1
]

{ #category : #accessing }
SWMethodInfo >> types: arg1 [

	arg1 doWithIndex: [ :arg2 :arg3 | 
		(self stack at: arg3 - 1) type: arg2 ]
]

{ #category : #accessing }
SWMethodInfo >> variableInfoOf: arg1 [

	^ self stack
		  detect: [ :arg2 | arg2 name = arg1 ]
		  ifNone: [ self classInfo variableInfoOf: arg1 ]
]
