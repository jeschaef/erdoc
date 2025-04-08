# ERdoc Playground


<h4 align="center">
  <a href="https://erdoc.dcc.uchile.cl/">ERdoc Plaground</a> |
  <a href="https://erdoc.dcc.uchile.cl/docs">Documentation</a>
</h4>


ERdoc is a markup language for creating Entity-Relationship models through text (ER documents). The Playground is a web-based tool to visualize ER documents as ER diagrams using common notations.
![site](https://github.com/matias-lg/er/assets/76626234/211b5c08-9884-4ded-98f2-b5d9f6120eb8)
Get started with the syntax by reading the documentation.

## Set up the project
To install the project locally follow this steps:
### Clone the project
```bash
git clone https://github.com/matias-lg/er
```
### Install dependencies
```bash
npm install
```
### Build the ERdoc parser
```bash
npm run build:parser
```

### Run the test suite:
```bash
npm test
```
### Start the server in dev mode:
```bash
npm run dev
```
Now you can open http://localhost:3000 and the web app should be up and running.


## Run in production with Docker
1. [Install Docker](https://docs.docker.com/get-docker/) on your machine.
2. Build the container: `docker build -t er-docker .`.
3. Run the container: `docker run -p 3000:3000 er-docker`.
