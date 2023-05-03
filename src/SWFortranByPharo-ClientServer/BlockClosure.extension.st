Extension { #name : #BlockClosure }

{ #category : #'*SWFortranByPharo-ClientServer' }
BlockClosure >> redirectErrToOut [
	^ [ :first :second :third |
		self value: first value: second value: second
	]
]
