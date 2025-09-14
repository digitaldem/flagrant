import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../provider/settings.dart';

class PrivacyPolicySheet extends StatelessWidget {
  const PrivacyPolicySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Last Updated: Sep. 13, 2025', style: theme.textTheme.headlineSmall),
          SizedBox(height: 24),
          Text('Data Collection', style: theme.textTheme.headlineSmall),
          SizedBox(height: 8),
          Text('We do not collect, store, or process any personal data or information from users of this app.', style: theme.textTheme.bodySmall),
          SizedBox(height: 20),
          Text('Information We Don\'t Collect', style: theme.textTheme.headlineSmall),
          SizedBox(height: 8),
          Text('Personal information (names, email addresses, phone numbers, etc.)', style: theme.textTheme.bodySmall),
          Text('Device information', style: theme.textTheme.bodySmall),
          Text('Usage data', style: theme.textTheme.bodySmall),
          Text('Location data', style: theme.textTheme.bodySmall),
          Text('Cookies or tracking technologies', style: theme.textTheme.bodySmall),
          SizedBox(height: 20),
          Text('Third-Party Services', style: theme.textTheme.headlineSmall),
          SizedBox(height: 8),
          Text('This app does not integrate with any third-party services that collect user data.', style: theme.textTheme.bodySmall),
          SizedBox(height: 20),
          Text('Data Sharing', style: theme.textTheme.headlineSmall),
          SizedBox(height: 8),
          Text('Since we don\'t collect any data, we have nothing to share with third parties.', style: theme.textTheme.bodySmall),
          SizedBox(height: 20),
          Text('Changes to This Policy', style: theme.textTheme.headlineSmall),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: theme.textTheme.bodySmall,
              children: [
                TextSpan(text: 'If we update this privacy policy, we will post the new policy here in the app and online at '),
                TextSpan(
                  text: SettingsProvider.appPrivacyPolicyUrl,
                  style: theme.textTheme.bodySmall?.copyWith(decoration: TextDecoration.underline),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () async {
                          final uri = Uri.parse(SettingsProvider.appPrivacyPolicyUrl);
                          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                            throw 'Could not launch $uri';
                          }
                        },
                ),
                TextSpan(text: ' with a revised "Last Updated" date.'),
              ],
            ),
          ),
          SizedBox(height: 10),
          Divider(thickness: 1, color: theme.dividerColor),
          SizedBox(height: 10),
          Text('This app respects your privacy by not collecting any data whatsoever.', style: theme.textTheme.labelSmall),
          SizedBox(height: 8),
          Text('You are a member of the human race, not a commodity.', style: theme.textTheme.labelSmall),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
