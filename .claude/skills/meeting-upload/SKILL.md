---
name: meeting-upload
description: Upload Zoom meeting artifacts (transcript, chat log, summary, reference docs) to Google Drive for a given meeting date. Use when the user says "upload meeting", "upload artifacts", or provides a date like "2026-03-11". Accepts a single YYYY-MM-DD date argument and reads files from client-meeting/<date>/. Returns the shareable folder URL for use in downstream meeting skills.
user-invocable: true
argument-hint: "<YYYY-MM-DD>"
allowed-tools:
  - Read
  - Bash(ls:*)
  - Bash(rclone:*)
---

## Your Task

Upload all meeting artifacts for a given date from `client-meeting/<date>/` to a dated subfolder in the shared Google Drive meeting folder.

**Prerequisite:** `rclone` must be configured with a Google Drive remote. If not set up, stop and direct the user to `docs/setup-gdrive-rclone.md`.

## Arguments

| Argument | Required | Description |
|---|---|---|
| `<YYYY-MM-DD>` | Yes | Meeting date — must match a folder in `client-meeting/` |

## Fixed Paths

- **Source directory:** `client-meeting/<date>/`
- **Drive destination folder ID:** `1xxd-DIRCXDdDab1tS27S_V4Fzfp3g11K`
- **Drive subfolder name:** `<date>` (e.g. `2026-03-11`)

## Steps

### Step 1 — Verify rclone is configured

Run `rclone listremotes` to check available remotes.

- If `gdrive` is NOT listed: stop and print:
  ```
  rclone remote "gdrive" not found. Please configure it first:
    rclone config
  See docs/setup-gdrive-rclone.md for step-by-step instructions.
  ```
- If it IS listed: proceed.

### Step 2 — Validate the date and inventory files

1. Check that `client-meeting/<date>/` exists. If not, list available dates and stop.
2. Run `ls -lh client-meeting/<date>/` and categorize every file:

| Type | Expected pattern |
|---|---|
| Transcript | `GMT*.vtt`, `*_transcript.txt` |
| Meeting notes | `Client Meeting.md` |
| Reference docs | Any other `*.md` files |
| Recording | `*.mp4`, `*.m4a` |

Show the inventory table with file sizes.

### Step 3 — Show upload plan and ask for approval

Display:
```
Upload Plan — Google Drive

  Destination: https://drive.google.com/drive/folders/1xxd-DIRCXDdDab1tS27S_V4Fzfp3g11K
  Subfolder:   <date>
  Files to upload:
    [1] GMT20260311-200440_Recording.transcript.vtt  (45 KB)
    [2] Client Meeting.md                             (3 KB)
    [3] <other files...>

Upload N files to Google Drive? (yes / cancel)
```

Wait for the user's response. On `cancel`: exit without uploading.

### Step 4 — Create subfolder and upload

Upload all files from the source directory into a dated subfolder inside the target Drive folder:

```bash
rclone copy "client-meeting/<date>" "gdrive:<date>" \
  --drive-root-folder-id 1xxd-DIRCXDdDab1tS27S_V4Fzfp3g11K \
  --progress
```

This creates `<date>/` inside the shared folder and copies all files into it.

If any upload fails, report the error and ask: "Retry failed files? (yes / skip / cancel)"

### Step 5 — Get shareable link

Run:
```bash
rclone link "gdrive:<date>" --drive-root-folder-id 1xxd-DIRCXDdDab1tS27S_V4Fzfp3g11K
```

If `rclone link` is unsupported, give the user the direct URL:
`https://drive.google.com/drive/folders/1xxd-DIRCXDdDab1tS27S_V4Fzfp3g11K`
and ask them to navigate to the `<date>` subfolder and copy the link.

### Step 6 — Output result

Print:
```
Phase 1 complete — Google Drive

  Subfolder: <date>
  URL:       https://drive.google.com/drive/folders/<subfolder-id>
  Files:     N uploaded successfully
```

Return the folder URL. The orchestrator (`/update-meeting`) will pass it to Phase 2.
