Class {
	#name : #SWMyProjectResolver,
	#superclass : #FileSystemResolver,
	#category : #'SWFortranByPharo-Base'
}

{ #category : #initialization }
SWMyProjectResolver class >> initialize [
	FileLocator addResolver: self new
]

{ #category : #'as yet unclassified' }
SWMyProjectResolver >> SWFortranByPharoRoot [
	<origin>
	^ self SWMyRoot / 'FortranByPharo'
]

{ #category : #'as yet unclassified' }
SWMyProjectResolver >> SWIcebergRoot [
	<origin>
	^ FileLocator localDirectory / 'iceberg'
]

{ #category : #'as yet unclassified' }
SWMyProjectResolver >> SWMyRoot [
	<origin>
	^ self SWIcebergRoot /  'garlic-flavor'
]
