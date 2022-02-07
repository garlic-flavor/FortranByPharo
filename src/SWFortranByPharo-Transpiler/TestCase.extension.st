Extension { #name : #TestCase }

{ #category : #'*SWFortranByPharo-Transpiler' }
TestCase class >> initializeClassSideTranspiler: transpiler [
	transpiler
		setBreakpointOn: #suite;
		defineMethod: #allTestSelectors as: [ :newT |
			newT
				specifyReturnTypeAs: OrderedCollection;
				generator: [ :t |
					t putStatement: (RBReturnNode value: (RBLiteralArrayNode value: (
						t receiverClass instanceSide methodDict keys select: [ :each |
							each beginsWith: 'test'
						] thenCollect: [ :each |
							RBLiteralValueNode value: each
						])))
				];
				markAsDecoded;
				yourself
		]
]
