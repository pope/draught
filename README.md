Draught
=======

[![Analytics](https://ga-beacon.appspot.com/UA-280328-3/pope/draught/README)](https://github.com/igrigorik/ga-beacon)

A little [Coffeescript][] and [Polymer][] web app to help with my fantasy football draft. The original was written in Dart, but I wanted to see what it would be like to use Coffeescript instead.

Requirements
------------

You will need Node and Make. The builds are run off of a Makefile. Running `make` will ensure all of the node modules are downloaded as well as the components from Bower.

Running
-------

    $ make serve
    ...

Then use your modern browser to view the app on `http://localhost:8080`.

To have the coffeescripts automatically compile into JS on save, run:

    $ make watch
    ...

To deploy, just run:

    $ make build-all
    ...
    $ rsync -azv build/ /usr/share/webroot/draught/
    ...

Where the `webroot` is the location of where you store static HTTP files.

[Coffeescript]: http://coffeescript.org/
[Polymer]: http://www.polymer-project.org/
