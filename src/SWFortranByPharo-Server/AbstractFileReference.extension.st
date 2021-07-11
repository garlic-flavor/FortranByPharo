Extension { #name : #AbstractFileReference }

{ #category : #'*SWFortranByPharo-Server' }
AbstractFileReference >> rel [
	^ self relativeTo: FileLocator imageDirectory.
]
