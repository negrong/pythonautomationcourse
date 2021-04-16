
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
  "name": "John Due"
}
```
**POST** `localhost:4000/api/v1/signin`

Parameters Example:
```json
{
  "email": "john_due@gmail.com", 
  "password": "password123"
}
```
Response (example)
```json
{
  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJTbWFydEJhbmsiLCJleHAiOjE1NzU2MDAzNTQsImlhdCI6MTU3MzE4MTE1NCwiaXNzIjoiU21hcnRCYW5rIiwianRpIjoiM2UzZDZhNWQtZDc1My00YmI2LWIzYmQtNDc4ODU4ZDI4NmYzIiwibmJmIjoxNTczMTgxMTUzLCJzdWIiOiI1YWExYjRmZi02MmNmLTQ5YzQtYTk3My0xOTNhZWQ0MDZhY2YiLCJ0eXAiOiJhY2Nlc3MifQ.71O-COZ1f0u4fOB55Bqfq_0zs978vUg9Hmd8RuIPdWc7W3Zc8tqS_-1R_qXytpFP3lYSmgsW79izYueNrlE9Dg"
}
```
### Deposit (Authenticate)

**POST** `localhost:4000/api/v1/deposit`

Parameters Example:
```json
{
  "amount": 10000
}
```
Response (example)
```json
{
    "account_id": "e0954408-b3c1-4772-a4ed-60bd1521d504",
    "amount": "$100.00",
    "date": "2019-11-08T02:46:00",
    "transaction_id": "8fe995cf-0c27-440c-b65f-d6ecc8d63254",
    "type": "deposit"
}
```

**POST** `localhost:4000/api/v1/withdraw`