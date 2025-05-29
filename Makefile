SRC=srcs/docker-compose.yml

up:
	@docker compose -f ${SRC} up --build

down:
	@docker compose -f ${SRC} down

fclean:
	@docker system prune -af
