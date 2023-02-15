# linode_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Setting up Python API for Emotion Analysis

* Deploy the code on Linode instance.
* Use `ngrok` to port forward from the Linode instance, to localhost the Jupyter environment for working on the code.
* Once done, run the API by running `python3 api-emotion.py` which will run this on localhost within the Linode instance.
* Use `ngrok` to pass the parameter of the url instance and get the response. Example:

```
https://efac-2a01-7e00-00-f03c-93ff-fe62-8edd.eu.ngrok.io/detect_emotions?url_address=https://s.yimg.com/ny/api/res/1.2/sOY7KfVwt6fGSxZyPnFRvA--/YXBwaWQ9aGlnaGxhbmRlcjt3PTk2MDtoPTU4NjtjZj13ZWJw/https://media.zenfs.com/en-US/homerun/uproxx_movies_881/f2218a32e3820c6d1b4a4502cba1e377

```

## Uploading image to Linode Bucket

* Replace the access keys, and regions in `bucket-upload.py`
* Run the python file, and use `ngrok` to port forward from the Linode Instance to do a post method to upload files.
* Use the image parameter to add the desired image to upload.

Example: 

```
http -f POST http://localhost:5000/upload image@path/to/image.jpg

```

## Starting the Analysis API

* Run the `linodeupload` file, and port forward using `ngrok`
* Start the `api-emotion` on the server `localhost`
* Send the `image` parameter, ex: 

```
curl -X POST -F "image=@//Users/ameysunu/Downloads/5d9f3f5183486904582ee506.png" https://abfe-2a01-7e00-00-f03c-93ff-fe62-8edd.eu.ngrok.io/upload

```

## Updated API fetch

Instead of using `ngrok`, the web server has been hosted using `nginx` and `gunicorn3`. 

```
The POST url can be updated : 109.74.199.203/upload
```



## Getting Spotify Token

* Clone the Github Spotify sample app repository at https://github.com/spotify/web-api-examples/tree/master/authentication/authorization_code

* Open `app.js` and add the needed tokens, redirect url: `/callback`.

* Run node `app.js` and login to retrieve the App Token


## Spotify API Retrieval

Spotify token keeps expiring every 60 mins, and hence to fix this, a env variable was created on the Linode Server, from where the Spotify token can be fetched. 