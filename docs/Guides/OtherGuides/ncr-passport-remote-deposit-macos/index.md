---
title: "NCR Passport Remote Deposit Web Client for macOS"
seo_title: "Set Up and Restart NCR Passport Remote Deposit Web Client on macOS"
description: "Technician setup and end-user recovery steps for NCR Passport Remote Deposit Web Client with Panini check scanners on macOS."
keywords: "NCR Passport, Remote Deposit Web Client, Panini scanner, macOS, Remote Deposit Capture, RDC, com.ncr.passport, scanner troubleshooting"
canonical: https://help.svetek.com/docs/Guides/OtherGuides/ncr-passport-remote-deposit-macos/
og_title: "NCR Passport Remote Deposit Web Client for macOS"
og_description: "Set up, verify, and restart Passport for Panini Remote Deposit Capture scanners on macOS."
og_type: article
og_url: https://help.svetek.com/docs/Guides/OtherGuides/ncr-passport-remote-deposit-macos/
published_time: 2026-07-28T00:00:00+00:00
layout: docs
---

NCR Passport Remote Deposit Web Client lets a bank's Remote Deposit Capture (RDC) website communicate with a locally connected Panini check scanner.

Passport installs the macOS system service `com.ncr.passport`, which listens at:

```text
https://127.0.0.1:8443
```

The browser uses this local service to control the scanner and return scanned check images to the bank's website. The service starts automatically when the Mac starts.

## Technician Setup

### Install Passport

1. Install `RemoteDepositWebClientPanini.pkg`.
2. In the installer, select **Install HTTPS Certificate**.
3. Restart the Mac if prompted.

### Verify Installation

Confirm the LaunchDaemon exists:

```bash
test -f /Library/LaunchDaemons/com.ncr.passport.plist && echo Installed
```

Review its configuration:

```bash
plutil -p /Library/LaunchDaemons/com.ncr.passport.plist
```

Confirm these values are present:

```text
Label = com.ncr.passport
RunAtLoad = true
KeepAlive.SuccessfulExit = false
```

### Restart and Verify the Service

Restart Passport:

```bash
sudo /bin/launchctl kickstart -k system/com.ncr.passport
```

Check the service:

```bash
sudo /bin/launchctl print system/com.ncr.passport
```

Verify the local HTTPS endpoint:

```bash
curl -ks -o /dev/null -w "%{http_code}\n" https://127.0.0.1:8443/
```

An HTTP response of `404` is expected. It confirms the Passport service is running.

### Test the Scanner

1. Connect the scanner.
2. Open the bank's Remote Deposit website and sign in.
3. Scan a test check.
4. Confirm the check image appears.

If the scanner feeds a check but no image appears, restart Passport and try again.

## End User Guide

### Normal Operation

1. Connect the scanner.
2. Open the bank's Remote Deposit website and sign in.
3. Scan checks as normal.

Passport runs automatically in the background.

### If Scanning Stops Working

Use these steps only when the scanner feeds the check but its image does not appear on the Remote Deposit website.

1. Close the Remote Deposit website.
2. Open **Terminal**.
3. Run:

```bash
sudo /bin/launchctl kickstart -k system/com.ncr.passport
```

4. Enter an administrator username and password if prompted.
5. Reopen the Remote Deposit website, sign in, and try scanning again.

This command requires a local administrator account. If you do not have administrator credentials, contact IT to restart Passport.

### Contact IT If

- The scanner does not power on or does not feed checks.
- Restarting Passport does not resolve the issue.
- The Remote Deposit website displays an error.
- You cannot sign in to the Remote Deposit website.

## Technician Troubleshooting

Restart Passport:

```bash
sudo /bin/launchctl kickstart -k system/com.ncr.passport
```

Check service status:

```bash
sudo /bin/launchctl print system/com.ncr.passport
```

Check the HTTPS endpoint:

```bash
curl -ks -o /dev/null -w "%{http_code}\n" https://127.0.0.1:8443/
```

Confirm the service is listening on port `8443`:

```bash
lsof -nP -iTCP:8443 -sTCP:LISTEN
```

Review Passport logs from the last 10 minutes:

```bash
log show --last 10m --style compact --predicate 'process == "pwecsrvc" OR eventMessage CONTAINS[c] "com.ncr.passport"'
```
