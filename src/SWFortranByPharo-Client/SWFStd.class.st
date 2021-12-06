Class {
	#name : #SWFStd,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Client-DomainSpecific'
}

{ #category : #'as yet unclassified' }
SWFStd class >> a_declare_With: arg1 Using: arg2 [

	
]

{ #category : #'code generation - property' }
SWFStd class >> declare: arg1 [

	^ arg1
		  detect: [ :arg2 | arg2 isAssociation and: [ arg2 key = #value ] ]
		  ifFound: [ :arg3 | arg3 value ]
		  ifNone: [  ]
]

{ #category : #'code generation - property' }
SWFStd class >> f90_declare_With: arg1 Using: arg2 [

	
]

{ #category : #'as yet unclassified' }
SWFStd class >> f90_print_With: arg1 Using: arg2 [

	arg2
		put: 'print *, ';
		transpile: (arg1 at: 1)
]

{ #category : #printing }
SWFStd class >> print: arg1 [

	Transcript
		show: arg1;
		cr
]

{ #category : #'as yet unclassified' }
SWFStd class >> toTranspile [

	^ #module
]
