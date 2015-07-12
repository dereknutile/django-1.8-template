# Django 1.8 Template

## Overview
This is a modified and repurposed version of this project [https://github.com/dereknutile/django-1.7-template](https://github.com/dereknutile/django-1.7-template), which is a repurposed and modified version of this project project [https://github.com/dereknutile/django-1.6-template](https://github.com/dereknutile/django-1.6-template).

The goal is to have a standardized baseline Django 1.8 application skeleton to build web applications from.

## Requirements
The documentation below assumes you're using [virtualenv](http://www.virtualenv.org/ "Virtualenv") and [virtualenvwrapper](http://virtualenvwrapper.readthedocs.org/ "Virtualenvwrapper") to manage versions and dependencies within different development environments.  In order to properly develop this application you should have the following installed:

* [Virtualenv](http://www.virtualenv.org/ "Virtualenv")
* [Virtualenvwrapper](http://virtualenvwrapper.readthedocs.org/ "Virtualenvwrapper")

## Setup

* [Create a Virtual Environment](#create-virtualenv)
* [Clone the Django 1.8 Template](#clone-template)
* [Install Dependencies](#install-dependencies)
* [Run Server](#run-server)

### [Create a Virtual Environment](id:anchor-create-a-virtual-environment)

In a terminal, create your virtual environment using virtualenvwrapper commands.  Here we'll name it ```django18```, but you may want to change it to something that makes more sense for your environment.

    $ mkvirtualenv django18

You should see something similar to the following:

    New python executable in django18/bin/python
    Installing setuptools, pip, wheel...done.

…and your prompt should now look something like this:

    (django18)$

Note: See the [Virtualenvwrapper Docs](http://virtualenvwrapper.readthedocs.org/en/latest/command_ref.html "Virtualenvwrapper Docs") for more commands.

### [Clone the Django 1.8 Template](id:anchor-clone-the-template)

To create a project using this template, open a terminal and navigate to the place where you want to keep your project, let's say it's **~/projects/**.

    (django18)$ cd ~/projects

Assuming you are still in the context of the django18 virtual environment, let's clone the project into a directory called **projectName**:

    (django18)$ git clone https://github.com/dereknutile/django-1.8-template.git projectName

### [Install Dependencies](id:anchor-install-dependencies)

First, make sure you are in the directory for the project you just made:

    (django18)$ cd projectName

You should now be in the ~/projects/**projectName** directory.


Installing dependencies is done using PIP and is relative to your environment.  The environment requirements are listed within requirements directory with a file name like _{environment}.txt_.

To install requirements on your development system, use PIP to reference the development configuration file:

    (django18)$ pip install -r requirements/development.txt

Optional Step: If you have Bower installed, you can update the asset dependencies now.

    (django18)$ bower install


### [Run Server](id:anchor-run-server)

First, initialize the SQLITE database.  *Note: you may be asked to define the superuser/admin*.

    (django18)$ python project/manage.py syncdb

Run the server ...

    (django18)$ python project/manage.py runserver

Test it out: [http://127.0.0.1:8000](127.0.0.1:8000).

## Best Practices

### Apps
There's a directory to drop your apps into: ```project/apps/```.  To keep the directory structure clean, organized, and re-usable, place your existing apps right in that directory or use django-admin.py to generate them in that directory like this:

    (django18)$ cd project/apps/
    (django18)$ django-admin.py startapp newapp

Once you've got your app in the right place, call it from the right environmental settings file.  If this app can be used in any environment, then open ```project/project/settings/base.txt``` and find the **LOCAL_APPS()** tuple.  In the example above, the LOCAL_APP tuple would look like this (don't forget to include the *apps* prefix):

    # Apps specific for this project go here.
    LOCAL_APPS = (
        'apps.newapp',
    )
