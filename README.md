
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


localhost:4000/api/v1/report -> GET
localhost:4000/api/v1/accounts -> GET
localhost:4000/api/v1/wallet/<wallet_id> -> GET
```


`SmartBank.postman_collection` has all the available endpoints and can be imported on `Postman` 
`dev.postman_environment` is the `localhost` environment to be tested and `heroku.postman_environment` has the heroku address environment 


**POST** `localhost:4000/api/v1/signup`

Parameters Example:
```json
{
  "email": "john_due@gmail.com", 
  "password": "password123",
  "name": "John Due"
}
```
Response
```json
{
  "id": "5eb60246-ede8-4bb4-8c05-9cdb56f170bd",