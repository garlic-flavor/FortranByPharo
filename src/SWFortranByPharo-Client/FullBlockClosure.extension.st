Extension { #name : #FullBlockClosure }

{ #category : #'*SWFortranByPharo-Client' }
FullBlockClosure >> transpileUsing: transpiler [
	self flag: #TODO. "under construction"
	transpiler incIndent.
	self sourceNode transpileUsing: transpiler.
	transpiler decIndent.
]

{ #category : #'*SWFortranByPharo-Client' }
FullBlockClosure >> transpileUsing: transpiler asMainOf: project [
	self flag: #TODO. "Under construction"

	transpiler putMainProgramHeaderOf: project.
	self transpileUsing: transpiler.
	transpiler putMainProgramFooterOf: project.
	^ transpiler contents.
]
