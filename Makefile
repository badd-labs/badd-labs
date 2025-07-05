push:
	git add -A
	git commit -am 'no comments'
	git push

sync:push
	cd ../websites_labs/src_MkDocs; make


