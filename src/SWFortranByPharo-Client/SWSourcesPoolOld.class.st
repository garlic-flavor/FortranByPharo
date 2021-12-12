"
I hold SWSources and put it to the server.
"
Class {
	#name : #SWSourcesPoolOld,
	#superclass : #SWSourcesLocalPoolOld,
	#instVars : [
		'client'
	],
	#category : #'SWFortranByPharo-Client-Client-Deprecated'
}

{ #category : #initialization }
SWSourcesPoolOld class >> reset [
	<script>
	localScriptDirectory := nil
]

{ #category : #accessing }
SWSourcesPoolOld >> client [

	^ client ifNil: [ client := SWClient new ]
]

{ #category : #accessing }
SWSourcesPoolOld >> client: anObject [

	client := anObject
]

{ #category : #accessing }
SWSourcesPoolOld >> get: aModuleName withTranspilerMethodOf: aMethod [
	^ self sources at: aModuleName ifAbsent: [
		(super get: aModuleName withTranspilerMethodOf: aMethod)
			putOn: self client;
			yourself
	]
]
