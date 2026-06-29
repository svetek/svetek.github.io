---
title: "Enroll a Mac in Intune"
seo_title: "Enroll a Mac in Intune with Company Portal | BYOD User Guide"
description: "User guide for enrolling a personal Mac in Microsoft Intune with the Company Portal app, including profile installation and verification steps."
keywords: "enroll Mac Intune, macOS Company Portal enrollment, Intune BYOD Mac, personal Mac enrollment, Microsoft Intune macOS, IT support Vancouver WA, IT support Portland OR, IT support Seattle WA"
canonical: https://help.svetek.com/docs/Guides/Intune/enroll-mac-intune/
og_title: "Enroll a Mac in Intune"
og_description: "Step-by-step user instructions for enrolling a personal Mac in Intune with Company Portal."
og_type: article
og_image: https://help.svetek.com/docs/Guides/Intune/enroll-mac-intune/images/byod_osx_01.png
og_url: https://help.svetek.com/docs/Guides/Intune/enroll-mac-intune/
published_time: 2026-06-29T00:00:00+00:00
twitter_title: "Enroll a Mac in Intune"
twitter_description: "User instructions for enrolling a personal Mac in Intune with Company Portal."
twitter_image: https://help.svetek.com/docs/Guides/Intune/enroll-mac-intune/images/byod_osx_01.png
twitter_image_alt: "Company Portal installer on macOS"
layout: docs
---

# Enroll a Mac in Intune

Use this guide to enroll a personal Mac in Microsoft Intune with the Company Portal app.

Enrollment lets your organization verify the Mac meets company requirements before granting access to company resources.

## Before You Start

Make sure you have:

- Your company email address and password.
- Access to your MFA method.
- A local Mac account with permission to install software.
- A stable internet connection.

## Install Company Portal

1. Open [Enroll My Mac](https://go.microsoft.com/fwlink/?linkid=853070).
2. Download the Company Portal installer package.
3. Open the installer and follow the prompts.
4. Accept the software license agreement.

![Company Portal installer on macOS](images/byod_osx_01.png)

![Company Portal installer introduction screen](images/byod_osx_02.png)

When prompted, enter your Mac password or use Touch ID to install the software.

![macOS prompt to allow Company Portal installation](images/byod_osx_03.png)

## Sign In to Company Portal

1. Open **Company Portal**.
2. Sign in with your company email address.
3. Complete MFA if prompted.

![Company Portal app on macOS](images/byod_osx_04.png)

![Company Portal sign-in screen](images/byod_osx_05.png)

![Company Portal email address prompt](images/byod_osx_06.png)

## Start Device Enrollment

1. Select **Begin**.
2. Review the enrollment information.
3. Select **Continue**.

![Company Portal Begin button](images/byod_osx_07.png)

![Company Portal enrollment overview](images/byod_osx_08.png)

![Company Portal enrollment checklist](images/byod_osx_09.png)

## Install the Management Profile

1. Select **Download profile**.
2. Open **System Settings** if it does not open automatically.
3. Install the downloaded management profile.
4. Enter your Mac password or use Touch ID if prompted.

![Company Portal Download profile step](images/byod_osx_10.png)

![macOS profile installation screen](images/byod_osx_11.png)

![macOS profile confirmation prompt](images/byod_osx_12.png)

After the profile installs, return to Company Portal.

![macOS profile installed confirmation](images/byod_osx_13.png)

![Company Portal profile installation complete](images/byod_osx_14.png)

## Finish Enrollment

Select **Done** to finish setup.

![Company Portal Done button after Mac enrollment](images/byod_osx_15.png)

## Verify Enrollment

Enrollment is complete when:

- Company Portal says setup is complete.
- The Mac appears in Company Portal.
- Company apps or company access policies begin applying.
- Microsoft 365 apps stop asking you to enroll the device.

## Common Issues

| Issue | What to do |
| --- | --- |
| Company Portal will not install | Confirm you are using a local Mac account that can install software |
| Profile does not appear | Reopen Company Portal and select the profile download step again |
| MFA fails | Confirm your MFA method works, then try again |
| Enrollment gets stuck | Restart the Mac, open Company Portal, and continue setup |
| Access is still blocked | Wait a few minutes, then open Company Portal and check device status |

## Need Help

Contact your IT support team if Company Portal cannot install, the management profile fails, or Microsoft 365 apps still ask you to enroll after setup is complete.
