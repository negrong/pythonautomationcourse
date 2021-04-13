
# Smart Bank

Dependencies
 * Elixir
 * Phoenix
 * Docker
 * docker-compose

*This app is available on heroku [smart-bank](https://smart-bank.herokuapp.com)*





### Installing

```
1 - git clone https://github.com/drsantos20/smart-bank.git
2 - cd smart-bank
3 - docker-compose build
```

### To run

```
docker-compose up
```

And then the following path will be available on your local environment:

```
localhost:4000/api/v1/signup
```

### Running tests

```
mix test
```

### Available URLS:
```
localhost:4000/api/v1/signup -> POST
localhost:4000/api/v1/signin -> POST
localhost:4000/api/v1/deposit -> POST
localhost:4000/api/v1/withdraw -> POST
localhost:4000/api/v1/transfer -> POST
