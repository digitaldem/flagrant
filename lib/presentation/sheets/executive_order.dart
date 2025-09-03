import 'package:flutter/material.dart';

class ExecutiveOrderSheet extends StatelessWidget {
  const ExecutiveOrderSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text('PROSECUTING BURNING OF THE AMERICAN FLAG', style: theme.textTheme.titleSmall)],
            ),
          ),
          SizedBox(height: 8),
          Divider(thickness: 2, color: theme.dividerColor),
          SizedBox(height: 10),
          Text(
            'By the authority vested in me as President by the Constitution and the laws of the United States of America, it is hereby ordered:',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 8),
          Text('Section 1.  Purpose.', style: theme.textTheme.headlineSmall!.copyWith(decoration: TextDecoration.underline)),
          SizedBox(height: 8),
          Text(
            'Our great American Flag is the most sacred and cherished symbol of the United States of America, and of American freedom, identity, and strength.  Over nearly two-and-a-half centuries, many thousands of American patriots have fought, bled, and died to keep the Stars and Stripes waving proudly.  The American Flag is a special symbol in our national life that should unite and represent all Americans of every background and walk of life.  Desecrating it is uniquely offensive and provocative.  It is a statement of contempt, hostility, and violence against our Nation — the clearest possible expression of opposition to the political union that preserves our rights, liberty, and security.  Burning this representation of America may incite violence and riot.  American Flag burning is also used by groups of foreign nationals as a calculated act to intimidate and threaten violence against Americans because of their nationality and place of birth. Notwithstanding the Supreme Court’s rulings on First Amendment protections, the Court has never held that American Flag desecration conducted in a manner that is likely to incite imminent lawless action or that is an action amounting to “fighting words” is constitutionally protected.  See Texas v. Johnson, 491 U.S. 397, 408-10 (1989). My Administration will act to restore respect and sanctity to the American Flag and prosecute those who incite violence or otherwise violate our laws while desecrating this symbol of our country, to the fullest extent permissible under any available authority.',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 16),
          Text(
            'Section 2.  Measures to Combat Desecration of the American Flag.',
            style: theme.textTheme.headlineSmall!.copyWith(decoration: TextDecoration.underline),
          ),
          Text(
            '(a)  The Attorney General shall prioritize the enforcement to the fullest extent possible of our Nation’s criminal and civil laws against acts of American Flag desecration that violate applicable, content-neutral laws, while causing harm unrelated to expression, consistent with the First Amendment.  This may include, but is not limited to, violent crimes; hate crimes, illegal discrimination against American citizens, or other violations of Americans’ civil rights; and crimes against property and the peace, as well as conspiracies and attempts to violate, and aiding and abetting others to violate, such laws.',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 8),
          Text(
            '(b)  In cases where the Department of Justice or another executive department or agency (agency) determines that an instance of American Flag desecration may violate an applicable State or local law, such as open burning restrictions, disorderly conduct laws, or destruction of property laws, the agency shall refer the matter to the appropriate State or local authority for potential action.',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 8),
          Text(
            '(c)  To the maximum extent permitted by the Constitution, the Attorney General shall vigorously prosecute those who violate our laws in ways that involve desecrating the American Flag, and may pursue litigation to clarify the scope of the First Amendment exceptions in this area.',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 8),
          Text(
            '(d)  The Secretary of State, the Attorney General, and the Secretary of Homeland Security, acting within their respective authorities, shall deny, prohibit, terminate, or revoke visas, residence permits, naturalization proceedings, and other immigration benefits, or seek removal from the United States, pursuant to Federal law, including 8 U.S.C. 1182(a), 8 U.S.C. 1424, 8 U.S.C. 1427, 8 U.S.C. 1451(c), and 8 U.S.C. 1227(a), whenever there has been an appropriate determination that foreign nationals have engaged in American Flag-desecration activity under circumstances that permit the exercise of such remedies pursuant to Federal law.',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 16),
          Text('Section 3.  Severability.', style: theme.textTheme.headlineSmall!.copyWith(decoration: TextDecoration.underline)),
          SizedBox(height: 8),
          Text(
            'If any provision of this order, or the application of any provision to any person or circumstance, is held to be invalid, the remainder of this order and the application of its provisions to any other persons or circumstances shall not be affected thereby.',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 16),
          Text('Section 4.  General Provisions.', style: theme.textTheme.headlineSmall!.copyWith(decoration: TextDecoration.underline)),
          SizedBox(height: 8),
          Text('(a)  Nothing in this order shall be construed to impair or otherwise affect:', style: theme.textTheme.bodySmall),
          SizedBox(height: 2),
          Text(
            '    (i)  the authority granted by law to an executive department or agency, or the head thereof; or',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 2),
          Text(
            '    (ii)  the functions of the Director of the Office of Management and Budget relating to budgetary, administrative, or legislative proposals.',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 8),
          Text(
            '(b)  This order shall be implemented consistent with applicable law and subject to the availability of appropriations.',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 8),
          Text(
            '(c)  This order is not intended to, and does not, create any right or benefit, substantive or procedural, enforceable at law or in equity by any party against the United States, its departments, agencies, or entities, its officers, employees, or agents, or any other person.',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 8),
          Text('(d)  The costs for publication of this order shall be borne by the Department of Justice.', style: theme.textTheme.bodySmall),
          SizedBox(height: 16),
          Text('    DONALD J. TRUMP', style: theme.textTheme.headlineSmall),
          SizedBox(height: 4),
          Text('    THE WHITE HOUSE,', style: theme.textTheme.bodySmall),
          SizedBox(height: 2),
          Text('    August 25, 2025.', style: theme.textTheme.bodySmall),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
