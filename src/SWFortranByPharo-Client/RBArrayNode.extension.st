Extension { #name : #RBArrayNode }

{ #category : #'*SWFortranByPharo-Client' }
RBArrayNode >> transpileUsing: arg1 [

	^ self statements transpileUsing: arg1
]
