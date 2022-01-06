"
I make a zip directory.
"
Class {
	#name : #SWSourcesLocalPoolArchivedOld,
	#superclass : #SWSourcesLocalPoolOld,
	#instVars : [
		'zip'
	],
	#category : #'SWFortranByPharo-Client-Deprecated-Client-Deprecated'
}

{ #category : #public }
SWSourcesLocalPoolArchivedOld >> get: aModuleName [
	^ self sources at: aModuleName ifAbsent: [
		(super get: aModuleName)
			putOn: self;
			yourself
	]
]

{ #category : #public }
SWSourcesLocalPoolArchivedOld >> nextPut: aSource [
	self zip addMember: (ZipStringMember new
		localFileName: aSource filename;
		contents: aSource contents;
		yourself)
]

{ #category : #writing }
SWSourcesLocalPoolArchivedOld >> writeToFile: aPath [
	self zip writeToFile: aPath
]

{ #category : #accessing }
SWSourcesLocalPoolArchivedOld >> zip [

	^ zip ifNil: [ zip := ZipArchive new ]
]

{ #category : #accessing }
SWSourcesLocalPoolArchivedOld >> zip: anObject [

	zip := anObject
]
