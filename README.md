# Cisco Packet Tracer latest version on Fedora

[Watch this script in action](https://youtu.be/iOiwRt_P95Y)

Easily install Cisco Packet Tracer latest version on Fedora. This installation script automatically detects a Cisco Packet Tracer `.deb` in any directory on user home.

## Install

Follow these steps to easily install:

-   Download the Packet Tracer installer from [Cisco's download page](https://www.netacad.com/resources/lab-downloads?courseLang=en-US) and save it in any directory on `/home` using the default filename.
-   Clone this repo to your system
-   `cd` into the cloned repo and make the install script executable: `chmod +x setup.sh`
-   Run `bash setup.sh` **or** `sudo bash setup.sh` and relax. If you not use `sudo`, you will receive no permission alerts when the script looks for installers on you HOME.

Now, the script accepts these command line options:
- `-d` or `--directory` allows you to specify a path to the installer. This can make the script faster, preventing large searches of the `/home` directory;
- `-h` will show help about the script;
- `--uninstall` uninstall the installed Cisco Packet Tracer.

## Supported Fedora releases

- [x] Fedora 40 ([F40 End of Life 2025-05-13](https://fedorapeople.org/groups/schedule/f-40/f-40-key-tasks.html))
- [x] Fedora 41
- [x] Fedora 42

## Fedora 43+

Packet Tracer 9 requires `libfuse.so.2` (FUSE2), which is not included by default in Fedora 43.  
Before installing, run:

```
sudo dnf install fuse fuse-libs
```


> [!Note]
> If you are using a distribution that is based on Fedora, this script will probably still work. If not, open an issue. I will not list any Fedora based distro here.

> [!Important]
> If you try this script in another Fedora release, please [report](https://github.com/thiagoojack/packettracer-fedora/issues) any problems or successes at the aforementioned link.
