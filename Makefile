all:
	git add -A
	git commit -am 'new labs and lab updates for Fall 2022'
	git push

sync:
	cd ../websites_labs/src_MkDocs; make
