Extension { #name : #ThreadSafeTranscript }

{ #category : #'*SWFortranByPharo-Client' }
ThreadSafeTranscript class >> initializeInstanceSideTranspiler: aCT [
	aCT targetClass isInstanceSide ifTrue: [
 		aCT
			defineMethodReturnsReceiver: #show:;
			defineMethodReturnsReceiver: #cr
	]
]
