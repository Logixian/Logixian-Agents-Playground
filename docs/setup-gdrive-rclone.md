# Google Drive Setup — rclone

One-time setup to enable the `/update-meeting` and `/meeting-upload` skills to upload files to Google Drive.

## Why rclone?

The skills use `rclone` for Google Drive uploads because it:
- Handles all file types including large `.mp4` recordings
- Works via a one-time OAuth setup stored locally
- Is battle-tested for bulk file transfers
- Requires no API keys in the repo

## Prerequisites

Install rclone:
```bash
# macOS
brew install rclone

# or universal installer
curl https://rclone.org/install.sh | sudo bash
```

Verify:
```bash
rclone version
```

## Configure Google Drive Remote

Run the interactive config:
```bash
rclone config
```

Follow these prompts:

```
n) New remote
name> gdrive

Storage> drive          # Google Drive

client_id>              # leave blank (uses rclone's built-in app)
client_secret>          # leave blank

scope> 1                # Full access (drive)

root_folder_id>         # leave blank (use Drive root)
service_account_file>   # leave blank

Edit advanced config? n

Use auto config? y      # browser will open for OAuth
```

A browser window opens. Log in with your Google account and grant rclone access. After approval, rclone saves a token to `~/.config/rclone/rclone.conf`.

Verify the remote works:
```bash
rclone lsd gdrive:
```

You should see your top-level Drive folders listed.

## Folder Structure

The skills create folders under `Meeting Notes/` in your Drive root:

```
My Drive/
  Meeting Notes/
    Meeting — 2026-03-22 — Q1 Planning Sync/
      recording.mp4
      zoom_transcript.vtt
      zoom_chat.txt
      meeting_summary.md
```

To use a different root folder, pass `--drive-root "My Custom Folder"` when invoking `/update-meeting`.

## Sharing Settings

By default, `rclone link` creates a link that anyone with the link can view. If you want organization-restricted sharing:

```bash
# Test link generation
rclone link "gdrive:Meeting Notes/Meeting — 2026-03-22 — Test"
```

If `rclone link` is not supported in your rclone version (older than v1.57), upgrade rclone or manually copy the folder URL from Google Drive.

## Troubleshooting

**"Remote not found"**
The rclone remote must be named `gdrive` (default) or passed as `--drive-remote <name>`.
Run `rclone listremotes` to see what is configured.

**"Token expired"**
Re-run `rclone config reconnect gdrive:` to refresh the OAuth token.

**"403 Forbidden" on upload**
Your Google account may be in an organization that restricts third-party app access.
Ask your Google Workspace admin to allow rclone, or use a personal Google account.

**Large file upload slow**
This is normal for `.mp4` files. rclone shows a progress bar. The recording upload may take several minutes depending on file size and connection speed.
