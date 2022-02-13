"
SWMBTofF90 is an implementation of SWMethodBodyTranspiler for Fortran 90.
"
Class {
	#name : #SWMBTofF90,
	#superclass : #SWMethodBodyTranspiler,
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #accessing }
SWMBTofF90 class >> classTranspilerClass [
	^ SWCDTofF90
]

{ #category : #constants }
SWMBTofF90 class >> mangleClass [
	^ SWMangleOfF90
]

{ #category : #accessing }
SWMBTofF90 class >> methodDefinitionTranspilerClass [
	^ SWMDTofF90
]

{ #category : #accessing }
SWMBTofF90 class >> senderTranspilerClass [
	^ SWSTofF90
]
