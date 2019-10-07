curlman
==========

A command line utility that enables using curl commands in more user friendly way.

TODO:
-----
  * Should `curlman add resource` allow to specify path parameters?
  * Organise tests in subdirectories.
  * Modify `test.sh` so it runs tests withing subdirectories.
  * Implement `curlman add operation`.
    * Add something actually useful to the `<httpMethod>.sh` script.

Project layout
--------------
Ignore this section for now.
  * `src`: Here it is where source code is.
    * `main`: Here it is where source code meant to be part of the application
              lives.
      * `curlman.sh`: The application entry point.
      * `commands`: `curlman` subcommands are all implemented in a different 
                    script each. Here they are all of them.
      * `docs`: At the moment, just help files that displayed to the user under
                different circumstances.
      * `resources`: Files that `curlman` may copy as part of its logic, but 
                     doesn't run itself.
      * `utils`: Scripts used by `curlman` that do not really belong to its own
                 logic and may potentially be reused by other applications.
    * `test`: Here it is where the test scripts and other test related files 
              live.
  * `test.sh`: Runs all scripts in `src/test` but those prefixed with `skip-`.

Notes
-----
I had to create a Google APIs project and enable YouTube data API v3.
I roughly followed the instructions at [https://developers.google.com/youtube/v3/guides/auth/installed-apps].

At [https://console.developers.google.com/apis/dashboard] click «NEW PROJECT». Input 
${some-project-name} («`curlman-youtoube-poc`») and "No organization".
Now in the top drop-down, choose ${some-project-name} and click "ENABLE APIS AND SERVICES". 
Click on "YouTube Data API v3", and then on "ENABLE".
Click on "Credentials" on the left menu. Then, "Create credentials" and "OAuth client ID". Click on
"Configure consent screen". Input an "Application name" (${some-project-name} should do). Scroll 
down and click "Save".
Back in the "Create OAuth Client ID" screen, choose "Other" and input a "Name" (e.g., 
${some-project-name-client}). Copy the client ID (${your-client-id}) and the client secret 
(${your-client-secret}). Also, download the JSON.

Now I started the HTTP server located under `pocs/youtube/server`. It listens on port 8080 
(${local-server-port}).

Now you can use a URL like this in your browser: «https://accounts.google.com/o/oauth2/auth?client_id=${your-client-id}&redirect_uri=http://localhost:${local-server-port}&response_type=code&scope=https://www.googleapis.com/auth/youtube». 
Login with your google credentials (any google credentials), grant access to your YouTube account, 
and you'll see something like this in your local server console:
```
<Server> Received request: GET /?code=4/rgEVnRvD-_3Cl0myKH2aI4NxLM5RLlOPu0_ouU6ElYLgbF91Leey_uUmyskdOefw13-l8XMw6AYWyt81p0dIDWk&scope=https://www.googleapis.com
/auth/youtube
        == HEADERS ==
        host: localhost:8080
        connection: keep-alive
        upgrade-insecure-requests: 1
        user-agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36
        sec-fetch-mode: navigate
        sec-fetch-user: ?1
        accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3
        sec-fetch-site: cross-site
        accept-encoding: gzip, deflate, br
        accept-language: en-US,en;q=0.9
        == BODY ==
        (EMPTY)
```

The important part is what's between the `code=` and the `&scope=`. You'll have to embed this ${code} in the next POST request:
«https://oauth2.googleapis.com/token?code=${code}&client_id=${your-client-id}&client_secret=${your-client-secret}&redirect_uri=http://localhost:8080&grant_type=authorization_code»
WARNING: If it takes you more than a few seconds to copy the ${code} into this second request and 
send it, the API will reject it arguing some nonsense about the `grant_type`.
The response to this request looks like this:
```
{
  "access_token": "ya29.Il-RB20yQEHl6X9fz-o1GYXlfz3OmCTT8pxI5E2CKAiDJR0DTBmZYPig4IhxKr2678mdkX4m0drk7JyVqRjOsi6bVcgJ118afFTBVjBzwibti5LEPVYXi6PZKp7kFTKVbQ",
  "expires_in": 3600,
  "refresh_token": "1/RoPoGv3EnuzzSWyV2bkyGvbaFI0wmzVtY3qxmexd9nQ",
  "scope": "https://www.googleapis.com/auth/youtube",
  "token_type": "Bearer"
}
```

The `access_token` (${access-token}) is what you need to authorise requests sent to YouTube on 
behalf of the user. The `refresh_token` (${refresh-token}) is what you neet to get a new 
`access_token` after 3600 seconds(?).

Now you can start using YouTube API simply by including an `Authorization: Bearer ${access-token}`
header in your requests. For example: https://www.googleapis.com/youtube/v3/channels?part=snippet&mine=true

If you need to refresh the `access_token`, you have to use the following request:
https://oauth2.googleapis.com/token?refresh_token=${refresh-token}&client_id=${your-client-id}&client_secret=${your-client-secret}&grant_type=refresh_token

If you want to make sure that the `refresh_token` can't be used anymore, use the next one:
https://accounts.google.com/o/oauth2/revoke?token=${refresh-token}
However, take into account that after doing this, you will have to go back to request one (start 
local HTTP server again go to the browser, login, grant access to the application to your YouTube 
account,...) in order to get another valid `access_token`.

---
Below, a markdown cheatsheet.

Heading
=======
Sub-heading
-----------
### Another deeper heading

---

Paragraphs are separated
by a blank line.

Two spaces at the end of a line leave a  
line break.

Text attributes _italic_, *italic*, __bold__, **bold**, `monospace`.

Bullet list:

  * apples
  * oranges
  * pears

Numbered list:

  1. apples
  2. oranges
  3. pears

A [link](http://example.com).

```javascript
function {
  //Javascript highlighted code block.
}
```

    {
    Code block without highlighting.
    }
