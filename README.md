# mapbox_demo

A project to demonstrate the Mapbox's official plugin mapbox_maps_flutter.

<br>

# Get started with credential setup

Configure credentials 
To run the Maps Flutter Plugin you will need to configure the Mapbox Access Tokens. Read more about access tokens and public/secret scopes at the platform Android or iOS docs.

Secret token
To access platform SDKs you will need to create a secret access token with the Downloads:Read scope.

## Android 

Open ~/.gradle/gradle.properties & add following code :
  ```
  SDK_REGISTRY_TOKEN=sk.eyJ1IjoiZGV2YWxjIiwiYSI6ImNsZjd0ZW9hMzF6dHozd3M5dmpobzNuZ3QifQ.kQkGhAsAmywHi8A82BuatA
  ```


## IOS

Create or Update a hidden file it HOME (~/) dir named .netrc   

Then copy below content in ~/.netrc file

  ```
    machine api.mapbox.com
      login mapbox
      password sk.eyJ1IjoiZGV2YWxjIiwiYSI6ImNsZjd0ZW9hMzF6dHozd3M5dmpobzNuZ3QifQ.kQkGhAsAmywHi8A82BuatA
  ```

<br><br>

After this setup, you will be able to install pods and get project running.

# Running project
<br>
To run the project with VS CODE :

- Open main.dart in editor.
- Press F5 to start the project.