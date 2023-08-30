Class {
	#name : #SWFPlayroom,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Tests'
}

{ #category : #tests }
SWFPlayroom class >> test1 [

	<script>
	| script returnType args argTypes |
	script := [ :arg1 |
	          SWType declareReturnAs: #double.
	          SWType declare: #arg1 as: #double.
	          arg1 sin ].
	args := script argumentNames.
	argTypes := Dictionary new.
	script sourceNode children last children do: [ :node |
		(node receiver name = #SWType) ifTrue: [
			(node selector = #declareReturnAs:) ifTrue: [
				returnType := node arguments first value.
			].
			(node selector = #declare:as:) ifTrue: [
				argTypes at: (node arguments first value) put: (node arguments second value).
			]
		].
	].
	self halt.
	^ script
]

{ #category : #tests }
SWFPlayroom class >> test2 [
	<sampleInstance>
	|script mt|
	script := [ :arg1 |
	          SWType declare: #return as: Float.
	          SWType declare: #arg1 as: Float.
	          arg1 * 2.0 ].
	mt := SWMTofF90 new
		script: script;
		yourself.
	mt transpileAsBindCFunc: 'hoge'.

	^ mt stream contents
	
]
