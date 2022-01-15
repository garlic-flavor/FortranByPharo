Extension { #name : #TestCase }

{ #category : #'*SWFortranByPharo-Transpiler' }
TestCase class >> initializeClassSideTranspiler: transpiler [
	transpiler
		setBreakpointOn: #suite
]
