Class {
	#name : #SWFFCaller,
	#superclass : #SWFCallerBase,
	#category : #'SWFortranByPharo-FFCaller'
}

{ #category : #'private - accessing' }
SWFFCaller >> buildTargetExt [
	^ '.dylib'
]

{ #category : #'library path' }
SWFFCaller >> ffiLibraryName [
	^ self buildTarget
]
