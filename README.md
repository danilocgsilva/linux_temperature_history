# Linux temperature history

Tracks temperature from a Linux system.

Obs.: it requires the `sqlite3` command script to store the data and the python language runtime as well.

Obs2.: the `mpg123` also would be good, so the app can *alarm* when the computer becamos dangerously hotter.

## What about AI?

Usually, being warned about dangerous temperature was never a real requirement for me, as a software developer. Such things usually don't consume many resources from the computer most of the time. But now, as I want to grasp the knowledge to use AI offline, I notice that it is easy put the computer under a massive processing load, which easily can make the computer way hot, no matter how powerfull it is. So I've created this utility to prevent my system from overheating, as I will be generating AI content much more often on my local computer.

## How to use

```
chmod +x ./begin.sh
./begin.sh
```

The script will create a sqlite file called `storage.db`, that records on each second the temperature from each physical core.

![Screenshot](screenshot.png)

