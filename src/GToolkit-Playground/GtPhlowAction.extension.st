Extension { #name : #GtPhlowAction }

{ #category : #'*GToolkit-Playground' }
GtPhlowAction >> forPlayground [
	"Symbol is a method name where a view is defined.
	Such Phlow action will be displayed in Playground."
	self target: GtPlaygroundActionTarget uniqueInstance
]
