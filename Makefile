push:
	git add -A
	git commit -am 'for workshop 2024'
	git push

sync:push
	cd ../websites_labs/src_MkDocs; make


