Class {
	#name : #SWSourceOld,
	#superclass : #Object,
	#instVars : [
		'classes',
		'firstClass',
		'programClass',
		'type',
		'contents',
		'contentsHash',
		'filename',
		'moduleName'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #accessing }
SWSourceOld >> classes [

	^ classes
]

{ #category : #accessing }
SWSourceOld >> classes: arg1 [

	classes := arg1
]

{ #category : #accessing }
SWSourceOld >> contents [

	^ contents
		  ifNil: [ self error: 'I need be set a contents.' ]
		  ifNotNil: [ contents ]
]

{ #category : #accessing }
SWSourceOld >> contents: arg1 [

	contents := arg1
]

{ #category : #accessing }
SWSourceOld >> contentsHash [

	^ contentsHash
		  ifNil: [ contentsHash := (SHA256 hashMessage: self contents) hex ]
		  ifNotNil: [ contentsHash ]
]

{ #category : #accessing }
SWSourceOld >> contentsHash: arg1 [

	contentsHash := arg1
]

{ #category : #accessing }
SWSourceOld >> dirName [

	^ 'cache'
]

{ #category : #accessing }
SWSourceOld >> filename [

	^ filename
		  ifNil: [ 
			  filename := String streamContents: [ :arg1 | 
				              arg1
					              << self dirName;
					              << '/';
					              << self moduleName;
					              << '/';
					              << self contentsHash;
					              << '.';
					              << self type ] ]
		  ifNotNil: [ filename ]
]

{ #category : #accessing }
SWSourceOld >> filename: arg1 [

	filename := arg1
]

{ #category : #accessing }
SWSourceOld >> firstClass [

	^ firstClass
		  ifNil: [ 
			  | tmp2 |
			  tmp2 := self programClass.
			  firstClass := tmp2
				                ifNil: [ self classes first ]
				                ifNotNil: [ tmp2 ] ]
		  ifNotNil: [ firstClass ]
]

{ #category : #accessing }
SWSourceOld >> firstClass: arg1 [

	firstClass := arg1
]

{ #category : #accessing }
SWSourceOld >> moduleName [

	^ moduleName
		  ifNil: [ 
			  moduleName := (self firstClass respondsTo: #moduleName)
				                ifTrue: [ self firstClass moduleName ]
				                ifFalse: [ self firstClass name ] ]
		  ifNotNil: [ moduleName ]
]

{ #category : #accessing }
SWSourceOld >> moduleName: arg1 [

	moduleName := arg1
]

{ #category : #accessing }
SWSourceOld >> programClass [

	^ programClass
		  ifNil: [ 
			  programClass := self classes
				                  detect: [ :arg1 | arg1 respondsTo: #program ]
				                  ifFound: [ :arg2 | arg2 ]
				                  ifNone: [  ] ]
		  ifNotNil: [ programClass ]
]

{ #category : #accessing }
SWSourceOld >> type [

	^ type
]

{ #category : #accessing }
SWSourceOld >> type: arg1 [

	type := arg1
]
