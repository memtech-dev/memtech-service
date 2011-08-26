help:
	cat Makefile

deploy: heroku-push

.PHONY: heroku-push

heroku-push:
	git push heroku master
