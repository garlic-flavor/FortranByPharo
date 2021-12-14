"
I hold type information about a class to transpile.

"
Class {
	#name : #SWClassInfo,
	#superclass : #Object,
	#instVars : [
		'targetClass',
		'members',
		'sourceHash',
		'slot'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #adding }
SWClassInfo >> addMember: aMethodInfo [
	"Add aMethodInfo to my list to be transpiled."
	self addMember: aMethodInfo ifAbsent: nil.

]

{ #category : #adding }
SWClassInfo >> addMember: aMethodInfo ifAbsent: absentBlock [
	"Add aMethodInfo to my list to be transpiled."
	
	self members at: aMethodInfo mangledName ifAbsent: [
		aMethodInfo classInfo: self.
		self members at: aMethodInfo mangledName put: aMethodInfo.
		absentBlock value.
	].

]

{ #category : #accessing }
SWClassInfo >> getVariableInfoAt: offset [
	"Return SWVariableInfo in slots at offset."
	^ self slot atOffset: offset.
]

{ #category : #accessing }
SWClassInfo >> getVariableInfoOf: aName [
	"Return SWVariableInfo searched by its name."
	self halt.
"
	^ self targetClass slots detect: [ :each | each name = aName ] ifFound: [ :detected |
		self members at: aName ifAbsentPut: [
			(self class analyzerClass new: aName asSymbol types: { self targetClass }) return
		]
	] ifNone: [
		nil
	]
"

]

{ #category : #accessing }
SWClassInfo >> members [
	"A Dictionary that contains SWMethodInfo to be transpiled, with its mangled name as key."

	^ members ifNil: [ members := Dictionary new ]
]

{ #category : #accessing }
SWClassInfo >> members: anObject [

	members := anObject
]

{ #category : #accessing }
SWClassInfo >> slot [

	^ slot ifNil: [
		slot := SWSlot newFrom: (
			self targetClass slots collect: [ :assoc |
				SWVariableInfo new
					name: assoc name;
					yourself
			])
	]
]

{ #category : #accessing }
SWClassInfo >> slot: anObject [

	slot := anObject
]

{ #category : #accessing }
SWClassInfo >> sourceHash [
	"Return an accumulated hash consists of whole source code of targetClass."

	^ sourceHash ifNil: [
		sourceHash := SHA256 hashMessage: ((self members collect: [:each |
			SHA256 hashMessage: each method sourceCode
		]) flattened)
	]
]

{ #category : #accessing }
SWClassInfo >> targetClass [

	^ targetClass
]

{ #category : #accessing }
SWClassInfo >> targetClass: anObject [

	targetClass := anObject
]
