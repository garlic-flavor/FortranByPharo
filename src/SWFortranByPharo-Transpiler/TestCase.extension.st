Extension { #name : #TestCase }

{ #category : #'*SWFortranByPharo-Transpiler' }
TestCase class >> initializeClassSideTranspiler: transpiler [
	transpiler
		setBreakpointOn: #suite;
		defineMethod: #allTestSelectors as: [ :newT |
			newT
				specifyReturnTypeAs: OrderedCollection;
				bodyGenerator: [ :t |
					self halt; flag: #toImplement
				];
				markAsDecoded;
				yourself
		]
]
