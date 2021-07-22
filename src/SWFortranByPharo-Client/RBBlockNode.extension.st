Extension { #name : #RBBlockNode }

{ #category : #'*SWFortranByPharo-Client' }
RBBlockNode >> transpileUsing: transpiler [
	|ret value|
	transpiler put: '(Proc.new do '.
	transpiler variables push.
	ret := self body transpileUsing: transpiler.
	transpiler variables pop.
	transpiler put: ' end)'.
	value := self evaluate.
	transpiler variables at: value asString put: ret.
	^ value

]
