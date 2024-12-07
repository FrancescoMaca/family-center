
bool isFamilyCodeValid(String? value) {
  
  if (value == null) {
    return false;
  }

  return value.length == 6 && RegExp(r'^[0-9]{6}$').hasMatch(value);
} 