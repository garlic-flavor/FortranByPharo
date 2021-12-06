Class {
	#name : #SWSourcesPool,
	#superclass : #SWSourcesLocalPool,
	#instVars : [
		'client'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #initialization }
SWSourcesPool class >> reset [

	<script>
	localScriptDirectory := nil
]

{ #category : #accessing }
SWSourcesPool >> client [

	^ client ifNil: [ client := SWClient new ] ifNotNil: [ client ]
]

{ #category : #accessing }
SWSourcesPool >> client: arg1 [

	client := arg1
]

{ #category : #accessing }
SWSourcesPool >> get: arg1 withTranspilerMethodOf: arg2 [

	^ self sources at: arg1 ifAbsent: [ 
		  | tmp2 |
		  tmp2 := super get: arg1 withTranspilerMethodOf: arg2.
		  tmp2
			  putOn: self client;
			  yourself ]
]
