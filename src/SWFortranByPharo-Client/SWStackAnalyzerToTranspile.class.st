Class {
	#name : #SWStackAnalyzerToTranspile,
	#superclass : #SWStackAnalyzer,
	#instVars : [
		'dependencies'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'instance creation' }
SWStackAnalyzerToTranspile class >> new: arg1 types: arg2 sendStack: arg3 [

	^ definedMethods
		  at: arg1
		  ifPresent: [ :arg4 | arg4 value: arg1 value: arg2 ]
		  ifAbsent: [ 
			  | tmp1 tmp3 |
			  tmp1 := self search: arg1 in: arg2 first.
			  tmp3 := (self willTranspile: tmp1)
				          ifTrue: [ self new ]
				          ifFalse: [ SWStackAnalyzer new ].
			  tmp3
				  method: tmp1;
				  types: arg2;
				  sendStack: arg3;
				  yourself ]
]

{ #category : #testing }
SWStackAnalyzerToTranspile class >> willTranspile: arg1 [

	| tmp1 |
	tmp1 := arg1 methodClass.
	tmp1 class = Metaclass ifTrue: [ tmp1 := tmp1 soleInstance ].
	^ tmp1 respondsTo: #toTranspile
]

{ #category : #accessing }
SWStackAnalyzerToTranspile >> dependencies [

	^ dependencies
		  ifNil: [ dependencies := Set new ]
		  ifNotNil: [ dependencies ]
]

{ #category : #accessing }
SWStackAnalyzerToTranspile >> dependencies: arg1 [

	dependencies := arg1
]

{ #category : #protected }
SWStackAnalyzerToTranspile >> returnInfoOf: arg1 super: arg2 args: arg3 [

	| tmp1 tmp2 |
	tmp1 := self class search: arg1 in: arg3 first type.
	^ (self class willTranspile: tmp1)
		  ifTrue: [ 
			  | tmp4 |
			  tmp4 := SWMethodInfo new.
			  tmp4
				  method: tmp1;
				  types: (arg3 collect: [ :arg4 | arg4 type ]).
			  tmp2 := tmp4 yourself.
			  (self dependencies
				   detect: [ :arg5 | arg5 = tmp2 ]
				   ifFound: [ :arg6 | arg6 ]
				   ifNone: [ 
					   self dependencies add:
						   (self methodInfoOf: arg1 super: arg2 args: arg3) ]) return ]
		  ifFalse: [ super returnInfoOf: arg1 super: arg2 args: arg3 ]
]
