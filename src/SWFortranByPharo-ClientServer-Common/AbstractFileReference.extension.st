Extension { #name : #AbstractFileReference }

{ #category : #'*SWFortranByPharo-ClientServer-Common' }
AbstractFileReference >> joinPath: aString [
	"aString is either a file or path.  If aString is relative, it is appended to the receiver, if it is absolute, an instance of the receiver with the path is answered"

	^ self withPath: (self path resolvePath: (self fileSystem pathFromString: aString))
]
