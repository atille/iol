# Iol

### Easy-to-use command line based task manager
This project is developed in Julia, a wonderful and powerful programming language. If you do not have any idea what is it and how to use it to make this project run, I invite you to read the docs.julialang.org pages.

## How it works
CLI-oriented, but could be graphical with some more work ; developped in Julia and interpreted (for the moment). A simple task system intending to be synchronized between different computers.

Stores the tasks in a well-named "tasks/" folder, locally.


## How to use

* Download or clone this repo
* Install Julia on your system (https://julialang.org)
* Perform one of the following commands

## Available commands

### Create a task

```bash
julia iol.jl --add "c=This is the task content&d=+10&s=pending"
```

### List the tasks

```bash
julia iol.jl --list all|pending|closed|open
```

## Shortcuts!

Since I am really a lazy guy, I decided to implement some good tips during the task creation.

```text
d=+x ; add x days from today to determine the due date.
eg: ./iol --add "c=Example task content&d=+10" # will ask for the task in ten days.
```
```text
c= stands for content
(optional ; default: +1 day) d= stands for due date (+x days)
(optional ; default: pending) s= stands for status (pending,open,closed)
```

## What is coming

* **Task edit**
* Better time system
* Synchronisation between computers
* **Display tasks by ID**
* **Display tasks when running --show open|closed|pending**
