Class {
	#name : #SWClassInfo,
	#superclass : #Object,
	#instVars : [
		'targetClass',
		'members',
		'sourceHash'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #accessing }
SWClassInfo class >> analyzerClass [

	^ SWStackAnalyzer
]

{ #category : #accessing }
SWClassInfo >> getVariableInfoAt: arg1 [

	^ self getVariableInfoOf: (self targetClass slots at: arg1 + 1) name
]

{ #category : #accessing }
SWClassInfo >> getVariableInfoOf: arg1 [

	^ ((self targetClass slots collect: [ :arg2 | arg2 name ]) 
		   anySatisfy: [ :arg3 | arg3 = arg1 ]) ifTrue: [ 
		  self members at: arg1 ifAbsentPut: [ 
			  (self class analyzerClass
				   new: arg1 asSymbol
				   types: { self targetClass }) return ] ]
]

{ #category : #accessing }
SWClassInfo >> members [

	^ members ifNil: [ members := Dictionary new ] ifNotNil: [ members ]
]

{ #category : #accessing }
SWClassInfo >> members: arg1 [

	members := arg1
]

{ #category : #accessing }
SWClassInfo >> sourceHash [

	^ sourceHash
		  ifNil: [ 
			  sourceHash := SHA256 hashMessage:
				                ((self targetClass methods collect: [ :arg1 | 
					                  SHA256 hashMessage: arg1 sourceCode ]) 
					                 flatCollect: [ :arg2 | arg2 ]) ]
		  ifNotNil: [ sourceHash ]
]

{ #category : #accessing }
SWClassInfo >> targetClass [

	^ targetClass
]

{ #category : #accessing }
SWClassInfo >> targetClass: arg1 [

	targetClass := arg1
]
