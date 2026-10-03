// Mirrors the "Svetek Discovery" Zoho form (HTML export). Field names and
// option values must match Zoho exactly or the CRM receives empty values.
export const contactPath = '/contact/';
export const thanksPath = '/contact/thanks/';
export const zohoAction = 'https://forms.zohopublic.com/svetek/form/SvetekDiscovery/formperma/N33SIRtdg6WdSZ58TLRkXku-5czC3-i4xWa0OMRRpM8/htmlRecords/submit';

export const contactSections = [
  {
    title: 'About you',
    fields: [
      { name: 'Name_First', label: 'First name', type: 'text', required: true, autocomplete: 'given-name', half: true },
      { name: 'Name_Last', label: 'Last name', type: 'text', required: true, autocomplete: 'family-name', half: true },
      { name: 'Email', label: 'Work email', type: 'email', required: true, autocomplete: 'email' },
      { name: 'SingleLine', label: 'Company', type: 'text', required: true, autocomplete: 'organization' },
      { name: 'Dropdown1', label: 'Your role', type: 'select', required: true, half: true,
        options: ['Owner / Principal', 'Operations or Office Manager', 'Estimator or PM', 'Customer Service', 'Other'] },
      { name: 'Dropdown', label: 'Organization type', type: 'select', required: true, half: true,
        options: ['For-profit business', 'Nonprofit', 'Government or public sector', 'Other / not sure'] },
      // Conditional in Zoho; the HTML export omits the rule. Required only while shown.
      { name: 'Dropdown3', label: 'Do any grants, contracts, or state/federal funding impose technology, privacy, security, reporting, or record-retention requirements?', type: 'select', required: true,
        showWhen: { field: 'Dropdown', values: ['Nonprofit', 'Government or public sector'] },
        options: ['Yes', 'No', 'Not sure', 'Flexible'] },
    ],
  },
  {
    title: 'Your environment',
    fields: [
      { name: 'Dropdown4', label: 'How many people use a computer or company email?', type: 'select', required: true,
        options: ['1 to 4', '5 to 9', '10 to 24', '25 to 49', '50 or more'] },
      { name: 'Dropdown5', label: 'Who handles IT today?', type: 'select', required: true,
        options: ['Owner or staff, as a side duty', 'Our web developer', 'An outside IT company', 'Nobody in particular', 'Not sure'] },
      { name: 'Dropdown2', label: 'Email platform', type: 'select', required: true,
        options: ['Google Workspace', 'Microsoft 365', 'Through our web host', 'Personal Gmail or Yahoo', 'Mixed', 'Not sure'] },
      { name: 'MultiLine', label: 'Domains you own, including older or variant names', type: 'textarea',
        hint: 'Include hyphenated or alternate spellings if you own them.' },
    ],
  },
  {
    title: 'What you need',
    fields: [
      { name: 'MultiLine1', label: 'What prompted you to look into this?', type: 'textarea' },
      { name: 'Dropdown6', label: 'Best time to reach you', type: 'select',
        options: ['Weekday mornings', 'Weekday afternoons', 'Early evening', 'Flexible'] },
    ],
  },
];

export const contactFields = contactSections.flatMap((section) => section.fields);
