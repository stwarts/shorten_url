# POST /encode

|params|required|
|---|---|
|url|true|

|headers||
|---|---|
|Anonymous-Id|In case user have not signed in, this headers must be set|

Example:

```bash
curl -X POST https://radiant-wildwood-25315.herokuapp.com/encode \
  -d '{"url": "https://radiant-wildwood-25315.herokuapp.com/"}' \
  -H "Content-Type: application/json" \
  -H "Anonymous-Id: cuong-nguyen"
```

## Response

### Successful

HTTP code: **200**
|attribute|description|
|---|---|
|alias|the shorten version|

### Sample response

```JSON
{
  "data": {
    "id":2,
    "original_url":"https://radiant-wildwood-25315.herokuapp.com/",
    "user_id":"cuong-nguyen",
    "alias":"00000002",
    "created_at":"2023-02-23T14:35:26.473Z",
    "updated_at":"2023-02-23T14:35:26.473Z"
  }
}
```

### Failed

Error messages will be present in `errors` field if any
|HTTP Code|description|
|---|---|
|422|cannot encode URL|

```JSON
{
  "errors":[
    "Original url can't be blank",
    "User can't be blank"
  ]
}
```

# POST /decode

|params|required|
|---|---|
|url|true|

```bash
curl -X POST https://radiant-wildwood-25315.herokuapp.com/decode \
  -d '{"url": "00000002"}' \
  -H "Content-Type: application/json"
```

## Response

### Successful

HTTP code: **200**

### Sample response

```JSON
{
  "data": {
    "id":2,
    "original_url":"https://radiant-wildwood-25315.herokuapp.com/",
    "user_id":"cuong-nguyen",
    "alias":"00000002",
    "created_at":"2023-02-23T14:35:26.473Z",
    "updated_at":"2023-02-23T14:35:26.473Z"
  }
}
```

### Failed

|HTTP Code|description|
|---|---|
|404|cannot decode, response body is empty|
