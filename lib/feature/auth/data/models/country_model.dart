// Model for country data
class Country {
  final String name;
  final String flag;
  final String dialCode;

  Country({required this.name, required this.flag, required this.dialCode});
}

// Sample list of countries - you can expand this list
final List<Country> countries = [
  Country(name: 'United States', flag: '🇺🇸', dialCode: '+1'),
  Country(name: 'United Kingdom', flag: '🇬🇧', dialCode: '+44'),
  Country(name: 'India', flag: '🇮🇳', dialCode: '+91'),
  Country(name: 'Canada', flag: '🇨🇦', dialCode: '+1'),
  Country(name: 'Australia', flag: '🇦🇺', dialCode: '+61'),
  Country(name: 'Germany', flag: '🇩🇪', dialCode: '+49'),
  Country(name: 'France', flag: '🇫🇷', dialCode: '+33'),
  Country(name: 'Italy', flag: '🇮🇹', dialCode: '+39'),
  Country(name: 'Spain', flag: '🇪🇸', dialCode: '+34'),
  Country(name: 'China', flag: '🇨🇳', dialCode: '+86'),
  Country(name: 'Japan', flag: '🇯🇵', dialCode: '+81'),
  Country(name: 'Brazil', flag: '🇧🇷', dialCode: '+55'),
  Country(name: 'Mexico', flag: '🇲🇽', dialCode: '+52'),
  Country(name: 'Russia', flag: '🇷🇺', dialCode: '+7'),
  Country(name: 'Egypt', flag: '🇪🇬', dialCode: '+20'),
];
