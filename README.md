# borg-docker

A Docker container that runs [Borg Backup](https://www.borgbackup.org/) with SSH access. This container is designed to be used as a backup target for Borg Backup clients, allowing secure remote backups over SSH.

## Features

- Based on Debian Bookworm (slim)
- Runs Borg Backup 1.4.0
- SSH access with GitHub key import
- Customizable user configuration
- Secure defaults

## Usage

### Basic Build

```bash
docker build -t borg-docker .
```

### Custom Build with Arguments

You can customize the container user and their GitHub account for SSH key import:

```bash
docker build -t borg-docker \
    --build-arg LOCAL_USER=your_username \
    --build-arg GITHUB_USER=your_github_username \
    .
```

### Running the Container

```bash
docker run -d \
    -p 2222:22 \
    -v /path/to/backup/storage:/home/your_username/backups \
    --name borg-backup \
    borg-docker
```

## Build Arguments

| Argument | Description | Default |
|----------|-------------|---------|
| `LOCAL_USER` | Username in the container | `mvip` |
| `GITHUB_USER` | GitHub username for SSH key import | `vpetersson` |

## Security Notes

- The container uses SSH key authentication only
- SSH keys are imported from GitHub
- SSH host keys are generated on container start
