Extension { #name : #ZnMessage }

{ #category : #'*SWFortranByPharo-Base' }
ZnMessage >> toByteArray [
	^ ByteArray streamContents: [ :s | self writeOn: s ]

]

{ #category : #'*SWFortranByPharo-Base' }
ZnMessage >> toString [
	^ String streamContents: [ :s | self writeOn: s ]

]
