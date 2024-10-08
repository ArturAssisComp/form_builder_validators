// Composition validators
import '../constants.dart';

// TODO (ArturAssisComp): add the translated 'and' separator error message.
// Something like: FormBuilderLocalizations.current.andSeparator;
const String andSeparatorTemporary = ' and ';

// TODO (ArturAssisComp): add the translated 'or' separator error message.
// Something like: FormBuilderLocalizations.current.orSeparator;
const String orSeparatorTemporary = ' or ';

/// This function returns a validator that is an AND composition of `validators`.
/// The composition is done following the order of validators from `validators`.
/// If `printErrorAsSoonAsPossible` is true, it prints the error of the first
/// validator in `validators` that returns an error message. Otherwise, the
/// failure message will be composed in the following way:
/// '$prefix<msg1>$separator<msg2>$separator<msg3>...$separator<msgN>$suffix'.
/// If every validator returns null, this validator also returns null.
///
/// # Parameters
/// - String? `separator`: the separator of each validator failure message when
/// `printErrorAsSoonAsPossible` is false. By default, it is
/// `FormBuilderLocalizations.current.andSeparator`,
///
/// # Errors
/// - Throws [AssertionError] if `validators` is empty.
Validator<T> and<T extends Object>(
  List<Validator<T>> validators, {
  String prefix = '',
  String suffix = '',
  String? separator,
  bool printErrorAsSoonAsPossible = true,
}) {
  assert(validators.isNotEmpty, 'The input validators may not be empty.');
  return (T value) {
    final List<String> errorMessageBuilder = <String>[];
    for (final Validator<T> validator in validators) {
      final String? errorMessage = validator(value);
      if (errorMessage != null) {
        if (printErrorAsSoonAsPossible) {
          return errorMessage;
        }
        errorMessageBuilder.add(errorMessage);
      }
    }
    if (errorMessageBuilder.isNotEmpty) {
      return '$prefix${errorMessageBuilder.join(separator ?? andSeparatorTemporary)}$suffix';
    }

    return null;
  };
}

/// This function returns a validator that is an OR composition of `validators`.
/// The composition is done following the order of validators from `validators`.
/// The validator returns null as soon as a validator from the composition
/// returns null. Otherwise, the failure message will be composed in the
/// following way:
/// '$prefix<msg1>$separator<msg2>$separator<msg3>...$separator<msgN>$suffix'.
///
/// # Parameters
/// - String? `separator`: the separator of each validator failure message when
/// all validators fail. By default, it is
/// `FormBuilderLocalizations.current.orSeparator`,
///
/// # Errors
/// - Throws [AssertionError] if `validators` is empty.
Validator<T> or<T extends Object>(
  List<Validator<T>> validators, {
  String prefix = '',
  String suffix = '',
  String? separator,
}) {
  assert(validators.isNotEmpty, 'The input validators may not be empty.');
  return (T value) {
    final List<String> errorMessageBuilder = <String>[];
    for (final Validator<T> validator in validators) {
      final String? errorMessage = validator(value);
      if (errorMessage == null) {
        return null;
      }
      errorMessageBuilder.add(errorMessage);
    }
    return '$prefix${errorMessageBuilder.join(separator ?? orSeparatorTemporary)}$suffix';
  };
}
