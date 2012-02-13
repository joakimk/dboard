A dashboard framework.

It handles collecting data from user defined sources (simple ruby classes) and provides a simple API to poll for updates. See the [example app](https://github.com/joakimk/dboard_example) for information on how to use it.

It's stable and has been in use for quite a while.

Dboard is two parts:

* The collection process you run on your server. It polls sources for data and sends it to your dashboard web server.
* The API which combined with for example sinatra (and memcached) becomes a dashboard web server.

Things dboard do for you:

* Calls your classes for data as often as you have specified.
* Sends the data to the dashboard web app.
* Receives and stores the data in the dashboard web app.
* Provides an API to get data to display on the dashboard.
* Keeps the latest data in memcache so that all data is available when you visit the databoard, even data from slow or rarely updated sources (like external APIs).
* Provides a javascript client that knows how to talk to the API (for now it's only included in the [example app](https://github.com/joakimk/dboard_example))
* Only calls your javascript widgets when there is new data.

Data flow:

    +-----------------+              +--------------------+
    |                 |              |                    |
    |   Collector     | Pushes data  |   Dashboard web    |
    |                 +--------------+   server           +----+
    |                 |              |                    |    |
    +-----------------+              +--------------------+    | Polls for updates
       |           |                                           |
       |           |                                           |
    +--+--+     +--+--+                         +--------------+-------------+
    |     |     |     |                         |                            |
    |     |     |     |                         |  Dashboard page            |
    +-----+     +-----+                         |                            |
    Source A    Source B                        |                            |
                                                |  See the example app.      |
                                                |                            |
                                                |                            |
                                                |                            |
                                                |                            |
                                                |                            |
                                                |                            |
                                                |                            |
                                                |                            |
                                                |                            |
                                                +----------------------------+

The ASCII drawing above was created using [http://www.asciiflow.com/](http://www.asciiflow.com/).

Todo:

* Include the client side dashboard script (see the [example app](https://github.com/joakimk/dboard_example) for now).
* Provide additional tools for creating dashboards (layout css, graphical widgets, etc). Probably as another gem.
* Tools for deployment (if it can be made generic enough), otherwise a general guide.
* If someone wants to add it: support for pushing data to the client using web sockets.
