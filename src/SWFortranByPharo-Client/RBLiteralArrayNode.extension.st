Extension { #name : #RBLiteralArrayNode }

{ #category : #'*SWFortranByPharo-Client' }
RBLiteralArrayNode >> transpileUsing: arg1 [

	^ self children transpileUsing: arg1
]
