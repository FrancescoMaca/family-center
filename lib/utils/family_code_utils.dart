
bool isFamilyCodeValid(String? value) {
  
  if (value == null) {
    return false;
  }

  return value.length == 5 && RegExp(r'^[0-9]{5}$').hasMatch(value);
} 