build:
	docker build -t counter_elixir .

up:
	docker run -d -p 4000:4000 -v $(shell pwd)/counter:/app/counter --name counter --network host -it counter_elixir

run:
	docker exec -it --workdir /app/counter counter mix phx.server

test:
	docker exec -it --workdir /app/counter -e MIX_ENV=test counter mix test

enter: 
	docker exec -it counter /bin/bash