Class {
	#name : #SWTerminalMorphReaderWriter,
	#superclass : #Stream,
	#instVars : [
		'morph'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'instance creation' }
SWTerminalMorphReaderWriter class >> new [
	^ self basicNew
]

{ #category : #testing }
SWTerminalMorphReaderWriter >> atEnd [
	"Answer whether the receiver can access any more objects."

	^ true
]

{ #category : #accessing }
SWTerminalMorphReaderWriter >> contents [
	"Answer all of the contents of the receiver."

	^ self morph text
]

{ #category : #accessing }
SWTerminalMorphReaderWriter >> morph [

	^ morph
]

{ #category : #accessing }
SWTerminalMorphReaderWriter >> morph: anObject [

	morph := anObject
]

{ #category : #accessing }
SWTerminalMorphReaderWriter >> next [
	"Answer the next object accessible by the receiver."

	self error: 'should not be called'
]

{ #category : #accessing }
SWTerminalMorphReaderWriter >> nextPut: anObject [
	"Insert the argument, anObject, as the next object accessible by the
	receiver. Answer anObject."

	self error: 'should not be called'
]
