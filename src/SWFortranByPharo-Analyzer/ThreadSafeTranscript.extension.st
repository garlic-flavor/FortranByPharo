Extension { #name : #ThreadSafeTranscript }

{ #category : #'*SWFortranByPharo-Analyzer' }
ThreadSafeTranscript class >> initializeInstanceSideTranspiler: aCT [
	aCT targetClass isInstanceSide ifTrue: [
 		aCT
			defineMethodReturnsReceiver: #show:;
			defineMethodReturnsReceiver: #cr
	]
]