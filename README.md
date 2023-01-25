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
