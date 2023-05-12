"
I implement Fortran specific functionality.
My main functionalities are in class side of me.
"
Class {
	#name : #'SWStd_OLD',
	#superclass : #Object,
	#category : #'SWFortranByPharo-ClientServer-Common'
}

{ #category : #'code generation' }
SWStd_OLD class >> import: identifiers from: aFile [
]

{ #category : #printing }
SWStd_OLD class >> print: msg [
	Transcript show: msg; cr.
]

{ #category : #'as yet unclassified' }
SWStd_OLD class >> transpile_selfClass: ct [
	ct
		senderTranspilerOf: #print: is: [ :bt | bt putStdOut ];
		senderTranspilerOf: #import:from: is: [ :bt | 
			bt putImport: (bt children second children collect: [ :child | child node value asString ])
			from: bt children third node value asString
		]

]
