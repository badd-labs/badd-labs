all:
	git add -A
	git commit -am 'new labs and lab updates for Fall 2022'
	git push


sync:
	cp ~/Dropbox/Sync_files/Teaching/Labs/lab-escrow*jpg lab4-2019/
