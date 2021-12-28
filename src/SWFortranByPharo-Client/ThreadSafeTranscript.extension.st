Extension { #name : #ThreadSafeTranscript }

{ #category : #'*SWFortranByPharo-Client' }
ThreadSafeTranscript class >> initializeClassTranspiler: aCT [
	aCT targetClass isInstanceSide ifTrue: [
 		aCT
			defineMethodReturnsReceiver: #show:;
			defineMethodReturnsReceiver: #cr
	]
]
