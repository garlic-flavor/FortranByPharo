Extension { #name : #DateAndTime }

{ #category : #'*SWFortranByPharo-ClientServer' }
DateAndTime >> prettyPrint [
	^ String streamContents: [:s|
		BasicDatePrinter default printYMD: self withLeadingSpace: false on: s.
		s << ' '.
		BasicDatePrinter default printHMS: self separatedBy: $: on: s.
	]
]
