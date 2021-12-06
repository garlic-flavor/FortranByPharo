"
I make a zip directory.
"
Class {
	#name : #SWSourcesLocalPoolArchived,
	#superclass : #SWSourcesLocalPool,
	#instVars : [
		'zip'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #public }
SWSourcesLocalPoolArchived >> get: aModuleName [
	^ self sources at: aModuleName ifAbsent: [
		(super get: aModuleName)
			putOn: self;
			yourself
	]
]

{ #category : #public }
SWSourcesLocalPoolArchived >> nextPut: aSource [
	self zip addMember: (ZipStringMember new
		localFileName: aSource filename;
		contents: aSource contents;
		yourself)
]

{ #category : #writing }
SWSourcesLocalPoolArchived >> writeToFile: aPath [
	self zip writeToFile: aPath
]

{ #category : #accessing }
SWSourcesLocalPoolArchived >> zip [

	^ zip ifNil: [ zip := ZipArchive new ]
]

{ #category : #accessing }
SWSourcesLocalPoolArchived >> zip: anObject [

	zip := anObject
]
