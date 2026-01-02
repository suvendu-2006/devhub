class Opportunity {
  final String title;
  final String company;
  final String companyLogo;
  final String location;
  final String type;
  final String postedDate;
  final String description;
  final String applyUrl;
  final bool isNew;

  Opportunity({
    required this.title,
    required this.company,
    required this.companyLogo,
    required this.location,
    required this.type,
    required this.postedDate,
    required this.description,
    required this.applyUrl,
    required this.isNew,
  });
}
