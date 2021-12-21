"
I store a method information to generate SWCompiledCodeInfo.
"
Class {
	#name : #SWMethodFinder,
	#superclass : #Object,
	#instVars : [
		'selector',
		'args',
		'method'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #utils }
SWMethodFinder class >> search: selector in: aClass [
	aClass ifNil: [ self error ].

	^ aClass methodDict at: selector ifAbsent: [
			self search: selector in: aClass superclass
	]

]

{ #category : #accessing }
SWMethodFinder >> args [

	^ args
]

{ #category : #accessing }
SWMethodFinder >> args: anObject [

	args := anObject
]

{ #category : #accessing }
SWMethodFinder >> method [

	^ method ifNil: [ method := self class search: self selector in: args first value ]
]

{ #category : #accessing }
SWMethodFinder >> method: anObject [

	method := anObject
]

{ #category : #accessing }
SWMethodFinder >> selector [

	^ selector
]

{ #category : #accessing }
SWMethodFinder >> selector: anObject [

	selector := anObject
]
