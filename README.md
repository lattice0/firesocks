# Firesocks

The add-ons for firefox will toggle SOCKS support for the entire browser, not just for one window. This docker file will create a new instance of firefox with SOCKS enabled and configured so you can run in parallel with your own firefox.

I've make this because I constantly need to connect to a place with slow connection through SOCKS, but I don't want to redirect all my tabs traffic.

# Build:

`sudo docker build -t firesocks .`

# Run:

`xhost +local:root && sudo docker run -it --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --name firesocks firesocks`

To modify any of the ENVs setted in the Dockerfile, just add `-e MY_ENV=MY_VALUE`. Example:

`-e SOCKS_PORT=1234`

Scripts.txt contains the build and run scripts so you can `cat scripts.txt` and copy them to modify little things and paste again.
