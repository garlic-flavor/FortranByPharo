Extension { #name : #DateAndTimeTest }

{ #category : #'*SWFortranByPharo-Base-Test' }
DateAndTimeTest >> testPrettyPrint [
	self assert: (DateAndTime now prettyPrint matchesRegex: '^\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2}$')

]
