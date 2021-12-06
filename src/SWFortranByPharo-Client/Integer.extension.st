Extension { #name : #Integer }

{ #category : #'*SWFortranByPharo-Client' }
Integer >> transpileUsing: arg1 [

	| tmp1 |
	^ arg1 putInteger: self
]
