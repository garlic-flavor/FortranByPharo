Extension { #name : #FullBlockClosure }

{ #category : #'*SWFortranByPharo-Client' }
FullBlockClosure >> transpileUsing: arg1 [

	^ self sourceNode transpileUsing: arg1
]
