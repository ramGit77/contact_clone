import 'dart:typed_data';

class Contact {
  final int? id;
  final String? displayName;
  final String? givenName;
  final String? middleName;
  final String? prefix;
  final String? suffix;
  final String? familyName;
  final String? company;
  final String? jobTitle;
  final List<EmailAddress>? emails;
  final List<PhoneNumber>? phoneNumbers;
  final List<PostalAddress>? postalAddresses;
  final Uint8List? avatar;

  Contact({
    this.id,
    this.displayName,
    this.givenName,
    this.middleName,
    this.prefix,
    this.suffix,
    this.familyName,
    this.company,
    this.jobTitle,
    this.emails,
    this.phoneNumbers,
    this.postalAddresses,
    this.avatar,
  });

  factory Contact.fromMap(Map<String, dynamic> data) {
    return Contact(
      id: data['id'] as int,
      displayName: data['displayName'] as String,
      givenName: data['givenName'] as String,
      middleName: data['middleName'] as String,
      prefix: data['prefix'] as String,
      suffix: data['suffix'] as String,
      familyName: data['familyName'] as String,
      company: data['company'] as String,
      jobTitle: data['jobTitle'] as String,
      emails: data['emails'] != null
          ? (data['emails'] as List)
              .map((e) => EmailAddress.fromMap(e))
              .toList()
          : null,
      phoneNumbers: data['phoneNumbers'] != null
          ? (data['phoneNumbers'] as List)
              .map((e) => PhoneNumber.fromMap(e))
              .toList()
          : null,
      postalAddresses: data['postalAddresses'] != null
          ? (data['postalAddresses'] as List)
              .map((e) => PostalAddress.fromMap(e))
              .toList()
          : null,
      avatar: data['avatar'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['displayName'] = displayName;
    data['givenName'] = givenName;
    data['middleName'] = middleName;
    data['prefix'] = prefix;
    data['suffix'] = suffix;
    data['familyName'] = familyName;
    data['company'] = company;
    data['jobTitle'] = jobTitle;
    if (data['emails'] != null) {
      data['emails'] = emails?.map((e) => e.toMap()).toList();
    }
    if (data['phoneNumbers'] != null) {
      data['phoneNumbers'] = phoneNumbers?.map((e) => e.toMap()).toList();
    }
    if (data['postalAddresses'] != null) {
      data['postalAddresses'] = postalAddresses?.map((e) => e.toMap()).toList();
    }
    data['avatar'] = avatar;
    return data;
  }

  @override
  String toString() {
    return 'Contact{id: $id, displayName: $displayName, givenName: $givenName, '
        'middleName: $middleName, prefix: $prefix, suffix: $suffix, '
        'familyName: $familyName, company: $company, jobTitle: $jobTitle, '
        'emails: $emails, phoneNumbers: $phoneNumbers, '
        'postalAddresses: $postalAddresses, avatar: $avatar}';
  }
}

class EmailAddress {
  final String? email;
  final String? label;

  EmailAddress({this.email, this.label});

  factory EmailAddress.fromMap(Map<String, dynamic> data) {
    return EmailAddress(
      email: data['email'],
      label: data['label'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'label': label,
    };
  }

  @override
  String toString() {
    return 'EmailAddress{email: $email, label: $label}';
  }
}

class PhoneNumber {
  final String? number;
  final String? label;

  PhoneNumber({this.number, this.label});

  factory PhoneNumber.fromMap(Map<String, dynamic> data) {
    return PhoneNumber(
      number: data['number'],
      label: data['label'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'label': label,
    };
  }

  @override
  String toString() {
    return 'PhoneNumber{number: $number, label: $label}';
  }
}

class PostalAddress {
  final String? street;
  final String? city;
  final String? region;
  final String? postalCode;
  final String? country;
  final String? label;

  PostalAddress({
    this.street,
    this.city,
    this.region,
    this.postalCode,
    this.country,
    this.label,
  });

  factory PostalAddress.fromMap(Map<String, dynamic> data) {
    return PostalAddress(
      street: data['street'],
      city: data['city'],
      region: data['state'],
      postalCode: data['postalCode'],
      country: data['country'],
      label: data['label'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'region': region,
      'postalCode': postalCode,
      'country': country,
      'label': label,
    };
  }

  @override
  String toString() {
    return 'PostalAddress{street: $street, city: $city, region: $region, '
        'postalCode: $postalCode, country: $country, label: $label}';
  }
}
