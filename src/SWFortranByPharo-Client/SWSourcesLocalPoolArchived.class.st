Class {
	#name : #SWSourcesLocalPoolArchived,
	#superclass : #SWSourcesLocalPool,
	#instVars : [
		'zip'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #public }
SWSourcesLocalPoolArchived >> get: arg1 [

	^ self sources at: arg1 ifAbsent: [ 
		  | tmp2 |
		  tmp2 := super get: arg1.
		  tmp2
			  putOn: self;
			  yourself ]
]

{ #category : #public }
SWSourcesLocalPoolArchived >> nextPut: arg1 [

	| tmp2 |
	tmp2 := ZipStringMember new.
	tmp2
		localFileName: arg1 filename;
		contents: arg1 contents.
	self zip addMember: tmp2 yourself
]

{ #category : #writing }
SWSourcesLocalPoolArchived >> writeToFile: arg1 [

	self zip writeToFile: arg1
]

{ #category : #accessing }
SWSourcesLocalPoolArchived >> zip [

	^ zip ifNil: [ zip := ZipArchive new ] ifNotNil: [ zip ]
]

{ #category : #accessing }
SWSourcesLocalPoolArchived >> zip: arg1 [

	zip := arg1
]
