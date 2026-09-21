mariadb:
    container_name: mariadb
    image: mariadb:10.11
    env_file:
      - .env
    ports:
      - "3306:3306"
    volumes:
      - DB:/var/lib/mysql
    networks:
      - inception