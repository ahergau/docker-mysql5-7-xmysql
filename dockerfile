FROM mysql:5.7.33 as builder

LABEL version="0.1.1"

LABEL description="This is docker image for xmysql"

LABEL org.opencontainers.image.authors="Gaurav Aher (gauravaher)"
 
# copy config 
COPY ./config/my.cnf /etc/mysql/my.cnf
 
# set config to read only
RUN chmod 0444 /etc/mysql/my.cnf

# env root default password
ENV MYSQL_ROOT_PASSWORD=root

FROM mysql:5.7.33

# expose ports 
EXPOSE 3306
EXPOSE 3000
 
# copy config 
COPY --from=builder /etc/mysql/my.cnf /etc/mysql/my.cnf

# copy entrypoint 
COPY ./docker-entrypoint.sh /entrypoint.sh

# set root password
ENV MYSQL_ROOT_PASSWORD=root
# set xmysql parameters
ENV DATABASE_USER=root
ENV DATABASE_PASSWORD=root
ENV DATABASE_NAME=sandbox

# Install xmysql 
RUN apt update && \
    apt install curl -y && \
    curl -fsSL https://deb.nodesource.com/setup_15.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g xmysql