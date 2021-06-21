"
This convery the information about each process.
"
Class {
	#name : #SWBuildingEachResult,
	#superclass : #SWShellResult,
	#instVars : [
		'source',
		'output'
	],
	#category : #'SWFortranByPharo-Server-Builder'
}

{ #category : #accessing }
SWBuildingEachResult >> output [

	^ output
]

{ #category : #accessing }
SWBuildingEachResult >> output: anObject [

	output := anObject
]

{ #category : #accessing }
SWBuildingEachResult >> source [

	^ source
]

{ #category : #accessing }
SWBuildingEachResult >> source: anObject [

	source := anObject
]
