run:
	docker build -t twitch-archiver . && docker run -it --rm twitch-archiver