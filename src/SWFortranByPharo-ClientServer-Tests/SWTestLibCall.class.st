Class {
	#name : #SWTestLibCall,
	#superclass : #Object,
	#category : #'SWFortranByPharo-ClientServer-Tests-Playroom'
}

{ #category : #'library path' }
SWTestLibCall >> ffiLibraryName [
	^ '/Users/giga/Library/CloudStorage/OneDrive-個人用/work/2023-08-10_dylib/func1.dylib'
]

{ #category : #running }
SWTestLibCall >> make_double: x [
	^ self ffiCall: #( int make_double ( int x ) )
]
