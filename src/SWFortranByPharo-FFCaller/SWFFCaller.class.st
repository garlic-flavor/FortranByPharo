Class {
	#name : #SWFFCaller,
	#superclass : #SWFCallerBase,
	#category : #'SWFortranByPharo-FFCaller'
}

{ #category : #'private - accessing' }
SWFFCaller >> buildTargetExt [
	^ '.dylib'
]

{ #category : #'private - running' }
SWFFCaller >> callBuildedWith: args [
	self ffiCall: self scriptSpec
]

{ #category : #'library path' }
SWFFCaller >> ffiLibraryName [
	self halt.
]

{ #category : #'private - accessing' }
SWFFCaller >> scriptSpec [
	|returnType args argTypes argsSpec|
	returnType := #void.
	args := self script argumentNames.
	argTypes := Dictionary new.
	self script sourceNode children last children do: [ :node |
		(node receiver name = #SWType) ifTrue: [
			(node selector = #declareReturnAs:) ifTrue: [
				returnType := node arguments first value.
			].
			(node selector = #declare:as:) ifTrue: [
				argTypes at: (node arguments first value) put: (node arguments second value).
			]
		].
	].
	argsSpec := OrderedCollection new.
	args do: [ :each |
		argsSpec
			add: (argTypes at: each);
			add: #(args at:1)
	].
	^ {returnType. (self name asSymbol). argsSpec asArray}


]
