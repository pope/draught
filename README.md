Draught
=======

[![Analytics](https://ga-beacon.appspot.com/UA-280328-3/pope/draught/README)](https://github.com/igrigorik/ga-beacon)

A little [Dart][] and [Polymer][] web app to help with my fantasy football draft.

    $ pub get
    ...
    $ pub serve
    ...

Then use your modern browser to view the app on `http://localhost:8080`.

To deploy, just run:

    $ pub build
    ...
    $ rsync -azv build/web/ /usr/share/webroot/draught/
    ...

Where the `webroot` is the location of where you store static HTTP files.

[Dart]: https://www.dartlang.org/
[Polymer]: http://www.polymer-project.org/
