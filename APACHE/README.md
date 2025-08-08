## Creating a Simple Website

- Create a directory inside user thierno's home folder:

```sh
mkdir -p /home/thierno/website/
```

- Add a basic HTML page with a simple message inside this directory:

```sh
echo "<h1>Hello index</h1>" > /home/thierno/website/index.html
```

## Deploying a Web Server with Docker

- Start an Apache container using Docker:

- Use the official Apache HTTP Server image (`httpd:2.4`) to deploy a web server serving your HTML file:

```sh
docker run -dit --name thierno-web -p 80:80 -v /home/thierno/website/:/usr/local/apache2/htdocs/ httpd:2.4
```

- Stop all Docker containers:

```sh
docker stop $(docker ps -a -q)
```

- Remove all Docker containers:

```sh
docker rm $(docker ps -a -q)
```
