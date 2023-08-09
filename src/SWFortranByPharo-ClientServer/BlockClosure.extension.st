Extension { #name : #BlockClosure }

{ #category : #'*SWFortranByPharo-ClientServer' }
BlockClosure >> | rightBlock [
	^ [ :io |
		|pipe semaphore|
		pipe := SWShell makeNonBlockingPipe.
		semaphore := Semaphore new.
		[
			self value: (io clone
				out: pipe;
				yourself).
			semaphore signal.
		] fork.
		[
			rightBlock value: (io clone
				in: (SWWaitableStream newOn: pipe);
				yourself).
			semaphore signal.
		] fork.
		semaphore wait.
		semaphore wait.
		pipe close.
	]
]
