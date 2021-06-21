"
This convey the result of the building process.
"
Class {
	#name : #SWBuildingResult,
	#superclass : #SWShellResult,
	#instVars : [
		'results'
	],
	#category : #'SWFortranByPharo-Server-Builder'
}

{ #category : #initialization }
SWBuildingResult >> initialize [ 
	super initialize.
	self isSuccess: true.
	results := OrderedCollection new.
]

{ #category : #accessing }
SWBuildingResult >> lastOutput [
	^ results ifNotEmpty: [
		results last output.
	]
]

{ #category : #'instance creation' }
SWBuildingResult >> put: eachResult [
	results add: eachResult.
	self isSuccess: (self isSuccess and: [eachResult isSuccess]).
	self message: eachResult message.
]

{ #category : #accessing }
SWBuildingResult >> results [

	^ results
]

{ #category : #accessing }
SWBuildingResult >> results: anObject [

	results := anObject
]
