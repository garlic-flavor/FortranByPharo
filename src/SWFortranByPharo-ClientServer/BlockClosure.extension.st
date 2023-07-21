Extension { #name : #BlockClosure }

{ #category : #'*SWFortranByPharo-ClientServer' }
BlockClosure >> | rightBlock [
	^ [ :io |
		|pipe semaphore|
		pipe := SWPipe new.
		semaphore := Semaphore new.
		[
			self value: (io clone
				out: pipe writeStream;
				yourself).
			semaphore signal.
		] fork.
		[
			rightBlock value: (io clone
				in: pipe readStream;
				yourself).
			semaphore signal.
		] fork.
		semaphore wait.
		semaphore wait.
		pipe close.
	]
]
